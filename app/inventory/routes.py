from . import inventory_bp
from .utils import (
    get_items, get_item, get_categories, get_suppliers,
    generate_item_id, save_image, delete_image, PER_PAGE
)
from flask import render_template, request, redirect, url_for, flash, session, jsonify
from app.auth.utils import login_required, role_required, log_audit
from app.db import get_db
from datetime import date
 
 
@inventory_bp.route('/')
@login_required
def list_items():
    search      = request.args.get('search', '')
    category_id = request.args.get('category_id', '')
    status      = request.args.get('status', '')
    page        = int(request.args.get('page', 1))
    items, total, total_pages = get_items(search, category_id, status, page)
    categories = get_categories()
    return render_template('inventory/list.html',
        items=items, total=total, total_pages=total_pages,
        page=page, search=search, category_id=category_id,
        status=status, categories=categories)
 
 
@inventory_bp.route('/add', methods=['GET', 'POST'])
@login_required
@role_required('Admin', 'Manager')
def add_item():
    categories = get_categories()
    suppliers  = get_suppliers()
    if request.method == 'POST':
        name        = request.form.get('name', '').strip()
        description = request.form.get('description', '').strip()
        category_id = request.form.get('category_id')
        unit        = request.form.get('unit_of_measure', '').strip()
        unit_cost   = request.form.get('unit_cost', 0)
        stock       = request.form.get('current_stock', 0)
        reorder     = request.form.get('reorder_level', 0)
        supplier_id = request.form.get('supplier_id') or None
        status      = request.form.get('status', 'Active')
        image_file  = request.files.get('image')
        if not name or not category_id or not unit:
            flash('Name, category and unit are required.', 'danger')
            return render_template('inventory/form.html', action='Add', item=None,
                categories=categories, suppliers=suppliers)
        item_id    = generate_item_id()
        image_path = save_image(image_file)
        db = get_db()
        cursor = db.cursor()
        try:
            cursor.execute(
                '''INSERT INTO inventory_items
                   (item_id, name, description, category_id, unit_of_measure, unit_cost,
                    current_stock, reorder_level, supplier_id, status, image_path, created_by)
                   VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)''',
                (item_id, name, description, category_id, unit, unit_cost,
                 stock, reorder, supplier_id, status, image_path, session['user_id'])
            )
            db.commit()
            log_audit('CREATE_ITEM', 'inventory_items', item_id, None, {'name': name})
            flash(f'Item {item_id} created successfully.', 'success')
            return redirect(url_for('inventory.list_items'))
        except Exception:
            db.rollback()
            flash('An error occurred. Please try again.', 'danger')
        finally:
            cursor.close()
    return render_template('inventory/form.html', action='Add', item=None,
        categories=categories, suppliers=suppliers)
 
 
@inventory_bp.route('/view/<item_id>')
@login_required
def view_item(item_id):
    item = get_item(item_id)
    if not item:
        flash('Item not found.', 'danger')
        return redirect(url_for('inventory.list_items'))
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute(
        '''SELECT t.*, u.username FROM transactions t
           JOIN users u ON t.performed_by = u.user_id
           WHERE t.item_id = %s ORDER BY t.created_at DESC LIMIT 20''',
        (item_id,)
    )
    history = cursor.fetchall()
    cursor.close()
    return render_template('inventory/view.html', item=item, history=history)
 
 
