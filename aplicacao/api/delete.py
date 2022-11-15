import os

import mysql.connector as connector
from dotenv import load_dotenv
from flask import Blueprint, request

get_profile = Blueprint("get_profile", __name__, url_prefix="/get")
