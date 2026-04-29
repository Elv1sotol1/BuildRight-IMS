import bcrypt
import secrets
from datetime import datetime, timedelta
from functools import wraps
from flask import session, redirect, url_for, flash, request, current_app
from app.db import get_db
 
 
def hash_password(password):
    return bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')
 
 
def check_password(password, hashed):
    return bcrypt.checkpw(password.encode('utf-8'), hashed.encode('utf-8'))
 
 
def login_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        if 'user_id' not in session:
            flash('Please log in to access this page.', 'warning')
            return redirect(url_for('auth.login'))
        if _session_expired():
            session.clear()
            flash('Your session has expired. Please log in again.', 'warning')
            return redirect(url_for('auth.login'))
        session['last_active'] = datetime.now().isoformat()
        return f(*args, **kwargs)
    return decorated
 
 
def role_required(*roles):
    def decorator(f):
        @wraps(f)
        def decorated(*args, **kwargs):
            if 'user_id' not in session:
                flash('Please log in to access this page.', 'warning')
                return redirect(url_for('auth.login'))
            if session.get('role') not in roles:
                flash('You do not have permission to access this page.', 'danger')
                return redirect(url_for('main.dashboard'))
            return f(*args, **kwargs)
        return decorated
    return decorator
 
 
def _session_expired():
    last_active = session.get('last_active')
    if not last_active:
        return True
    last_active_dt = datetime.fromisoformat(last_active)
    timeout = timedelta(minutes=current_app.config['SESSION_TIMEOUT_MINUTES'])
    return datetime.now() - last_active_dt > timeout
 
 
def get_user_by_username(username):
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute('SELECT * FROM users WHERE username = %s', (username,))
    user = cursor.fetchone()
    cursor.close()
    return user

def get_user_by_email(email):
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute('SELECT * FROM users WHERE email = %s', (email,))
    user = cursor.fetchone()
    cursor.close()
    return user
 
 
def get_user_by_id(user_id):
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute('SELECT * FROM users WHERE user_id = %s', (user_id,))
    user = cursor.fetchone()
    cursor.close()
    return user
 
 
def is_account_locked(user):
    if user['locked_until'] and datetime.now() < user['locked_until']:
        return True
    return False
 
 
def increment_failed_attempts(user_id):
    db = get_db()
    cursor = db.cursor()
    max_attempts = current_app.config['MAX_LOGIN_ATTEMPTS']
    cursor.execute(
        'UPDATE users SET failed_login_attempts = failed_login_attempts + 1 WHERE user_id = %s',
        (user_id,)
    )
    cursor.execute('SELECT failed_login_attempts FROM users WHERE user_id = %s', (user_id,))
    attempts = cursor.fetchone()[0]
    if attempts >= max_attempts:
        locked_until = datetime.now() + timedelta(minutes=30)
        cursor.execute(
            'UPDATE users SET locked_until = %s WHERE user_id = %s',
            (locked_until, user_id)
        )
    db.commit()
    cursor.close()
    return attempts
 
 
def reset_failed_attempts(user_id):
    db = get_db()
    cursor = db.cursor()
    cursor.execute(
        'UPDATE users SET failed_login_attempts = 0, locked_until = NULL, last_login = %s WHERE user_id = %s',
        (datetime.now(), user_id)
    )
    db.commit()
    cursor.close()
 
 
def create_reset_token(user_id):
    token = secrets.token_urlsafe(32)
    expires_at = datetime.now() + timedelta(hours=1)
    db = get_db()
    cursor = db.cursor()
    cursor.execute(
        'INSERT INTO password_reset_tokens (user_id, token, expires_at) VALUES (%s, %s, %s)',
        (user_id, token, expires_at)
    )
    db.commit()
    cursor.close()
    return token

def get_valid_reset_token(token):
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute(
        'SELECT * FROM password_reset_tokens WHERE token = %s AND used = 0 AND expires_at > %s',
        (token, datetime.now())
    )
    row = cursor.fetchone()
    cursor.close()
    return row
 
 
def mark_token_used(token_id):
    db = get_db()
    cursor = db.cursor()
    cursor.execute('UPDATE password_reset_tokens SET used = 1 WHERE token_id = %s', (token_id,))
    db.commit()
    cursor.close()
 
 
def update_password(user_id, new_password):
    db = get_db()
    cursor = db.cursor()
    cursor.execute(
        'UPDATE users SET password_hash = %s WHERE user_id = %s',
        (hash_password(new_password), user_id)
    )
    db.commit()
    cursor.close()
 
 
def log_audit(action, table_name, record_id=None, old_values=None, new_values=None):
    import json
    db = get_db()
    cursor = db.cursor()
    user_id = session.get('user_id')
    ip = request.remote_addr
    cursor.execute(
        '''INSERT INTO audit_logs (user_id, action, table_name, record_id, old_values, new_values, ip_address)
           VALUES (%s, %s, %s, %s, %s, %s, %s)''',
        (
            user_id, action, table_name, str(record_id) if record_id else None,
            json.dumps(old_values) if old_values else None,
            json.dumps(new_values) if new_values else None,
            ip
        )
    )
    db.commit()
    cursor.close()


