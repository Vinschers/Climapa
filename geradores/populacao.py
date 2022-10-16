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
    qtd_pessoas = r.randint(1000000, 500000000)
    qtd_nascimentos = r.randint(100000, 500000)
    qtd_mortes = r.randint(50000, 150000)
    print(
        f"INSERT INTO Populacao(id_regiao, mes, ano, qtd_pessoas, qtd_nascimentos, qtd_mortes) VALUES('{id_regiao}','{mes}','{ano}', '{qtd_pessoas}','{qtd_nascimentos}','{qtd_mortes}');"
    )
