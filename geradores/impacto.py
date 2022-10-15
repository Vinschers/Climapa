import random as r

r.seed(1)


for n in range(5000):
    id_regiao = r.randint(1,200)
    mes = r.randint(1,12)
    ano = r.randint(1980, 2015)
    valor = r.randint(0,1000)
    id_tipo_impacto = r.randint(1,5)
    print(f"INSERT INTO Impacto(id_regiao, mes, ano, valor, id_tipo_impacto) VALUES('{id_regiao}','{mes}','{ano}', '{valor}','{id_tipo_impacto}');")