@inventory_bp.route('/edit/<item_id>', methods=['GET', 'POST'])
@login_required
@role_required('Admin', 'Manager')
def edit_item(item_id):
    item       = get_item(item_id)
    categories = get_categories()
    suppliers  = get_suppliers()
    if not item:
        flash('Item not found.', 'danger')
        return redirect(url_for('inventory.list_items'))
    if request.method == 'POST':
        name        = request.form.get('name', '').strip()
        description = request.form.get('description', '').strip()
        category_id = request.form.get('category_id')
        unit        = request.form.get('unit_of_measure', '').strip()
        unit_cost   = request.form.get('unit_cost', 0)
        reorder     = request.form.get('reorder_level', 0)
        supplier_id = request.form.get('supplier_id') or None
        status      = request.form.get('status', 'Active')
        image_file  = request.files.get('image')
        remove_img  = request.form.get('remove_image')
        if not name or not category_id or not unit:
            flash('Name, category and unit are required.', 'danger')
            return render_template('inventory/form.html', action='Edit', item=item,
                categories=categories, suppliers=suppliers)
        image_path = item['image_path']
        if remove_img:
            delete_image(image_path)
            image_path = None
        elif image_file and image_file.filename:
            delete_image(image_path)
            image_path = save_image(image_file)
        old = {'name': item['name'], 'status': item['status']}
        db = get_db()
        cursor = db.cursor()
        try:
            cursor.execute(
                '''UPDATE inventory_items SET name=%s, description=%s, category_id=%s,
                   unit_of_measure=%s, unit_cost=%s, reorder_level=%s,
                   supplier_id=%s, status=%s, image_path=%s WHERE item_id=%s''',
                (name, description, category_id, unit, unit_cost,
                 reorder, supplier_id, status, image_path, item_id)
            )
            db.commit()
            log_audit('UPDATE_ITEM', 'inventory_items', item_id, old, {'name': name, 'status': status})
            flash('Item updated successfully.', 'success')
            return redirect(url_for('inventory.view_item', item_id=item_id))
        except Exception:
            db.rollback()
            flash('An error occurred.', 'danger')
        finally:
            cursor.close()
    return render_template('inventory/form.html', action='Edit', item=item,
        categories=categories, suppliers=suppliers)
 
 
@inventory_bp.route('/delete/<item_id>', methods=['POST'])
@login_required
@role_required('Admin')
def delete_item(item_id):
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute('SELECT COUNT(*) as cnt FROM transactions WHERE item_id=%s', (item_id,))
    has_txn = cursor.fetchone()['cnt'] > 0
    if has_txn:
        cursor.execute('UPDATE inventory_items SET status=%s WHERE item_id=%s', ('Discontinued', item_id))
        db.commit()
        log_audit('ARCHIVE_ITEM', 'inventory_items', item_id)
        flash('Item has transaction history and has been archived instead of deleted.', 'warning')
    else:
        cursor.execute('SELECT image_path FROM inventory_items WHERE item_id=%s', (item_id,))
        row = cursor.fetchone()
        if row:
            delete_image(row['image_path'])
        cursor.execute('DELETE FROM inventory_items WHERE item_id=%s', (item_id,))
        db.commit()
        log_audit('DELETE_ITEM', 'inventory_items', item_id)
        flash('Item deleted successfully.', 'success')
    cursor.close()
    return redirect(url_for('inventory.list_items'))
 
 
@inventory_bp.route('/item-info/<item_id>')
@login_required
def item_info(item_id):
    item = get_item(item_id)
    if not item:
        return jsonify({}), 404
    return jsonify({
        'unit_cost': float(item['unit_cost']),
        'unit_of_measure': item['unit_of_measure'],
        'current_stock': item['current_stock'],
    })
 
 
@inventory_bp.route('/transactions')
@login_required
def transactions():
    search   = request.args.get('search', '')
    txn_type = request.args.get('txn_type', '')
    page     = int(request.args.get('page', 1))
    per_page = 20
    db = get_db()
    cursor = db.cursor(dictionary=True)
    where  = ['1=1']
    params = []
    if search:
        where.append('(i.name LIKE %s OR t.reference_number LIKE %s)')
        params += [f'%{search}%', f'%{search}%']
    if txn_type:
        where.append('t.transaction_type = %s')
        params.append(txn_type)
    where_str = ' AND '.join(where)
    cursor.execute(f'SELECT COUNT(*) as cnt FROM transactions t JOIN inventory_items i ON t.item_id=i.item_id WHERE {where_str}', params)
    total = cursor.fetchone()['cnt']
    offset = (page - 1) * per_page
    cursor.execute(
        f'''SELECT t.*, i.name as item_name, i.unit_of_measure, u.username
            FROM transactions t
            JOIN inventory_items i ON t.item_id = i.item_id
            JOIN users u ON t.performed_by = u.user_id
            WHERE {where_str}
            ORDER BY t.created_at DESC
            LIMIT %s OFFSET %s''',
        params + [per_page, offset]
    )
    txns = cursor.fetchall()
    cursor.close()
    total_pages = (total + per_page - 1) // per_page
    return render_template('inventory/transactions.html',
        txns=txns, total=total, total_pages=total_pages,
        page=page, search=search, txn_type=txn_type)
 
 
