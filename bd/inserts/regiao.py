import json

import requests

regions = [
    "",
    "América",
    "Ásia",
    "Europa",
    "Oceania",
    "África",
    "Europa meridional  (Sul da Europa)",
    "Ásia ocidental  (Oeste da Ásia)",
    "Ásia meridional (Sul da Ásia)",
    "América Latina e Caribe",
    "Europa ocidental (Oeste da Europa)",
    "Austrália e Nova Zelândia",
    "Europa oriental (Leste da Europa)",
    "Sudeste da Ásia",
    "Ásia oriental (Leste da Ásia)",
    "Europa setentrional (Norte da Europa)",
    "Melanésia",
    "Micronésia",
    "Ásia central",
    "Polinésia",
    "América do Norte",
    "Caribe",
    "América central",
    "América do sul",
    "África central",
    "África setentrional (Norte da África)",
    "África ocidental (Oeste da África)",
    "África oriental (Leste da África)",
    "África meridional (Sul da África)",
]

countries = []


def get_parent(local: dict) -> str:
    ri = regions.index(local["regiao-intermediaria"]["nome"]) if local["regiao-intermediaria"] else 0
    if ri > 0:
        return str(ri)

    sr = regions.index(local["sub-regiao"]["nome"]) if local["sub-regiao"] else 0
    if sr > 0:
        return str(sr)

    r = regions.index(local["regiao"]["nome"]) if local["regiao"] else 0
    if r > 0:
        return str(r)

    return "NULL"


def extract_info(pais: dict) -> dict:
    return {
        "nome": pais["nome"]["abreviado"],
        "tamanho": pais["area"]["total"],
        "tipo": 4,
        "pai": get_parent(pais["localizacao"]),
        "artigo": "a",
    }


def get_sql(info: dict) -> str:
    return f"INSERT INTO Regiao(nome, tamanho, id_tipo_regiao, id_regiao_pai, artigo) VALUES ('{info['nome']}', {info['tamanho']}, {info['tipo']}, {info['pai']}, '{info['artigo']}');"


if __name__ == "__main__":
    all = json.loads(requests.get("http://servicodados.ibge.gov.br/api/v1/paises").text)

    sql = ""

    for pais in all:
        info = extract_info(pais)

        if info not in countries:
            countries.append(info)

    for country in countries:
        sql += f"{get_sql(country)}\n"

    print(sql)
