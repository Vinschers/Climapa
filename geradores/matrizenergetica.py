import random as r

r.seed(1)

n = int(input())

pks = []

for i in range(n):
    while True:
        id_regiao = r.randint(1, 200)
        mes = r.randint(1, 12)
        ano = r.randint(1980, 2015)

        pk = (id_regiao, mes, ano)

        if pk not in pks:
            pks.append(pk)
            break
    id_tipo_energia = r.randint(1, 6)
    qtd_gerado = r.randint(0, 5000000)
    print(
        f"INSERT INTO MatrizEnergetica(id_regiao, mes, ano, id_tipo_energia, qtd_gerado) VALUES('{id_regiao}','{mes}','{ano}', '{id_tipo_energia}','{qtd_gerado}');"
    )
