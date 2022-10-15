import random as r

r.seed(1)


for n in range(10000):
    id_regiao = r.randint(1,200)
    mes = r.randint(1,12)
    ano = r.randint(1980, 2015)
    id_tipo_energia = r.randint(1,6)
    qtd_gerado = r.randint(0,5000000)
    print(f"INSERT INTO MatrizEnergetica(id_regiao, mes, ano, id_tipo_energia, qtd_gerado) VALUES('{id_regiao}','{mes}','{ano}', '{id_tipo_energia}','{qtd_gerado}');")
