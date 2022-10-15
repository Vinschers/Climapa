import random as r

r.seed(1)


for n in range(10000):
    id_regiao = r.randint(1,200)
    mes = r.randint(1,12)
    ano = r.randint(1980, 2015)
    temperatura_media = round(r.uniform(-45,40))
    indice_pluviometrico = r.randint(0,1000)
    print(f"INSERT INTO Clima(id_regiao, mes, ano, temperatura_media, unidade_temperatura, indice_pluviometrico) VALUES('{id_regiao}','{mes}','{ano}', '{temperatura_media}','C','{indice_pluviometrico}');")
