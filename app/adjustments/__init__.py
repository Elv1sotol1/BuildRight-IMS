from flask import Blueprint
adjustments_bp = Blueprint('adjustments', __name__, url_prefix='/adjustments')
from . import routes
