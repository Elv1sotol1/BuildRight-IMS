import os
import subprocess
from datetime import datetime
from flask import current_app
from app.db import get_db
 
BACKUP_DIR = 'backups'
 
 
def get_backup_dir():
    path = os.path.join(os.path.dirname(current_app.root_path), BACKUP_DIR)
    os.makedirs(path, exist_ok=True)
    return path
 
 
def run_backup(backup_type='Manual', performed_by=None):
    cfg = current_app.config
    timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
    filename  = f'buildright_backup_{timestamp}.sql'
    filepath  = os.path.join(get_backup_dir(), filename)
 
    cmd = [
        'mysqldump',
        f'--host={cfg["DB_HOST"]}',
        f'--user={cfg["DB_USER"]}',
        f'--password={cfg["DB_PASSWORD"]}',
        cfg['DB_NAME']
    ]
 
    try:
        with open(filepath, 'w') as f:
            result = subprocess.run(cmd, stdout=f, stderr=subprocess.PIPE, timeout=120)
        if result.returncode != 0:
            return None, result.stderr.decode()
        size = os.path.getsize(filepath)
        db = get_db()
        cursor = db.cursor()
        cursor.execute(
            '''INSERT INTO backups (filename, file_size_bytes, backup_type, status, performed_by)
               VALUES (%s, %s, %s, %s, %s)''',
            (filename, size, backup_type, 'Completed', performed_by)
        )
        db.commit()
        cursor.close()
        return filename, None
    except FileNotFoundError:
        return None, 'mysqldump not found. Make sure MySQL is in your system PATH.'
    except subprocess.TimeoutExpired:
        return None, 'Backup timed out.'
    except Exception as e:
        return None, str(e)
 
 
def get_backups():
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute(
        '''SELECT b.*, u.username FROM backups b
           LEFT JOIN users u ON b.performed_by = u.user_id
           ORDER BY b.created_at DESC'''
    )
    rows = cursor.fetchall()
    cursor.close()
    return rows
 
 
def delete_old_backups(keep=30):
    backup_dir = get_backup_dir()
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute('SELECT filename FROM backups ORDER BY created_at DESC')
    all_backups = cursor.fetchall()
    to_delete = all_backups[keep:]
    for b in to_delete:
        path = os.path.join(backup_dir, b['filename'])
        if os.path.exists(path):
            os.remove(path)
        cursor.execute('DELETE FROM backups WHERE filename=%s', (b['filename'],))
    db.commit()
    cursor.close()
