import os

import mysql.connector as connector
from dotenv import load_dotenv
from flask import Blueprint, request

get_profile = Blueprint("get_profile", __name__, url_prefix="/get")

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
        new_restriction = f"{field} = {times[0]}"
    elif len(times) == 2:
        new_restriction = f"{field} BETWEEN {times[0]} AND {times[1]}"
    else:
        return current_restriction, f"Por favor, forneca apenas dois valores de {name} (inicio e fim do intervalo de interesse)."

    if current_restriction:
        return f"{current_restriction} AND {new_restriction}", ""

    return new_restriction, ""


@get_profile.route("/regiao", methods=["GET"])
def regiao():
    args = request.args

    restricao = ""
    if "id" in args:
        restricao = f'Regiao.ID = "{args["id"]}"'
    elif "nome" in args:
        restricao = f'Regiao.nome = "{args["nome"]}"'
    elif "tipo" in args:
        restricao = f'Regiao.ID_TIPO_REGIAO = {args["tipo"]}'

    if restricao:
        regiao = run_sql(
            f"SELECT Regiao.ID, Regiao.nome, Regiao.tamanho, Regiao.artigo, Regiao.ID_REGIAO_PAI, TipoRegiao.nome, TipoRegiao.plural FROM Regiao INNER JOIN TipoRegiao ON TipoRegiao.ID = Regiao.ID_TIPO_REGIAO WHERE {restricao};"
        )
    else:
        regiao = run_sql(
            "SELECT Regiao.ID, Regiao.nome, Regiao.tamanho, Regiao.artigo, Regiao.ID_REGIAO_PAI, TipoRegiao.nome, TipoRegiao.plural FROM Regiao INNER JOIN TipoRegiao ON TipoRegiao.ID = Regiao.ID_TIPO_REGIAO;"
        )
    return create_fields(regiao, "id", "nome", "area (km2)", "artigo", "id_pai", "tipo", "plural_tipo")


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

    join_tipo = ""
    select_tipo = ""
    group_tipo = ""
    if "tabela_tipo" in kwargs and kwargs["tabela_tipo"]:
        join_tipo = f"INNER JOIN {kwargs['tabela_tipo'][0]} ON {kwargs['tabela']}.{kwargs['tabela_tipo'][1]} = {kwargs['tabela_tipo'][0]}.ID"
        if "media" in kwargs:
            select_tipo = f"MIN({kwargs['tabela_tipo'][0]}.ID), {kwargs['tabela_tipo'][0]}.NOME,"
        else:
            select_tipo = f"{kwargs['tabela_tipo'][0]}.ID, {kwargs['tabela_tipo'][0]}.NOME,"
        group_tipo = f", {kwargs['tabela_tipo'][0]}.NOME"
        campos.extend(["tipo", "nome_tipo"])

        if "tipos" in kwargs:
            restricao += f"{kwargs['tabela_tipo'][0]}.ID IN ({kwargs['tipos']})"

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

        sql = f"SELECT Regiao.ID, Regiao.nome, {select_tipo} {campo_grupo}, {group_colunas} FROM {kwargs['tabela']} INNER JOIN Regiao On {kwargs['tabela']}.ID_REGIAO = Regiao.ID {join_tipo} GROUP BY Regiao.ID, {campo_grupo}{group_tipo}"
        tipo_restricao = "HAVING"
        campos.extend([f"media_{kwargs['campos'][coluna][0]}" for coluna in kwargs["campos"]])
    else:
        colunas = ",".join(
            [
                f"{kwargs['tabela']}.{coluna}" if len(kwargs["campos"][coluna]) == 1 else kwargs["campos"][coluna][1]
                for coluna in kwargs["campos"].keys()
            ]
        )

        sql = f"SELECT Regiao.ID, Regiao.nome, {select_tipo} {kwargs['tabela']}.MES, {kwargs['tabela']}.ANO, {colunas} FROM {kwargs['tabela']} INNER JOIN Regiao On {kwargs['tabela']}.ID_REGIAO = Regiao.ID {join_tipo}"

        tipo_restricao = "WHERE"
        campos.extend(["mes", "ano"])
        campos.extend([f"{kwargs['campos'][coluna][0]}" for coluna in kwargs["campos"]])

    if restricao:
        sql += f" {tipo_restricao} {restricao}"

    sql += ";"

    print(sql)
    info = run_sql(sql)
    return create_fields(info, *campos)


@get_profile.route("/populacao", methods=["GET"])
def populacao():
    info = {
        "tabela": "Populacao",
        "campos": {"QTD_PESSOAS": ["habitantes"], "QTD_NASCIMENTOS": ["nascimentos"], "QTD_MORTES": ["obitos"]},
    }
    info.update(request.args)

    return get_regions_information(info)


@get_profile.route("/clima", methods=["GET"])
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


@get_profile.route("/vegetacao", methods=["GET"])
def vegetacao():
    info = {
        "tabela": "Vegetacao",
        "campos": {
            "QTD_QUEIMADAS": ["area_queimadas(km2)"],
            "INDICE_MATA_NATIVA": ["area_mata_nativa(km2)"],
            "INDICE_REFLORESTAMENTO": ["area_reflorestamento(km2)"],
            "INDICE_DESMATAMENTO": ["area_desmatada(km2)"],
        },
    }
    info.update(request.args)

    return get_regions_information(info)


@get_profile.route("/impacto", methods=["GET"])
def impacto():
    info = {
        "tabela": "Impacto",
        "campos": {
            "VALOR": ["valor"],
        },
        "tabela_tipo": ("TipoImpacto", "ID_TIPO_IMPACTO"),
    }
    info.update(request.args)

    return get_regions_information(info)


@get_profile.route("/emissao", methods=["GET"])
def emissao():
    info = {
        "tabela": "Emissao",
        "campos": {
            "EMITIDO": ["emitido"],
        },
        "tabela_tipo": ("TipoEmissao", "ID_TIPO_IMPACTO"),
    }
    info.update(request.args)

    return get_regions_information(info)


@get_profile.route("/energia", methods=["GET"])
def energia():
    info = {
        "tabela": "MatrizEnergetica",
        "campos": {
            "QTD_GERADO": ["gerado(MWh)"],
        },
        "tabela_tipo": ("TipoEnergia", "ID_TIPO_ENERGIA"),
    }
    info.update(request.args)

    return get_regions_information(info)


@get_profile.route("/editores", methods=["GET"])
def editores():
    if "regioes" in request.args:
        editores = run_sql(f"SELECT * FROM Editor WHERE ID_REGIAO IN ({request.args['regioes']});")
    else:
        editores = run_sql("SELECT * FROM Editor;")

    return create_fields(editores, "id", "nome", "formacao", "id_regiao")
