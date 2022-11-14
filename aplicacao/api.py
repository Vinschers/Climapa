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


def get_regions_information(kwargs):
    restricao = ""

    if "regioes" in kwargs:
        restricao = f'Regiao.ID IN ({kwargs["regioes"]})'

    if "anos" in kwargs:
        anos = kwargs["anos"].split(",")
        restricao, erro = create_time_restriction(restricao, anos, "anos", f"{kwargs['tabela']}.ANO")

        if erro:
            return erro

    if "meses" in kwargs:
        meses = kwargs["meses"].split(",")
        restricao, erro = create_time_restriction(restricao, meses, "meses", f"{kwargs['tabela']}.MES")

        if erro:
            return erro

    campos = ["id", "nome"]

    if "media" in kwargs:
        if kwargs["media"] == "ano" and "meses" not in kwargs:
            campo_grupo = f"{kwargs['tabela']}.ANO"
            campos.append("ano")
        elif kwargs["media"] == "mes" and "anos" not in kwargs:
            campo_grupo = f"{kwargs['tabela']}.MES"
            campos.append("mes")
        else:
            return "Por favor, escolha uma media valida (ano ou mes) e apenas uma das condições de tempo (ano ou mes)."

        group_colunas = ",".join(
            [
                f"AVG({kwargs['tabela']}.{coluna})" if len(kwargs["campos"][coluna]) == 1 else kwargs["campos"][coluna][2]
                for coluna in kwargs["campos"].keys()
            ]
        )

        sql = f"SELECT Regiao.ID, Regiao.nome, {campo_grupo}, {group_colunas} FROM {kwargs['tabela']} INNER JOIN Regiao On {kwargs['tabela']}.ID_REGIAO = Regiao.ID GROUP BY Regiao.ID, {campo_grupo}"
        tipo_restricao = "HAVING"
        campos.extend([f"media_{kwargs['campos'][coluna][0]}" for coluna in kwargs["campos"]])
    else:
        colunas = ",".join(
            [
                f"{kwargs['tabela']}.{coluna}" if len(kwargs["campos"][coluna]) == 1 else kwargs["campos"][coluna][1]
                for coluna in kwargs["campos"].keys()
            ]
        )

        sql = f"SELECT Regiao.ID, Regiao.nome, {kwargs['tabela']}.MES, {kwargs['tabela']}.ANO, {colunas} FROM {kwargs['tabela']} INNER JOIN Regiao On {kwargs['tabela']}.ID_REGIAO = Regiao.ID"
        tipo_restricao = "WHERE"
        campos.extend(["mes", "ano"])
        campos.extend([f"{kwargs['campos'][coluna][0]}" for coluna in kwargs["campos"]])

    if restricao:
        sql += f" {tipo_restricao} {restricao}"

    sql += ";"

    print(sql)
    info = run_sql(sql)
    return create_fields(info, *campos)


@db_profile.route("/populacao", methods=["GET"])
def populacao():
    info = {
        "tabela": "Populacao",
        "campos": {"QTD_PESSOAS": ["habitantes"], "QTD_NASCIMENTOS": ["nascimentos"], "QTD_MORTES": ["obitos"]},
    }
    info.update(request.args)

    return get_regions_information(info)


@db_profile.route("/clima", methods=["GET"])
def clima():
    info = {
        "tabela": "Clima",
        "campos": {
            "TEMPERATURA_MEDIA": [
                "temperatura_media",
                "CONCAT(Clima.TEMPERATURA_MEDIA, ' °', Clima.UNIDADE_TEMPERATURA)",
                "CONCAT(AVG(Clima.TEMPERATURA_MEDIA), ' °', MIN(Clima.UNIDADE_TEMPERATURA))",
            ],
            "INDICE_PLUVIOMETRICO": ["pluviosidade(mm)"],
        },
    }
    info.update(request.args)

    return get_regions_information(info)