@inventory_bp.route('/transactions/add', methods=['GET', 'POST'])
@login_required
def add_transaction():
    all_items = []
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute("SELECT item_id, name, unit_of_measure, unit_cost, current_stock FROM inventory_items WHERE status != 'Discontinued' ORDER BY name")
    all_items = cursor.fetchall()
    cursor.close()
 
    if request.method == 'POST':
        item_id  = request.form.get('item_id')
        txn_type = request.form.get('transaction_type')
        sub_type = request.form.get('sub_type')
        quantity = int(request.form.get('quantity', 0))
        unit_cost = float(request.form.get('unit_cost', 0))
        ref      = request.form.get('reference_number', '').strip()
        notes    = request.form.get('notes', '').strip()
        txn_date = request.form.get('transaction_date')
 
        if not all([item_id, txn_type, sub_type, txn_date]) or quantity <= 0:
            flash('All fields are required and quantity must be greater than 0.', 'danger')
            return render_template('inventory/txn_form.html', items=all_items)
 
        db = get_db()
        cursor = db.cursor(dictionary=True)
        cursor.execute('SELECT current_stock FROM inventory_items WHERE item_id=%s', (item_id,))
        item_row = cursor.fetchone()
 
        if txn_type == 'Outflow' and item_row['current_stock'] < quantity:
            flash(f'Insufficient stock. Available: {item_row["current_stock"]}', 'danger')
            cursor.close()
            return render_template('inventory/txn_form.html', items=all_items)
 
        try:
            cursor.execute(
                '''INSERT INTO transactions
                   (item_id, transaction_type, sub_type, quantity, unit_cost,
                    reference_number, notes, transaction_date, performed_by)
                   VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s)''',
                (item_id, txn_type, sub_type, quantity, unit_cost,
                 ref or None, notes or None, txn_date, session['user_id'])
            )
            if txn_type == 'Inflow':
                cursor.execute(
                    'UPDATE inventory_items SET current_stock = current_stock + %s WHERE item_id=%s',
                    (quantity, item_id)
                )
            else:
                cursor.execute(
                    'UPDATE inventory_items SET current_stock = current_stock - %s WHERE item_id=%s',
                    (quantity, item_id)
                )
            cursor.execute('SELECT current_stock, reorder_level, name, unit_of_measure FROM inventory_items WHERE item_id=%s', (item_id,))
            updated = cursor.fetchone()
            db.commit()
            log_audit('TRANSACTION', 'transactions', item_id,
                None, {'type': txn_type, 'sub_type': sub_type, 'quantity': quantity})
            if updated['current_stock'] <= updated['reorder_level']:
                from app.email_utils import notify_low_stock
                notify_low_stock(
                    updated['name'],
                    updated['current_stock'],
                    updated['reorder_level'],
                    updated['unit_of_measure']
                )
                flash(f'Transaction recorded. WARNING: {updated["name"]} is at or below reorder level.', 'warning')
            else:
                flash('Transaction recorded successfully.', 'success')

            return redirect(url_for('inventory.transactions'))
        except Exception as e:
            db.rollback()
            flash('An error occurred.', 'danger')
        finally:
            cursor.close()
    return render_template('inventory/txn_form.html', items=all_items, today=date.today().isoformat())
@inventory_bp.route('/suppliers')
@login_required
@role_required('Admin', 'Manager')
def list_suppliers():
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute(
        '''SELECT s.*, COUNT(i.item_id) as item_count
           FROM suppliers s
           LEFT JOIN inventory_items i ON s.supplier_id = i.supplier_id
           GROUP BY s.supplier_id
           ORDER BY s.name'''
    )
    suppliers = cursor.fetchall()
    cursor.close()
    return render_template('inventory/suppliers.html', suppliers=suppliers)
 
 
@inventory_bp.route('/suppliers/add', methods=['GET', 'POST'])
@login_required
@role_required('Admin', 'Manager')
def add_supplier():
    if request.method == 'POST':
        name           = request.form.get('name', '').strip()
        contact_person = request.form.get('contact_person', '').strip()
        phone          = request.form.get('phone', '').strip()
        email          = request.form.get('email', '').strip()
        address        = request.form.get('address', '').strip()
        if not name:
            flash('Supplier name is required.', 'danger')
            return render_template('inventory/supplier_form.html', action='Add', supplier=None)
        db = get_db()
        cursor = db.cursor()
        try:
            cursor.execute(
                'INSERT INTO suppliers (name, contact_person, phone, email, address) VALUES (%s,%s,%s,%s,%s)',
                (name, contact_person or None, phone or None, email or None, address or None)
            )
            db.commit()
            log_audit('CREATE_SUPPLIER', 'suppliers', cursor.lastrowid, None, {'name': name})
            flash(f'Supplier {name} added successfully.', 'success')
            return redirect(url_for('inventory.list_suppliers'))
        except Exception as e:
            db.rollback()
            if 'Duplicate' in str(e):
                flash('A supplier with that name already exists.', 'danger')
            else:
                flash('An error occurred.', 'danger')
        finally:
            cursor.close()
    return render_template('inventory/supplier_form.html', action='Add', supplier=None)
 
 
