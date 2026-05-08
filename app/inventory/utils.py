import os
import uuid
from werkzeug.utils import secure_filename
from flask import current_app
from app.db import get_db
 
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif', 'webp'}
PER_PAGE = 15
 
 
def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS
 
 
def save_image(file):
    if not file or file.filename == '':
        return None
    if not allowed_file(file.filename):
        return None
    ext = secure_filename(file.filename).rsplit('.', 1)[1].lower()
    filename = f'{uuid.uuid4().hex}.{ext}'
    upload_folder = os.path.join(current_app.root_path, '..', current_app.config['UPLOAD_FOLDER'])
    os.makedirs(upload_folder, exist_ok=True)
    file.save(os.path.join(upload_folder, filename))
    return filename
 
 
def delete_image(filename):
    if not filename:
        return
    upload_folder = os.path.join(current_app.root_path, '..', current_app.config['UPLOAD_FOLDER'])
    path = os.path.join(upload_folder, filename)
    if os.path.exists(path):
        os.remove(path)
 
 
def generate_item_id():
    db = get_db()
    cursor = db.cursor()
    cursor.execute("SELECT COUNT(*) FROM inventory_items")
    count = cursor.fetchone()[0]
    cursor.close()
    return f'BR-{str(count + 1).zfill(5)}'
 
 
def get_categories():
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute('SELECT * FROM categories ORDER BY name')
    cats = cursor.fetchall()
    cursor.close()
    return cats
 
 
def get_suppliers():
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute('SELECT * FROM suppliers ORDER BY name')
    sups = cursor.fetchall()
    cursor.close()
    return sups
 
 
def get_items(search='', category_id='', status='', page=1):
    db = get_db()
    cursor = db.cursor(dictionary=True)
    where = ['1=1']
    params = []
    if search:
        where.append('(i.name LIKE %s OR i.item_id LIKE %s)')
        params += [f'%{search}%', f'%{search}%']
    if category_id:
        where.append('i.category_id = %s')
        params.append(category_id)
    if status:
        where.append('i.status = %s')
        params.append(status)
    where_str = ' AND '.join(where)
    cursor.execute(f'SELECT COUNT(*) FROM inventory_items i WHERE {where_str}', params)
    total = cursor.fetchone()['COUNT(*)']
    offset = (page - 1) * PER_PAGE
    cursor.execute(
        f'''SELECT i.*, c.name as category_name
            FROM inventory_items i
            JOIN categories c ON i.category_id = c.category_id
            WHERE {where_str}
            ORDER BY i.created_at DESC
            LIMIT %s OFFSET %s''',
        params + [PER_PAGE, offset]
    )
    items = cursor.fetchall()
    cursor.close()
    total_pages = (total + PER_PAGE - 1) // PER_PAGE
    return items, total, total_pages
 
 
def get_item(item_id):
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute(
        '''SELECT i.*, c.name as category_name, s.name as supplier_name
           FROM inventory_items i
           JOIN categories c ON i.category_id = c.category_id
           LEFT JOIN suppliers s ON i.supplier_id = s.supplier_id
           WHERE i.item_id = %s''',
        (item_id,)
    )
    item = cursor.fetchone()
    cursor.close()
    return item
