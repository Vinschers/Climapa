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

    cursor.close()

    return resp


def create_fields(resp: list[tuple], *keys) -> list[dict]:
    return [{keyval[0]: keyval[1] for keyval in zip(keys, item)} for item in resp]


def create_time_restriction(current_restriction: str, times: list[str], name: str, field: str):
    if len(times) == 1:
        return f"{current_restriction} AND {field} = {times[0]}", ""
    elif len(times) == 2:
        return f"{current_restriction} AND {field} BETWEEN {times[0]} AND {times[1]}", ""
    else:
        return current_restriction, f"Por favor, forneca apenas dois valores de {name} (inicio e fim do intervalo de interesse)."


@db_profile.route("/regiao", methods=["GET"])
def regiao():
    args = request.args

    restricao = ""
    if "id" in args:
        restricao = f'Regiao.ID = "{args["id"]}"'
    elif "nome" in args:
        restricao = f'Regiao.nome = "{args["nome"]}"'

    if restricao:
        regiao = run_sql(
            f"SELECT Regiao.ID, Regiao.nome, Regiao.tamanho, Regiao.artigo, Regiao.ID_REGIAO_PAI, TipoRegiao.nome, TipoRegiao.plural FROM Regiao INNER JOIN TipoRegiao ON TipoRegiao.ID = Regiao.ID_TIPO_REGIAO WHERE {restricao};"
        )
        return create_fields(regiao, "id", "nome", "area (km2)", "artigo", "id_pai", "tipo", "plural_tipo")
    else:
        return "Por favor, especifique um id ou um nome da região na URL."


@db_profile.route("/populacao", methods=["GET"])
def populacao():
    args = request.args

    if "regioes" not in args:
        return "Por favor, especifique as regiões de interesse separadas por vírgulas."

    restricao = f'Regiao.ID IN ({args["regioes"]})'

    if "anos" not in args and "meses" not in args:
        return "Por favor, especifique o período de tempo de interesse como um intervalo de anos, meses ou ambos."

    erro = ""
    if "anos" in args:
        anos = args["anos"].split(",")
        restricao, erro = create_time_restriction(restricao, anos, "anos", "Populacao.ANO")

    if "meses" in args:
        meses = args["meses"].split(",")
        restricao, erro = create_time_restriction(restricao, meses, "meses", "Populacao.MES")

    if erro:
        return erro

    campos = ["id", "nome"]

    if "media" in args:
        if args["media"] == "ano" and "meses" not in args:
            campo_grupo = "Populacao.ANO"
            campos.append("ano")
        elif args["media"] == "mes" and "anos" not in args:
            campo_grupo = "Populacao.MES"
            campos.append("mes")
        else:
            return "Por favor, escolha uma media valida (ano ou mes) e apenas uma das condições de tempo (ano ou mes)."

        sql = f"SELECT Regiao.ID, Regiao.nome, {campo_grupo}, AVG(Populacao.QTD_PESSOAS), AVG(Populacao.QTD_NASCIMENTOS), AVG(Populacao.QTD_MORTES) FROM Populacao INNER JOIN Regiao On Populacao.ID_REGIAO = Regiao.ID GROUP BY Regiao.ID, {campo_grupo} HAVING"
        campos.extend(["media_habitantes", "media_nascimentos", "media_obitos"])
    else:
        sql = "SELECT Regiao.ID, Regiao.nome, Populacao.MES, Populacao.ANO, Populacao.QTD_PESSOAS, Populacao.QTD_NASCIMENTOS, Populacao.QTD_MORTES FROM Populacao INNER JOIN Regiao On Populacao.ID_REGIAO = Regiao.ID WHERE"
        campos.extend(["mes", "ano", "habitantes", "nascimentos", "obitos"])

    sql = f"{sql} {restricao};"

    populacao = run_sql(sql)
    return create_fields(populacao, *campos)
