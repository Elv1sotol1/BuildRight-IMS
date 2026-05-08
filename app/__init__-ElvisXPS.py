from flask import Flask, render_template
from flask_wtf.csrf import CSRFProtect
from flask_mail import Mail
from config import Config
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
 
    app.register_blueprint(auth_bp)
    app.register_blueprint(main_bp)
    app.register_blueprint(inventory_bp)
    app.register_blueprint(users_bp)
    app.register_blueprint(reports_bp)
    app.register_blueprint(backup_bp)
    app.register_blueprint(po_bp)
 
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
