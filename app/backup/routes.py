from . import backup_bp
from .utils import run_backup, get_backups, get_backup_dir, delete_old_backups
from flask import render_template, request, redirect, url_for, flash, session, send_file
from app.auth.utils import login_required, role_required, log_audit
from app.db import get_db
import os
import subprocess
from datetime import datetime
 
 
@backup_bp.route('/')
@login_required
@role_required('Admin')
def index():
    backups = get_backups()
    backup_dir = get_backup_dir()
    for b in backups:
        path = os.path.join(backup_dir, b['filename'])
        b['file_exists'] = os.path.exists(path)
    return render_template('backup/index.html', backups=backups)
 
 
@backup_bp.route('/run', methods=['POST'])
@login_required
@role_required('Admin')
def run():
    filename, error = run_backup(backup_type='Manual', performed_by=session['user_id'])
    if error:
        flash(f'Backup failed: {error}', 'danger')
    else:
        log_audit('BACKUP', 'backups', None, None, {'filename': filename})
        flash(f'Backup created successfully: {filename}', 'success')
    return redirect(url_for('backup.index'))
 
 
@backup_bp.route('/download/<filename>')
@login_required
@role_required('Admin')
def download(filename):
    backup_dir = get_backup_dir()
    filepath = os.path.join(backup_dir, filename)
    if not os.path.exists(filepath):
        flash('Backup file not found.', 'danger')
        return redirect(url_for('backup.index'))
    return send_file(filepath, as_attachment=True, download_name=filename)
 
 
@backup_bp.route('/delete/<int:backup_id>', methods=['POST'])
@login_required
@role_required('Admin')
def delete(backup_id):
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute('SELECT filename FROM backups WHERE backup_id=%s', (backup_id,))
    row = cursor.fetchone()
    if row:
        path = os.path.join(get_backup_dir(), row['filename'])
        if os.path.exists(path):
            os.remove(path)
        cursor.execute('DELETE FROM backups WHERE backup_id=%s', (backup_id,))
        db.commit()
        log_audit('DELETE_BACKUP', 'backups', backup_id)
        flash('Backup deleted.', 'success')
    else:
        flash('Backup not found.', 'danger')
    cursor.close()
    return redirect(url_for('backup.index'))
 
 
@backup_bp.route('/restore/<int:backup_id>', methods=['POST'])
@login_required
@role_required('Admin')
def restore(backup_id):
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute('SELECT filename FROM backups WHERE backup_id=%s', (backup_id,))
    row = cursor.fetchone()
    cursor.close()
    if not row:
        flash('Backup not found.', 'danger')
        return redirect(url_for('backup.index'))
    filepath = os.path.join(get_backup_dir(), row['filename'])
    if not os.path.exists(filepath):
        flash('Backup file missing from disk.', 'danger')
        return redirect(url_for('backup.index'))
    from flask import current_app
    cfg = current_app.config
    cmd = [
        'mysql',
        f'--host={cfg["DB_HOST"]}',
        f'--user={cfg["DB_USER"]}',
        f'--password={cfg["DB_PASSWORD"]}',
        cfg['DB_NAME']
    ]
    try:
        with open(filepath, 'r') as f:
            result = subprocess.run(cmd, stdin=f, stderr=subprocess.PIPE, timeout=120)
        if result.returncode != 0:
            flash(f'Restore failed: {result.stderr.decode()}', 'danger')
        else:
            log_audit('RESTORE', 'backups', backup_id)
            flash(f'Database restored from {row["filename"]} successfully.', 'success')
    except Exception as e:
        flash(f'Restore error: {str(e)}', 'danger')
    return redirect(url_for('backup.index'))
