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
    valor = r.randint(0, 1000)
    id_tipo_emissao = r.randint(1, 6)
    print(
        f"INSERT INTO Emissao(id_regiao, mes, ano, emitido, id_tipo_emissao) VALUES('{id_regiao}','{mes}','{ano}', '{valor}','{id_tipo_emissao}');"
    )
