import random as r

r.seed(50)

nomes = ['Alice','Ana','Patricia','Mariana','Juliana','Beatriz','Paula','Roberto','Bruno','Matheus','Francisco','Julio','Lucas','Carlos']
sobrenomes = ['Ferraz','Cunha','dos Santos','Ferreira','Martins','Pereira','Guerra','Paz','Sofrimento','Abreu','Dolabella','Suzuki']
formacoes = ['geografia','oceanografia','quimica','estatistica','biologia','geologia','fisica','engenharia quimica','outro']

for n in range(10):
    nome = nomes[r.randrange(len(nomes))] + ' ' + sobrenomes[r.randrange(len(sobrenomes))]
    formacao = formacoes[r.randrange(len(formacoes))]
    id_regiao = r.randint(1,200)
    print(f"INSERT INTO Editor(nome, formacao, id_regiao) VALUES('{nome}','{formacao}','{id_regiao}');")
