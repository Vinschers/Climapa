import json
import os

import mysql.connector as connector
from dotenv import load_dotenv
from flask import Blueprint

load_dotenv()
db = connector.connect(
    host="localhost",
    user=os.environ.get("MYSQL_USER"),
    password=os.environ.get("MYSQL_PASSWORD"),
    database=os.environ.get("MYSQL_DATABASE"),
)


def run_sql(sql: str) -> list[tuple]:
    cursor = db.cursor()

    cursor.execute(sql)
    resp = cursor.fetchall()

    cursor.close()

    return resp


def create_fields(resp: list[tuple], *keys) -> str:
    return json.dumps([{keyval[0]: keyval[1] for keyval in zip(keys, item)} for item in resp])


# Posto nesta posição para evitar inclusões circulares
from .get import get_profile

api_profile = Blueprint("api_profile", __name__, url_prefix="/api")
api_profile.register_blueprint(get_profile)
