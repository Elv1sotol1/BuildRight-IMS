import sys
import os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
 
from app import create_app
from app.db import get_db
from app.auth.utils import hash_password
 
app = create_app()
 
with app.app_context():
    db = get_db()
    cursor = db.cursor()
    hashed = hash_password('Admin@1234')
    cursor.execute(
        '''INSERT INTO users (username, full_name, email, password_hash, role, status)
           VALUES (%s, %s, %s, %s, 'Admin', 'Active')
           ON DUPLICATE KEY UPDATE password_hash = VALUES(password_hash)''',
        ('admin', 'System Administrator', 'admin@buildright.com', hashed)
    )
    db.commit()
    cursor.close()
    print('Admin created. Username: admin  Password: Admin@1234')
