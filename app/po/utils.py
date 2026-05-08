from app.db import get_db
 
 
def generate_po_number():
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute('SELECT COUNT(*) as cnt FROM purchase_orders')
    count = cursor.fetchone()['cnt'] + 1
    cursor.close()
    return f'PO-{count:05d}'
 
 
def get_po(po_id):
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute(
        '''SELECT p.*, s.name as supplier_name, s.email as supplier_email,
           u.username as requested_by_name,
           a.username as approved_by_name,
           si.name as site_name
           FROM purchase_orders p
           JOIN suppliers s ON p.supplier_id = s.supplier_id
           JOIN users u ON p.requested_by = u.user_id
           LEFT JOIN users a ON p.approved_by = a.user_id
           LEFT JOIN sites si ON p.site_id = si.site_id
           WHERE p.po_id = %s''',
        (po_id,)
    )
    po = cursor.fetchone()
    if po:
        cursor.execute(
            '''SELECT pi.*, i.name as item_name, i.unit_of_measure
            FROM po_items pi
            JOIN inventory_items i ON pi.item_id = i.item_id
            WHERE pi.po_id = %s''',
            (po_id,))
        po['items'] = cursor.fetchall()

    cursor.close()
    return po
 
 
def get_all_pos(status='', search='', page=1, per_page=15):
    db = get_db()
    cursor = db.cursor(dictionary=True)
    where = ['1=1']
    params = []
    if status:
        where.append('p.status = %s')
        params.append(status)
    if search:
        where.append('(p.po_number LIKE %s OR s.name LIKE %s)')
        params += [f'%{search}%', f'%{search}%']
    where_str = ' AND '.join(where)
    cursor.execute(f'SELECT COUNT(*) as cnt FROM purchase_orders p JOIN suppliers s ON p.supplier_id=s.supplier_id WHERE {where_str}', params)
    total = cursor.fetchone()['cnt']
    offset = (page - 1) * per_page
    cursor.execute(
        f'''SELECT p.*, s.name as supplier_name, u.username as requested_by_name,
            si.name as site_name
            FROM purchase_orders p
            JOIN suppliers s ON p.supplier_id = s.supplier_id
            JOIN users u ON p.requested_by = u.user_id
            LEFT JOIN sites si ON p.site_id = si.site_id
            WHERE {where_str}
            ORDER BY p.created_at DESC
            LIMIT %s OFFSET %s''',
        params + [per_page, offset]
    )
    pos = cursor.fetchall()
    cursor.close()
    return pos, total, (total + per_page - 1) // per_page
