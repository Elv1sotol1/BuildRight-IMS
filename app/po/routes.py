from . import po_bp
from .utils import generate_po_number, get_po, get_all_pos
from flask import render_template, request, redirect, url_for, flash, session
from app.auth.utils import login_required, role_required, log_audit
from app.db import get_db
from app.inventory.utils import get_suppliers, get_items
from datetime import date
from app.email_utils import notify_po_submitted, notify_po_approved
 
 
def get_sites():
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute("SELECT * FROM sites WHERE status='Active' ORDER BY name")
    rows = cursor.fetchall()
    cursor.close()
    return rows
 
 
@po_bp.route('/')
@login_required
def list_pos():
    status  = request.args.get('status', '')
    search  = request.args.get('search', '')
    page    = int(request.args.get('page', 1))
    pos, total, total_pages = get_all_pos(status, search, page)
    return render_template('po/list.html', pos=pos, total=total,
        total_pages=total_pages, page=page, status=status, search=search)
 
 
@po_bp.route('/create', methods=['GET', 'POST'])
@login_required
def create_po():
    suppliers = get_suppliers()
    sites     = get_sites()
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute("SELECT item_id, name, unit_of_measure, unit_cost FROM inventory_items WHERE status='Active' ORDER BY name")
    items = cursor.fetchall()
    cursor.close()
    if request.method == 'POST':
        supplier_id   = request.form.get('supplier_id')
        site_id       = request.form.get('site_id') or None
        expected_date = request.form.get('expected_date') or None
        notes         = request.form.get('notes', '').strip()
        item_ids      = request.form.getlist('item_id[]')
        quantities    = request.form.getlist('quantity[]')
        unit_costs    = request.form.getlist('unit_cost[]')
        if not supplier_id or not item_ids:
            flash('Supplier and at least one item are required.', 'danger')
            return render_template('po/form.html', suppliers=suppliers, sites=sites, items=items)
        po_number = generate_po_number()
        db = get_db()
        cursor = db.cursor()
        try:
            cursor.execute(
                '''INSERT INTO purchase_orders
                   (po_number, supplier_id, site_id, status, requested_by, expected_date, notes)
                   VALUES (%s,%s,%s,%s,%s,%s,%s)''',
                (po_number, supplier_id, site_id, 'Pending Approval',
                 session['user_id'], expected_date, notes or None)
            )
            po_id = cursor.lastrowid
            total_amount = 0
            for i, item_id in enumerate(item_ids):
                if not item_id:
                    continue
                qty  = int(quantities[i]) if quantities[i] else 0
                cost = float(unit_costs[i]) if unit_costs[i] else 0
                if qty > 0:
                    cursor.execute(
                        'INSERT INTO po_items (po_id, item_id, quantity_ordered, unit_cost) VALUES (%s,%s,%s,%s)',
                        (po_id, item_id, qty, cost)
                    )
                    total_amount += qty * cost
            cursor.execute('UPDATE purchase_orders SET total_amount=%s WHERE po_id=%s', (total_amount, po_id))
            db.commit()
            log_audit('CREATE_PO', 'purchase_orders', po_id, None, {'po_number': po_number})
            flash(f'Purchase Order {po_number} submitted for approval.', 'success')
            notify_po_submitted(
                po_number,
                next(s['name'] for s in get_suppliers() if str(s['supplier_id']) == supplier_id),
                total_amount,
                session['username']
            )
            return redirect(url_for('po.list_pos'))

        except Exception as e:
            db.rollback()
            flash(f'Error creating PO: {str(e)}', 'danger')
        finally:
            cursor.close()
    return render_template('po/form.html', suppliers=suppliers, sites=sites, items=items)
 
 
@po_bp.route('/view/<int:po_id>')
@login_required
def view_po(po_id):
    po = get_po(po_id)
    if not po:
        flash('Purchase Order not found.', 'danger')
        return redirect(url_for('po.list_pos'))
    return render_template('po/view.html', po=po)
 
 
