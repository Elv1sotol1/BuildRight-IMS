from . import main_bp
from flask import render_template, session, redirect, url_for, request, flash
from app.auth.utils import login_required, log_audit, check_password, hash_password
from app.db import get_db
 
 
@main_bp.route('/')
def index():
    return redirect(url_for('auth.login'))
 
 
@main_bp.route('/dashboard')
@login_required
def dashboard():
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute('SELECT COUNT(*) as cnt FROM inventory_items WHERE status != %s', ('Discontinued',))
    total_items = cursor.fetchone()['cnt']
    cursor.execute('SELECT COALESCE(SUM(current_stock * unit_cost), 0) as val FROM inventory_items WHERE status != %s', ('Discontinued',))
    total_value = cursor.fetchone()['val']
    cursor.execute('SELECT COUNT(*) as cnt FROM inventory_items WHERE current_stock <= reorder_level AND status = %s', ('Active',))
    low_stock_count = cursor.fetchone()['cnt']
    cursor.execute('SELECT COUNT(*) as cnt FROM transactions')
    total_transactions = cursor.fetchone()['cnt']
    cursor.execute(
        '''SELECT i.item_id, i.name, i.current_stock, i.reorder_level, i.unit_of_measure,
           c.name as category_name FROM inventory_items i
           JOIN categories c ON i.category_id = c.category_id
           WHERE i.current_stock <= i.reorder_level AND i.status = %s
           ORDER BY i.current_stock ASC LIMIT 10''', ('Active',))
    low_stock_items = cursor.fetchall()
    cursor.execute(
        '''SELECT t.*, i.name as item_name, i.unit_of_measure, u.username
           FROM transactions t
           JOIN inventory_items i ON t.item_id = i.item_id
           JOIN users u ON t.performed_by = u.user_id
           ORDER BY t.created_at DESC LIMIT 8''')
    recent_transactions = cursor.fetchall()
    cursor.execute(
        '''SELECT c.name as category, COUNT(i.item_id) as count,
           COALESCE(SUM(i.current_stock * i.unit_cost), 0) as value
           FROM categories c
           LEFT JOIN inventory_items i ON c.category_id = i.category_id AND i.status != %s
           GROUP BY c.category_id, c.name HAVING count > 0
           ORDER BY value DESC''', ('Discontinued',))
    category_data = cursor.fetchall()
    cursor.close()
    return render_template('main/dashboard.html',
        total_items=total_items, total_value=total_value,
        low_stock_count=low_stock_count, total_transactions=total_transactions,
        low_stock_items=low_stock_items, recent_transactions=recent_transactions,
        category_data=category_data)
 
 
@main_bp.route('/profile', methods=['GET', 'POST'])
@login_required
def profile():
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute('SELECT * FROM users WHERE user_id=%s', (session['user_id'],))
    user = cursor.fetchone()
    cursor.close()
    if request.method == 'POST':
        current_pw  = request.form.get('current_password', '')
        new_pw      = request.form.get('new_password', '')
        confirm_pw  = request.form.get('confirm_password', '')
        if not check_password(current_pw, user['password_hash']):
            flash('Current password is incorrect.', 'danger')
            return render_template('main/profile.html', user=user)
        if len(new_pw) < 8:
            flash('New password must be at least 8 characters.', 'danger')
            return render_template('main/profile.html', user=user)
        if new_pw != confirm_pw:
            flash('New passwords do not match.', 'danger')
            return render_template('main/profile.html', user=user)
        cursor = db.cursor()
        cursor.execute('UPDATE users SET password_hash=%s WHERE user_id=%s',
            (hash_password(new_pw), session['user_id']))
        db.commit()
        cursor.close()
        log_audit('PASSWORD_CHANGE', 'users', session['user_id'])
        flash('Password updated successfully.', 'success')
        return redirect(url_for('main.profile'))
    return render_template('main/profile.html', user=user)
