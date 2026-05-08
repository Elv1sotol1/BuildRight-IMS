from flask import Blueprint
po_bp = Blueprint('po', __name__, url_prefix='/purchase-orders')
from . import routes