@po_bp.route('/approve/<int:po_id>', methods=['POST'])
@login_required
@role_required('Admin', 'Manager')
def approve_po(po_id):
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute(
    '''SELECT p.*, s.name as supplier_name
       FROM purchase_orders p
       JOIN suppliers s ON p.supplier_id = s.supplier_id
       WHERE p.po_id=%s''',
    (po_id,)
)
    po = cursor.fetchone()
    if not po or po['status'] != 'Pending Approval':
        flash('PO not found or not pending approval.', 'danger')
        cursor.close()
        return redirect(url_for('po.list_pos'))
    cursor.execute(
        'UPDATE purchase_orders SET status=%s, approved_by=%s, approved_at=NOW() WHERE po_id=%s',
        ('Approved', session['user_id'], po_id)
    )
    db.commit()
    log_audit('APPROVE_PO', 'purchase_orders', po_id)
    po_number = po['po_number']
    supplier_name = po['supplier_name']
    total_amount = float(po['total_amount'])
    cursor.close()
    notify_po_approved(po_number, supplier_name, total_amount, session['username'])
    flash(f'Purchase Order {po_number} approved.', 'success')
    return redirect(url_for('po.view_po', po_id=po_id))

@po_bp.route('/reject/<int:po_id>', methods=['POST'])
@login_required
@role_required('Admin', 'Manager')
def reject_po(po_id):
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute(
    '''SELECT p.*, s.name as supplier_name 
       FROM purchase_orders p 
       JOIN suppliers s ON p.supplier_id = s.supplier_id 
       WHERE p.po_id=%s''',
    (po_id,)
)
    po = cursor.fetchone()
    cursor.execute('UPDATE purchase_orders SET status=%s WHERE po_id=%s', ('Cancelled', po_id))
    db.commit()
    log_audit('REJECT_PO', 'purchase_orders', po_id)
    flash(f'Purchase Order {po["po_number"]} rejected and cancelled.', 'warning')
    cursor.close()
    return redirect(url_for('po.list_pos'))
 
 
@po_bp.route('/receive/<int:po_id>', methods=['GET', 'POST'])
@login_required
@role_required('Admin', 'Manager')
def receive_po(po_id):
    po = get_po(po_id)
    if not po or po['status'] not in ('Approved', 'Partially Received'):
        flash('PO must be approved before receiving stock.', 'danger')
        return redirect(url_for('po.list_pos'))
    if request.method == 'POST':
        db = get_db()
        cursor = db.cursor(dictionary=True)
        try:
            all_received = True
            for item in po['items']:
                field_key = f'received_{item["po_item_id"]}'
                qty_received = int(request.form.get(field_key, 0))
                if qty_received <= 0:
                    all_received = False
                    continue
                remaining = item['quantity_ordered'] - item['quantity_received']
                qty_received = min(qty_received, remaining)
                if qty_received <= 0:
                    continue
                cursor.execute(
                    'UPDATE po_items SET quantity_received = quantity_received + %s WHERE po_item_id=%s',
                    (qty_received, item['po_item_id'])
                )
                cursor.execute(
                    'UPDATE inventory_items SET current_stock = current_stock + %s WHERE item_id=%s',
                    (qty_received, item['item_id'])
                )
                cursor.execute(
                    '''INSERT INTO transactions
                       (item_id, transaction_type, sub_type, quantity, unit_cost,
                        reference_number, notes, transaction_date, performed_by)
                       VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s)''',
                    (item['item_id'], 'Inflow', 'Purchase',
                     qty_received, item['unit_cost'],
                     po['po_number'], f'Received from PO {po["po_number"]}',
                     date.today().isoformat(), session['user_id'])
                )
                cursor.execute(
                    'SELECT quantity_ordered, quantity_received FROM po_items WHERE po_item_id=%s',
                    (item['po_item_id'],)
                )
                updated = cursor.fetchone()
                if updated['quantity_received'] < updated['quantity_ordered']:
                    all_received = False
            new_status = 'Received' if all_received else 'Partially Received'
            cursor.execute('UPDATE purchase_orders SET status=%s WHERE po_id=%s', (new_status, po_id))
            db.commit()
            cursor.close()
            log_audit('RECEIVE_PO', 'purchase_orders', po_id, None, {'status': new_status})
            flash(f'Stock received. PO status updated to {new_status}.', 'success')
            return redirect(url_for('po.view_po', po_id=po_id))
        except Exception as e:
            db.rollback()
            cursor.close()
            flash(f'Error receiving stock: {str(e)}', 'danger')
    return render_template('po/receive.html', po=po)
