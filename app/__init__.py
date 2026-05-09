from flask import Flask, render_template
# pyrefly: ignore [missing-import]
from flask_wtf.csrf import CSRFProtect
# pyrefly: ignore [missing-import]
from flask_mail import Mail
import os

try:
    from config import Config
except ImportError:
    class Config:
        SECRET_KEY = os.getenv('SECRET_KEY', 'default-key-if-missing')
        MYSQL_HOST = os.getenv('MYSQL_HOST')
        MYSQL_USER = os.getenv('MYSQL_USER')
        MYSQL_PASSWORD = os.getenv('MYSQL_PASSWORD')
        MYSQL_DB = os.getenv('MYSQL_DB')
        MAIL_SERVER = os.getenv('MAIL_SERVER')
        MAIL_PORT = os.getenv('MAIL_PORT')
        MAIL_USE_TLS = os.getenv('MAIL_USE_TLS', 'True') == 'True'
        MAIL_USERNAME = os.getenv('MAIL_USERNAME')
        MAIL_PASSWORD = os.getenv('MAIL_PASSWORD')
        MAIL_DEFAULT_SENDER = os.getenv('MAIL_DEFAULT_SENDER')
        SESSION_TIMEOUT_MINUTES = int(os.getenv('SESSION_TIMEOUT_MINUTES', 30))
        MAX_LOGIN_ATTEMPTS = int(os.getenv('MAX_LOGIN_ATTEMPTS', 5))
        DB_HOST = os.getenv('MYSQL_HOST')
        DB_USER = os.getenv('MYSQL_USER')
        DB_PASSWORD = os.getenv('MYSQL_PASSWORD')
        DB_NAME = os.getenv('MYSQL_DB')
        DB_PORT = os.getenv('MYSQL_PORT', '23648')
        
        MYSQL_HOST = os.getenv('MYSQL_HOST')
        MYSQL_USER = os.getenv('MYSQL_USER')
        MYSQL_PASSWORD = os.getenv('MYSQL_PASSWORD')
        MYSQL_DB = os.getenv('MYSQL_DB')
        MYSQL_PORT = os.getenv('MYSQL_PORT', '23648')

        SQLALCHEMY_DATABASE_URI = f"mysql+mysqlconnector://{MYSQL_USER}:{MYSQL_PASSWORD}@{MYSQL_HOST}:{MYSQL_PORT}/{MYSQL_DB}"

from .db import init_db
 
csrf = CSRFProtect()
mail = Mail()
 
 
def create_app():
    app = Flask(__name__, template_folder='../templates', static_folder='../static')
    app.config.from_object(Config)
 
    csrf.init_app(app)
    mail.init_app(app)
    init_db(app)
 
    from .auth import auth_bp
    from .main import main_bp
    from .inventory import inventory_bp
    from .users import users_bp
    from .reports import reports_bp
    from .backup import backup_bp
    from .po import po_bp
    from .adjustments import adjustments_bp
 
    app.register_blueprint(auth_bp)
    app.register_blueprint(main_bp)
    app.register_blueprint(inventory_bp)
    app.register_blueprint(users_bp)
    app.register_blueprint(reports_bp)
    app.register_blueprint(backup_bp)
    app.register_blueprint(po_bp)
    app.register_blueprint(adjustments_bp)
 
    @app.after_request
    def set_security_headers(response):
        response.headers['X-Content-Type-Options'] = 'nosniff'
        response.headers['X-Frame-Options'] = 'SAMEORIGIN'
        response.headers['X-XSS-Protection'] = '1; mode=block'
        response.headers['Referrer-Policy'] = 'strict-origin-when-cross-origin'
        return response
 
    @app.errorhandler(404)
    def not_found(e):
        return render_template('errors/404.html'), 404
 
    @app.errorhandler(500)
    def server_error(e):
        return render_template('errors/500.html'), 500
 
    return app
