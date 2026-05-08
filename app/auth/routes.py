from . import auth_bp
from .utils import (
    check_password, get_user_by_username, get_user_by_email,
    is_account_locked, increment_failed_attempts, reset_failed_attempts,
    create_reset_token, get_valid_reset_token, mark_token_used,
    update_password, log_audit
)
from flask import render_template, request, redirect, url_for, flash, session
from datetime import datetime
 
 
@auth_bp.route('/login', methods=['GET', 'POST'])
def login():
    if 'user_id' in session:
        return redirect(url_for('main.dashboard'))
    if request.method == 'POST':
        username = request.form.get('username', '').strip()
        password = request.form.get('password', '')
        if not username or not password:
            flash('Please enter both username and password.', 'danger')
            return render_template('auth/login.html')
        user = get_user_by_username(username)
        if not user:
            flash('Invalid username or password.', 'danger')
            return render_template('auth/login.html')
        if user['status'] == 'Inactive':
            flash('Your account has been deactivated. Contact an administrator.', 'danger')
            return render_template('auth/login.html')
        if is_account_locked(user):
            flash('Account locked due to too many failed attempts. Try again in 30 minutes.', 'danger')
            return render_template('auth/login.html')
        if not check_password(password, user['password_hash']):
            attempts = increment_failed_attempts(user['user_id'])
            remaining = 5 - attempts
            if remaining > 0:
                flash(f'Invalid username or password. {remaining} attempt(s) remaining.', 'danger')
            else:
                flash('Account locked due to too many failed attempts. Try again in 30 minutes.', 'danger')
            return render_template('auth/login.html')
        reset_failed_attempts(user['user_id'])
        log_audit('LOGIN', 'users', user['user_id'])
        session.clear()
        session['user_id'] = user['user_id']
        session['username'] = user['username']
        session['full_name'] = user['full_name']
        session['role'] = user['role']
        session['last_active'] = datetime.now().isoformat()
        session.permanent = True
        return redirect(url_for('main.dashboard'))
    return render_template('auth/login.html')
 
 
@auth_bp.route('/logout')
def logout():
    if 'user_id' in session:
        log_audit('LOGOUT', 'users', session['user_id'])
    session.clear()
    flash('You have been logged out.', 'info')
    return redirect(url_for('auth.login'))
 
 
@auth_bp.route('/forgot-password', methods=['GET', 'POST'])
def forgot_password():
    if request.method == 'POST':
        email = request.form.get('email', '').strip()
        user = get_user_by_email(email)
        if user:
            token = create_reset_token(user['user_id'])
            reset_link = url_for('auth.reset_password', token=token, _external=True)
            flash(f'Reset link (dev mode): {reset_link}', 'info')
        else:
            flash('If that email exists, a reset link has been sent.', 'info')
        return redirect(url_for('auth.login'))
    return render_template('auth/forgot_password.html')
 
 
@auth_bp.route('/reset-password/<token>', methods=['GET', 'POST'])
def reset_password(token):
    token_record = get_valid_reset_token(token)
    if not token_record:
        flash('This reset link is invalid or has expired.', 'danger')
        return redirect(url_for('auth.forgot_password'))
    if request.method == 'POST':
        password = request.form.get('password', '')
        confirm = request.form.get('confirm_password', '')
        if len(password) < 8:
            flash('Password must be at least 8 characters.', 'danger')
            return render_template('auth/reset_password.html', token=token)
        if password != confirm:
            flash('Passwords do not match.', 'danger')
            return render_template('auth/reset_password.html', token=token)
        update_password(token_record['user_id'], password)
        mark_token_used(token_record['token_id'])
        log_audit('PASSWORD_RESET', 'users', token_record['user_id'])
        flash('Password updated successfully. Please log in.', 'success')
        return redirect(url_for('auth.login'))
    return render_template('auth/reset_password.html', token=token)