@inventory_bp.route('/suppliers/edit/<int:supplier_id>', methods=['GET', 'POST'])
@login_required
@role_required('Admin', 'Manager')
def edit_supplier(supplier_id):
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute('SELECT * FROM suppliers WHERE supplier_id=%s', (supplier_id,))
    supplier = cursor.fetchone()
    cursor.close()
    if not supplier:
        flash('Supplier not found.', 'danger')
        return redirect(url_for('inventory.list_suppliers'))
    if request.method == 'POST':
        name           = request.form.get('name', '').strip()
        contact_person = request.form.get('contact_person', '').strip()
        phone          = request.form.get('phone', '').strip()
        email          = request.form.get('email', '').strip()
        address        = request.form.get('address', '').strip()
        if not name:
            flash('Supplier name is required.', 'danger')
            return render_template('inventory/supplier_form.html', action='Edit', supplier=supplier)
        db = get_db()
        cursor = db.cursor()
        try:
            cursor.execute(
                'UPDATE suppliers SET name=%s, contact_person=%s, phone=%s, email=%s, address=%s WHERE supplier_id=%s',
                (name, contact_person or None, phone or None, email or None, address or None, supplier_id)
            )
            db.commit()
            log_audit('UPDATE_SUPPLIER', 'suppliers', supplier_id, {'name': supplier['name']}, {'name': name})
            flash('Supplier updated successfully.', 'success')
            return redirect(url_for('inventory.list_suppliers'))
        except Exception:
            db.rollback()
            flash('An error occurred.', 'danger')
        finally:
            cursor.close()
    return render_template('inventory/supplier_form.html', action='Edit', supplier=supplier)
 
@inventory_bp.route('/suppliers/delete/<int:supplier_id>', methods=['POST'])
@login_required
@role_required('Admin')
def delete_supplier(supplier_id):
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute('SELECT COUNT(*) as cnt FROM inventory_items WHERE supplier_id=%s', (supplier_id,))
    has_items = cursor.fetchone()['cnt'] > 0
    if has_items:
        flash('Cannot delete supplier with linked inventory items. Reassign items first.', 'danger')
        cursor.close()
        return redirect(url_for('inventory.list_suppliers'))
    cursor.execute('DELETE FROM suppliers WHERE supplier_id=%s', (supplier_id,))
    db.commit()
    log_audit('DELETE_SUPPLIER', 'suppliers', supplier_id)
    flash('Supplier deleted.', 'success')
    cursor.close()
    return redirect(url_for('inventory.list_suppliers'))
@inventory_bp.route('/force-delete/<item_id>', methods=['POST'])
@login_required
@role_required('Admin')
def force_delete_item(item_id):
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute('SELECT image_path FROM inventory_items WHERE item_id=%s', (item_id,))
    row = cursor.fetchone()
    if not row:
        flash('Item not found.', 'danger')
        cursor.close()
        return redirect(url_for('inventory.list_items'))
    cursor.execute('DELETE FROM transactions WHERE item_id=%s', (item_id,))
    cursor.execute('DELETE FROM inventory_items WHERE item_id=%s', (item_id,))
    db.commit()
    if row['image_path']:
        delete_image(row['image_path'])
    log_audit('FORCE_DELETE_ITEM', 'inventory_items', item_id)
    flash('Item and all its transaction history permanently deleted.', 'success')
    cursor.close()
    return redirect(url_for('inventory.list_items'))


@inventory_bp.route('/categories')
@login_required
@role_required('Admin')
def list_categories():
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute(
        '''SELECT c.*, COUNT(i.item_id) as item_count
           FROM categories c
           LEFT JOIN inventory_items i ON c.category_id = i.category_id
           GROUP BY c.category_id ORDER BY c.name'''
    )
    categories = cursor.fetchall()
    cursor.close()
    return render_template('inventory/categories.html', categories=categories)
 
 
