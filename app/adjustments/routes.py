from . import adjustments_bp
from flask import render_template, request, redirect, url_for, flash, session
from app.auth.utils import login_required, role_required, log_audit
from app.db import get_db
from app.inventory.utils import get_items
from datetime import date
 
 
@adjustments_bp.route('/')
@login_required
def list_adjustments():
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute(
        '''SELECT a.*, i.name as item_name, i.unit_of_measure,
           u.username as requested_by_name,
           ap.username as approved_by_name
           FROM stock_adjustments a
           JOIN inventory_items i ON a.item_id = i.item_id
           JOIN users u ON a.requested_by = u.user_id
           LEFT JOIN users ap ON a.approved_by = ap.user_id
           ORDER BY a.created_at DESC'''
    )
    adjustments = cursor.fetchall()
    cursor.close()
    return render_template('adjustments/list.html', adjustments=adjustments)
 
 
@adjustments_bp.route('/request', methods=['GET', 'POST'])
@login_required
def request_adjustment():
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute("SELECT item_id, name, unit_of_measure, current_stock FROM inventory_items WHERE status='Active' ORDER BY name")
    items = cursor.fetchall()
    cursor.close()
    if request.method == 'POST':
        item_id   = request.form.get('item_id')
        adj_type  = request.form.get('adjustment_type')
        quantity  = int(request.form.get('quantity', 0))
        reason    = request.form.get('reason', '').strip()
        notes     = request.form.get('notes', '').strip()
        if not all([item_id, adj_type, reason]) or quantity <= 0:
            flash('All fields are required and quantity must be greater than 0.', 'danger')
            return render_template('adjustments/form.html', items=items)
        db = get_db()
        cursor = db.cursor()
        try:
            cursor.execute(
                '''INSERT INTO stock_adjustments
                   (item_id, adjustment_type, quantity, reason, notes, requested_by)
                   VALUES (%s,%s,%s,%s,%s,%s)''',
                (item_id, adj_type, quantity, reason, notes or None, session['user_id'])
            )
            db.commit()
            log_audit('REQUEST_ADJUSTMENT', 'stock_adjustments', cursor.lastrowid,
                None, {'item_id': item_id, 'type': adj_type, 'quantity': quantity})
            flash('Stock adjustment request submitted for approval.', 'success')
            return redirect(url_for('adjustments.list_adjustments'))
        except Exception as e:
            db.rollback()
            flash('An error occurred.', 'danger')
        finally:
            cursor.close()
    return render_template('adjustments/form.html', items=items)
 
 
@adjustments_bp.route('/approve/<int:adjustment_id>', methods=['POST'])
@login_required
@role_required('Admin', 'Manager')
def approve_adjustment(adjustment_id):
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute('SELECT * FROM stock_adjustments WHERE adjustment_id=%s', (adjustment_id,))
    adj = cursor.fetchone()
    if not adj or adj['status'] != 'Pending':
        flash('Adjustment not found or already processed.', 'danger')
        cursor.close()
        return redirect(url_for('adjustments.list_adjustments'))
    try:
        if adj['adjustment_type'] == 'Increase':
            cursor.execute(
                'UPDATE inventory_items SET current_stock = current_stock + %s WHERE item_id=%s',
                (adj['quantity'], adj['item_id'])
            )
        else:
            cursor.execute('SELECT current_stock FROM inventory_items WHERE item_id=%s', (adj['item_id'],))
            stock = cursor.fetchone()['current_stock']
            if stock < adj['quantity']:
                flash(f'Cannot approve: insufficient stock. Available: {stock}', 'danger')
                cursor.close()
                return redirect(url_for('adjustments.list_adjustments'))
            cursor.execute(
                'UPDATE inventory_items SET current_stock = current_stock - %s WHERE item_id=%s',
                (adj['quantity'], adj['item_id'])
            )
        cursor.execute(
            '''INSERT INTO transactions
               (item_id, transaction_type, sub_type, quantity, unit_cost,
                reference_number, notes, transaction_date, performed_by)
               SELECT item_id,
               CASE WHEN adjustment_type='Increase' THEN 'Inflow' ELSE 'Outflow' END,
               'Adjustment', quantity, 0,
               CONCAT('ADJ-', adjustment_id), reason, CURDATE(), %s
               FROM stock_adjustments WHERE adjustment_id=%s''',
            (session['user_id'], adjustment_id)
        )
        cursor.execute(
            'UPDATE stock_adjustments SET status=%s, approved_by=%s, approved_at=NOW() WHERE adjustment_id=%s',
            ('Approved', session['user_id'], adjustment_id)
        )
        db.commit()
        log_audit('APPROVE_ADJUSTMENT', 'stock_adjustments', adjustment_id)
        flash('Adjustment approved and stock updated.', 'success')
    except Exception as e:
        db.rollback()
        flash('An error occurred.', 'danger')
    finally:
        cursor.close()
    return redirect(url_for('adjustments.list_adjustments'))
 
 
@adjustments_bp.route('/reject/<int:adjustment_id>', methods=['POST'])
@login_required
@role_required('Admin', 'Manager')
def reject_adjustment(adjustment_id):
    db = get_db()
    cursor = db.cursor()
    cursor.execute(
        'UPDATE stock_adjustments SET status=%s WHERE adjustment_id=%s AND status=%s',
        ('Rejected', adjustment_id, 'Pending')
    )
    db.commit()
    cursor.close()
    log_audit('REJECT_ADJUSTMENT', 'stock_adjustments', adjustment_id)
    flash('Adjustment request rejected.', 'warning')
    return redirect(url_for('adjustments.list_adjustments'))
