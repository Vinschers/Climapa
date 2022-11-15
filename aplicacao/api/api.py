from flask import Blueprint

from .get import get_profile
from .delete import delete_profile

api_profile = Blueprint("api_profile", __name__, url_prefix="/api")
api_profile.register_blueprint(get_profile)
