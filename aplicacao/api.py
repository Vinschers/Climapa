import json
import os

import mysql.connector as connector
from dotenv import load_dotenv
from flask import Blueprint, request

db_profile = Blueprint("db_profile", __name__, url_prefix="/api")

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

    cursor.stop()

    return resp


def create_fields(resp: list[tuple], *keys) -> list[dict]:
    return [{keyval[0]: keyval[1] for keyval in zip(keys, item)} for item in resp]


@db_profile.route("/teste", methods=["GET"])
def teste():
    cursor = db.cursor()

    cursor.execute("SELECT * FROM Regiao")
    regioes = cursor.fetchall()

    return create_fields(regioes, "id", "nome", "tamanho", "tipo_regiao", "regiao_pai", "artigo")
