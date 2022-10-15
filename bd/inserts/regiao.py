import json

import requests

regioes = []

def extract_info(pais: dict) -> dict:
    sr = pais["localizacao"]["regiao-intermediaria"]["nome"] if pais["localizacao"]["regiao-intermediaria"] else ""

    if sr not in regioes:
        regioes.append(sr)
    return {
        "nome": pais["nome"]["abreviado"],
        "tamanho": pais["area"]["total"]
    }


def get_sql(info: dict) -> str:
    return ""


if __name__ == "__main__":
    all = json.loads(requests.get("http://servicodados.ibge.gov.br/api/v1/paises").text)

    sql = ""

    for pais in all:
        info = extract_info(pais)
        sql_pais = get_sql(info)

        sql += f"{sql_pais}\n"

    # print(sql)
    print(regioes)
