import os
from dotenv import load_dotenv
 
load_dotenv()
 
class Config:
    SECRET_KEY                = os.getenv('SECRET_KEY', 'change-this-in-production')
    DB_HOST                   = os.getenv('DB_HOST', 'localhost')
    DB_USER                   = os.getenv('DB_USER', 'root')
    DB_PASSWORD               = os.getenv('DB_PASSWORD', '')
    DB_NAME                   = os.getenv('DB_NAME', 'buildright')
    SESSION_TIMEOUT_MINUTES   = int(os.getenv('SESSION_TIMEOUT_MINUTES', 15))
    MAX_LOGIN_ATTEMPTS        = int(os.getenv('MAX_LOGIN_ATTEMPTS', 5))
    UPLOAD_FOLDER             = os.getenv('UPLOAD_FOLDER', 'static/img/uploads')
    MAX_CONTENT_LENGTH        = int(os.getenv('MAX_CONTENT_LENGTH_MB', 5)) * 1024 * 1024
    ALLOWED_EXTENSIONS        = {'png', 'jpg', 'jpeg', 'gif', 'webp'}
    WTF_CSRF_ENABLED          = True
    WTF_CSRF_TIME_LIMIT       = 3600
    SESSION_COOKIE_HTTPONLY   = True
    SESSION_COOKIE_SAMESITE   = 'Lax'
    PERMANENT_SESSION_LIFETIME = 3600
    MAIL_SERVER               = os.getenv('MAIL_SERVER', 'smtp.gmail.com')
    MAIL_PORT                 = int(os.getenv('MAIL_PORT', 587))
    MAIL_USE_TLS              = os.getenv('MAIL_USE_TLS', 'True') == 'True'
    MAIL_USERNAME             = os.getenv('MAIL_USERNAME')
    MAIL_PASSWORD             = os.getenv('MAIL_PASSWORD')
    MAIL_DEFAULT_SENDER       = os.getenv('MAIL_DEFAULT_SENDER')
    NOTIFY_EMAIL              = os.getenv('NOTIFY_EMAIL')
