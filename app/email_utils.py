from flask import current_app
from flask_mail import Message
from threading import Thread
 
 
def send_async_email(app, msg):
    with app.app_context():
        from app import mail
        try:
            mail.send(msg)
        except Exception as e:
            current_app.logger.error(f'Email send error: {e}')
 
 
def send_email(subject, recipients, body_html):
    try:
        from app import mail
        if isinstance(recipients, str):
            recipients = [recipients]
        msg = Message(subject=subject, recipients=recipients, html=body_html)
        app = current_app._get_current_object()
        Thread(target=send_async_email, args=(app, msg)).start()
    except Exception as e:
        current_app.logger.error(f'Email error: {e}')
 
 
def notify_low_stock(item_name, current_stock, reorder_level, unit):
    notify_email = current_app.config.get('NOTIFY_EMAIL')
    if not notify_email:
        return
    subject = f'[BuildRight] Low Stock Alert — {item_name}'
    body = f'''
    <div style="font-family:Arial,sans-serif;max-width:600px;margin:0 auto">
        <div style="background:#2C3E50;padding:20px;border-radius:8px 8px 0 0">
            <h2 style="color:white;margin:0">&#9888; Low Stock Alert</h2>
        </div>
        <div style="background:#fff;padding:24px;border:1px solid #dde3e8;border-radius:0 0 8px 8px">
            <p>The following item has reached its reorder level:</p>
            <table style="width:100%;border-collapse:collapse;margin:16px 0">
                <tr style="background:#f8f9fa">
                    <td style="padding:10px;font-weight:bold">Item</td>
                    <td style="padding:10px">{item_name}</td>
                </tr>
                <tr>
                    <td style="padding:10px;font-weight:bold">Current Stock</td>
                    <td style="padding:10px;color:#E74C3C"><strong>{current_stock} {unit}</strong></td>
                </tr>
                <tr style="background:#f8f9fa">
                    <td style="padding:10px;font-weight:bold">Reorder Level</td>
                    <td style="padding:10px">{reorder_level} {unit}</td>
                </tr>
            </table>
            <p>Please raise a Purchase Order to restock this item.</p>
            <p style="color:#90a4ae;font-size:0.85rem">BuildRight Inventory System</p>
        </div>
    </div>
    '''
    send_email(subject, notify_email, body)
 
 
def notify_po_submitted(po_number, supplier_name, total_amount, requested_by):
    notify_email = current_app.config.get('NOTIFY_EMAIL')
    if not notify_email:
        return
    subject = f'[BuildRight] PO {po_number} Awaiting Your Approval'
    body = f'''
    <div style="font-family:Arial,sans-serif;max-width:600px;margin:0 auto">
        <div style="background:#2C3E50;padding:20px;border-radius:8px 8px 0 0">
            <h2 style="color:white;margin:0">&#128196; Purchase Order Submitted</h2>
        </div>
        <div style="background:#fff;padding:24px;border:1px solid #dde3e8;border-radius:0 0 8px 8px">
            <p>A new Purchase Order has been submitted and requires your approval:</p>
            <table style="width:100%;border-collapse:collapse;margin:16px 0">
                <tr style="background:#f8f9fa">
                    <td style="padding:10px;font-weight:bold">PO Number</td>
                    <td style="padding:10px">{po_number}</td>
                </tr>
                <tr>
                    <td style="padding:10px;font-weight:bold">Supplier</td>
                    <td style="padding:10px">{supplier_name}</td>
                </tr>
                <tr style="background:#f8f9fa">
                    <td style="padding:10px;font-weight:bold">Total Amount</td>
                    <td style="padding:10px"><strong>KES {total_amount:,.2f}</strong></td>
                </tr>
                <tr>
                    <td style="padding:10px;font-weight:bold">Requested By</td>
                    <td style="padding:10px">{requested_by}</td>
                </tr>
            </table>
            <p>Please log in to BuildRight to review and approve this order.</p>
            <p style="color:#90a4ae;font-size:0.85rem">BuildRight Inventory System</p>
        </div>
    </div>
    '''
    send_email(subject, notify_email, body)
 
 
def notify_po_approved(po_number, supplier_name, total_amount, approved_by):
    notify_email = current_app.config.get('NOTIFY_EMAIL')
    if not notify_email:
        return
    subject = f'[BuildRight] PO {po_number} Has Been Approved'
    body = f'''
    <div style="font-family:Arial,sans-serif;max-width:600px;margin:0 auto">
        <div style="background:#27AE60;padding:20px;border-radius:8px 8px 0 0">
            <h2 style="color:white;margin:0">&#10003; Purchase Order Approved</h2>
        </div>
        <div style="background:#fff;padding:24px;border:1px solid #dde3e8;border-radius:0 0 8px 8px">
            <p>The following Purchase Order has been approved:</p>
            <table style="width:100%;border-collapse:collapse;margin:16px 0">
                <tr style="background:#f8f9fa">
                    <td style="padding:10px;font-weight:bold">PO Number</td>
                    <td style="padding:10px">{po_number}</td>
                </tr>
                <tr>
                    <td style="padding:10px;font-weight:bold">Supplier</td>
                    <td style="padding:10px">{supplier_name}</td>
                </tr>
                <tr style="background:#f8f9fa">
                    <td style="padding:10px;font-weight:bold">Total Amount</td>
                    <td style="padding:10px"><strong>KES {total_amount:,.2f}</strong></td>
                </tr>
                <tr>
                    <td style="padding:10px;font-weight:bold">Approved By</td>
                    <td style="padding:10px">{approved_by}</td>
                </tr>
            </table>
            <p>You can now proceed to receive the stock when it arrives.</p>
            <p style="color:#90a4ae;font-size:0.85rem">BuildRight Inventory System</p>
        </div>
    </div>
    '''
    send_email(subject, notify_email, body)
