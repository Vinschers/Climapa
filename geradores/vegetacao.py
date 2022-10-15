import random as r

r.seed(1)


for n in range(10000):
    id_regiao = r.randint(1,200)
    mes = r.randint(1,12)
    ano = r.randint(1980, 2015)
    qtd_queimadas = r.randint(0,3000000)
    indice_mata_nativa = r.randint(0,100)
    indice_reflorestamento = r.randint(0, 100)
    indice_desmatamento = r.randint(0, 100)
    print(f"INSERT INTO Vegetacao(id_regiao, mes, ano, qtd_queimadas, indice_mata_nativa, indice_reflorestamento, indice_desmatamento) VALUES('{id_regiao}','{mes}','{ano}', '{qtd_queimadas}','{indice_mata_nativa}','{indice_reflorestamento}','{indice_desmatamento}');")