@inventory_bp.route('/categories/add', methods=['POST'])
@login_required
@role_required('Admin')
def add_category():
    name = request.form.get('name', '').strip()
    description = request.form.get('description', '').strip()
    if not name:
        flash('Category name is required.', 'danger')
        return redirect(url_for('inventory.list_categories'))
    db = get_db()
    cursor = db.cursor()
    try:
        cursor.execute(
            'INSERT INTO categories (name, description) VALUES (%s, %s)',
            (name, description or None)
        )
        db.commit()
        flash(f'Category {name} added.', 'success')
    except Exception:
        db.rollback()
        flash('Category already exists or an error occurred.', 'danger')
    finally:
        cursor.close()
    return redirect(url_for('inventory.list_categories'))
 
 
@inventory_bp.route('/categories/delete/<int:category_id>', methods=['POST'])
@login_required
@role_required('Admin')
def delete_category(category_id):
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute('SELECT COUNT(*) as cnt FROM inventory_items WHERE category_id=%s', (category_id,))
    if cursor.fetchone()['cnt'] > 0:
        flash('Cannot delete a category that has items. Reassign items first.', 'danger')
        cursor.close()
        return redirect(url_for('inventory.list_categories'))
    cursor.execute('DELETE FROM categories WHERE category_id=%s', (category_id,))
    db.commit()
    flash('Category deleted.', 'success')
    cursor.close()
    return redirect(url_for('inventory.list_categories'))

@inventory_bp.route('/sites')
@login_required
@role_required('Admin', 'Manager')
def list_sites():
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute(
        '''SELECT s.*, COUNT(i.item_id) as item_count
           FROM sites s
           LEFT JOIN inventory_items i ON s.site_id = i.site_id
           GROUP BY s.site_id ORDER BY s.name'''
    )
    sites = cursor.fetchall()
    cursor.close()
    return render_template('inventory/sites.html', sites=sites)
 
 
@inventory_bp.route('/sites/add', methods=['POST'])
@login_required
@role_required('Admin')
def add_site():
    name     = request.form.get('name', '').strip()
    location = request.form.get('location', '').strip()
    if not name:
        flash('Site name is required.', 'danger')
        return redirect(url_for('inventory.list_sites'))
    db = get_db()
    cursor = db.cursor()
    try:
        cursor.execute(
            'INSERT INTO sites (name, location, status) VALUES (%s, %s, %s)',
            (name, location or None, 'Active')
        )
        db.commit()
        log_audit('CREATE_SITE', 'sites', cursor.lastrowid, None, {'name': name})
        flash(f'Site {name} added.', 'success')
    except Exception:
        db.rollback()
        flash('An error occurred or site already exists.', 'danger')
    finally:
        cursor.close()
    return redirect(url_for('inventory.list_sites'))
 
 
@inventory_bp.route('/sites/toggle/<int:site_id>', methods=['POST'])
@login_required
@role_required('Admin')
def toggle_site(site_id):
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute('SELECT status FROM sites WHERE site_id=%s', (site_id,))
    site = cursor.fetchone()
    if site:
        new_status = 'Inactive' if site['status'] == 'Active' else 'Active'
        cursor.execute('UPDATE sites SET status=%s WHERE site_id=%s', (new_status, site_id))
        db.commit()
        flash(f'Site status updated to {new_status}.', 'success')
    cursor.close()
    return redirect(url_for('inventory.list_sites'))

@inventory_bp.route('/suppliers/performance')
@login_required
@role_required('Admin', 'Manager')
def supplier_performance():
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute(
        '''SELECT s.supplier_id, s.name, s.contact_person, s.phone,
           COUNT(DISTINCT p.po_id) as total_pos,
           SUM(CASE WHEN p.status='Received' THEN 1 ELSE 0 END) as completed_pos,
           SUM(CASE WHEN p.status='Cancelled' THEN 1 ELSE 0 END) as cancelled_pos,
           SUM(CASE WHEN p.status IN ('Approved','Partially Received') THEN 1 ELSE 0 END) as pending_pos,
           COALESCE(SUM(p.total_amount),0) as total_value,
           COUNT(DISTINCT i.item_id) as linked_items
           FROM suppliers s
           LEFT JOIN purchase_orders p ON s.supplier_id = p.supplier_id
           LEFT JOIN inventory_items i ON s.supplier_id = i.supplier_id
           GROUP BY s.supplier_id, s.name, s.contact_person, s.phone
           ORDER BY total_value DESC'''
    )
    suppliers = cursor.fetchall()
    cursor.close()
    return render_template('inventory/supplier_performance.html', suppliers=suppliers)
