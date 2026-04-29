# BuildRight Inventory Management System
 
A web-based inventory management system built with Python/Flask and MySQL.
 
## Requirements
- Python 3.10+
- MySQL 8.0+
- MySQL must be in system PATH (for backup feature)
 
## Setup
 
1. Create and activate virtual environment:
   python -m venv .venv
   .venv\Scripts\activate
 
2. Install dependencies:
   pip install -r requirements.txt
 
3. Create the database in MySQL:
   CREATE DATABASE buildright_db;
   source migrations/schema.sql
 
4. Configure environment variables in .env:
   DB_HOST=localhost
   DB_USER=root
   DB_PASSWORD=yourpassword
   DB_NAME=buildright_db
   SECRET_KEY=your-secret-key
 
5. Create the admin user:
   python admin.py
 
6. Run the app:
   python run.py
 
7. Open http://127.0.0.1:5000
   Default login: admin / Admin@1234
 
## Roles
- Admin    — full access including users, categories, backup, force delete
- Manager  — inventory, transactions, suppliers, reports
- Staff    — view inventory and record transactions only
 
## Features
- Inventory item management with image upload
- Stock transactions (inflow/outflow) with automatic stock updates
- Low stock alerts and reorder level tracking
- Supplier management
- Category management
- User management with role-based access
- Audit log of all system actions
- Reports: valuation, stock movement, low stock (export to PDF and Excel)
- Database backup and restore
- Auto-backup daily at 2:00 AM
- Session timeout after 15 minutes
- Account lockout after 5 failed login attempts
