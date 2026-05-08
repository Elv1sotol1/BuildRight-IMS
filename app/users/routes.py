from . import users_bp
from flask import render_template, request, redirect, url_for, flash, session
from app.auth.utils import login_required, role_required, log_audit, hash_password
from app.db import get_db
 
 
def get_all_users():
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute('SELECT user_id, username, full_name, email, role, status, last_login, created_at FROM users ORDER BY created_at DESC')
    users = cursor.fetchall()
    cursor.close()
    return users
 
 
def get_user(user_id):
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute('SELECT * FROM users WHERE user_id = %s', (user_id,))
    user = cursor.fetchone()
    cursor.close()
    return user
 
 
@users_bp.route('/')
@login_required
@role_required('Admin')
def list_users():
    users = get_all_users()
    return render_template('users/list.html', users=users)
 
 
@users_bp.route('/add', methods=['GET', 'POST'])
@login_required
@role_required('Admin')
def add_user():
    if request.method == 'POST':
        username   = request.form.get('username', '').strip()
        full_name  = request.form.get('full_name', '').strip()
        email      = request.form.get('email', '').strip()
        role       = request.form.get('role', 'Staff')
        password   = request.form.get('password', '')
 
        if not all([username, full_name, email, password]):
            flash('All fields are required.', 'danger')
            return render_template('users/form.html', action='Add', user=None)
 
        if len(password) < 8:
            flash('Password must be at least 8 characters.', 'danger')
            return render_template('users/form.html', action='Add', user=None)
 
        db = get_db()
        cursor = db.cursor()
        try:
            cursor.execute(
                'INSERT INTO users (username, full_name, email, password_hash, role, status) VALUES (%s,%s,%s,%s,%s,%s)',
                (username, full_name, email, hash_password(password), role, 'Active')
            )
            db.commit()
            new_id = cursor.lastrowid
            log_audit('CREATE_USER', 'users', new_id, None, {'username': username, 'role': role})
            flash(f'User {username} created successfully.', 'success')
            return redirect(url_for('users.list_users'))
        except Exception as e:
            db.rollback()
            if 'Duplicate' in str(e):
                flash('Username or email already exists.', 'danger')
            else:
                flash('An error occurred. Please try again.', 'danger')
        finally:
            cursor.close()
 
    return render_template('users/form.html', action='Add', user=None)
 
 
@users_bp.route('/edit/<int:user_id>', methods=['GET', 'POST'])
@login_required
@role_required('Admin')
def edit_user(user_id):
    user = get_user(user_id)
    if not user:
        flash('User not found.', 'danger')
        return redirect(url_for('users.list_users'))
 
    if request.method == 'POST':
        full_name = request.form.get('full_name', '').strip()
        email     = request.form.get('email', '').strip()
        role      = request.form.get('role', user['role'])
        new_pw    = request.form.get('password', '').strip()
 
        if not full_name or not email:
            flash('Full name and email are required.', 'danger')
            return render_template('users/form.html', action='Edit', user=user)
 
        db = get_db()
        cursor = db.cursor()
        try:
            old = {'full_name': user['full_name'], 'email': user['email'], 'role': user['role']}
            if new_pw:
                if len(new_pw) < 8:
                    flash('Password must be at least 8 characters.', 'danger')
                    return render_template('users/form.html', action='Edit', user=user)
                cursor.execute(
                    'UPDATE users SET full_name=%s, email=%s, role=%s, password_hash=%s WHERE user_id=%s',
                    (full_name, email, role, hash_password(new_pw), user_id)
                )
            else:
                cursor.execute(
                    'UPDATE users SET full_name=%s, email=%s, role=%s WHERE user_id=%s',
                    (full_name, email, role, user_id)
                )
            db.commit()
            log_audit('UPDATE_USER', 'users', user_id, old, {'full_name': full_name, 'email': email, 'role': role})
            flash('User updated successfully.', 'success')
            return redirect(url_for('users.list_users'))
        except Exception as e:
            db.rollback()
            if 'Duplicate' in str(e):
                flash('Email already in use.', 'danger')
            else:
                flash('An error occurred.', 'danger')
        finally:
            cursor.close()
 
    return render_template('users/form.html', action='Edit', user=user)
 
 
@users_bp.route('/toggle/<int:user_id>', methods=['POST'])
@login_required
@role_required('Admin')
def toggle_status(user_id):
    if user_id == session['user_id']:
        flash('You cannot deactivate your own account.', 'danger')
        return redirect(url_for('users.list_users'))
 
    user = get_user(user_id)
    if not user:
        flash('User not found.', 'danger')
        return redirect(url_for('users.list_users'))
 
    new_status = 'Inactive' if user['status'] == 'Active' else 'Active'
    db = get_db()
    cursor = db.cursor()
    cursor.execute('UPDATE users SET status=%s WHERE user_id=%s', (new_status, user_id))
    db.commit()
    cursor.close()
    log_audit('TOGGLE_USER_STATUS', 'users', user_id, {'status': user['status']}, {'status': new_status})
    flash(f'User {user["username"]} has been {new_status.lower()}d.', 'success')
    return redirect(url_for('users.list_users'))
 
 
@users_bp.route('/audit-log')
@login_required
@role_required('Admin')
def audit_log():
    search   = request.args.get('search', '')
    action   = request.args.get('action', '')
    page     = int(request.args.get('page', 1))
    per_page = 25
    db = get_db()
    cursor = db.cursor(dictionary=True)
    where  = ['1=1']
    params = []
    if search:
        where.append('(u.username LIKE %s OR a.record_id LIKE %s)')
        params += [f'%{search}%', f'%{search}%']
    if action:
        where.append('a.action = %s')
        params.append(action)
    where_str = ' AND '.join(where)
    cursor.execute(f'SELECT COUNT(*) as cnt FROM audit_logs a LEFT JOIN users u ON a.user_id=u.user_id WHERE {where_str}', params)
    total = cursor.fetchone()['cnt']
    offset = (page - 1) * per_page
    cursor.execute(
        f'''SELECT a.*, u.username FROM audit_logs a
            LEFT JOIN users u ON a.user_id = u.user_id
            WHERE {where_str}
            ORDER BY a.created_at DESC
            LIMIT %s OFFSET %s''',
        params + [per_page, offset]
    )
    logs = cursor.fetchall()
    cursor.execute('SELECT DISTINCT action FROM audit_logs ORDER BY action')
    actions = [r['action'] for r in cursor.fetchall()]
    cursor.close()
    total_pages = (total + per_page - 1) // per_page
    return render_template('users/audit.html',
        logs=logs, total=total, total_pages=total_pages,
        page=page, search=search, action=action, actions=actions)

