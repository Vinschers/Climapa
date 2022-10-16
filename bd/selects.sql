-- Seleciona a região baseado em seu nome. Retorna o ID, nome, área, artigo, tipo, e região pai da região selecionada
SELECT Regiao.ID, Regiao.nome as "Nome", Regiao.tamanho as "Área (km²)", Regiao.artigo as "Artigo", Regiao.ID_REGIAO_PAI AS "ID região pai",
TipoRegiao.nome as "Tipo", TipoRegiao.plural as "Tipo (plural)"
FROM Regiao
INNER JOIN TipoRegiao ON TipoRegiao.ID = Regiao.ID_TIPO_REGIAO
WHERE Regiao.nome = "Brasil";


-- Seleciona o histórico da população baseado nos ids das regiões
SELECT Regiao.ID as "ID região", Regiao.nome as "Nome", Populacao.MES as "Mês", Populacao.ANO as "Ano", Populacao.QTD_PESSOAS as "Habitantes", Populacao.QTD_NASCIMENTOS as "Nascimentos",
Populacao.QTD_MORTES as "Óbitos"
FROM Populacao
INNER JOIN Regiao On Populacao.ID_REGIAO = Regiao.ID
WHERE Regiao.ID IN (51, 55);

-- Seleciona o histórico da população em um certo período baseado nos ids das regiões
SELECT Regiao.ID as "ID região", Regiao.nome as "Nome", Populacao.MES as "Mês", Populacao.ANO as "Ano", Populacao.QTD_PESSOAS as "Habitantes", Populacao.QTD_NASCIMENTOS as "Nascimentos",
Populacao.QTD_MORTES as "Óbitos"
FROM Populacao
INNER JOIN Regiao On Populacao.ID_REGIAO = Regiao.ID
WHERE Regiao.ID IN (50, 100) and Populacao.ANO BETWEEN 1993 AND 2003;

-- Seleciona o histórico da média da população em um certo período baseado nos ids das regiões
SELECT Regiao.ID as "ID região", Regiao.nome as "Nome", Populacao.ANO as "Ano", AVG(Populacao.QTD_PESSOAS) as "Média habitantes",
AVG(Populacao.QTD_NASCIMENTOS) as "Média nascimentos", AVG(Populacao.QTD_MORTES) as "Média óbitos"
FROM Populacao
INNER JOIN Regiao On Populacao.ID_REGIAO = Regiao.ID
GROUP BY Regiao.ID, Populacao.ANO
HAVING Regiao.ID IN (51, 100) and Populacao.ANO BETWEEN 1990 AND 2010;

-- Seleciona o histórico da população em um conjunto de meses, baseado nos ids das regiões
SELECT Regiao.ID, Regiao.nome as "Nome", Populacao.MES as "Mês", Populacao.ANO as "Ano", Populacao.QTD_PESSOAS as "Habitantes",
Populacao.QTD_NASCIMENTOS as "Nascimentos", Populacao.QTD_MORTES as "Óbitos"
FROM Populacao
INNER JOIN Regiao On Populacao.ID_REGIAO = Regiao.ID
WHERE Regiao.ID IN (51, 67) and Populacao.MES BETWEEN 4 AND 8;

-- Seleciona o histórico da média da população em um conjunto de meses, baseado nos ids das regiões
SELECT Regiao.ID, Regiao.nome as "Nome", Populacao.MES as "Mês", AVG(Populacao.QTD_PESSOAS) as "Média habitantes",
AVG(Populacao.QTD_NASCIMENTOS) as "Média nascimentos", AVG(Populacao.QTD_MORTES) as "Média óbitos"
FROM Populacao
INNER JOIN Regiao On Populacao.ID_REGIAO = Regiao.ID
GROUP BY Regiao.ID, Populacao.MES
HAVING Regiao.ID IN (51, 67) and Populacao.MES BETWEEN 4 AND 8;


-- Seleciona as informações sobre o clima de várias regiões, baseado em seus IDs
SELECT Regiao.ID, Regiao.nome as "Nome", Clima.MES as "Mês", Clima.ANO as "Ano",
CONCAT(Clima.TEMPERATURA_MEDIA, " °", Clima.UNIDADE_TEMPERATURA) as "Temperatura média", CONCAT(Clima.INDICE_PLUVIOMETRICO, " mm") as "Pluviosidade"
FROM Clima
INNER JOIN Regiao ON Clima.ID_REGIAO = Regiao.ID
WHERE Regiao.ID IN (15, 51);

-- Seleciona as informações sobre o clima de várias regiões, baseado em seus IDs e em um período de anos
SELECT Regiao.ID, Regiao.nome as "Nome", Clima.MES as "Mês", Clima.ANO as "Ano",
CONCAT(Clima.TEMPERATURA_MEDIA, " °", Clima.UNIDADE_TEMPERATURA) as "Temperatura média", CONCAT(Clima.INDICE_PLUVIOMETRICO, " mm") as "Pluviosidade"
FROM Clima
INNER JOIN Regiao ON Clima.ID_REGIAO = Regiao.ID
WHERE Regiao.ID IN (33, 51) and Clima.ANO BETWEEN 2003 AND 2013;

-- Seleciona a média das informações sobre o clima de várias regiões, baseado em seus IDs e em um período de anos
SELECT Regiao.ID, Regiao.nome as "Nome", Clima.ANO as "Ano",
CONCAT(AVG(Clima.TEMPERATURA_MEDIA), " °", Clima.UNIDADE_TEMPERATURA) as "Temperatura média",
CONCAT(AVG(Clima.INDICE_PLUVIOMETRICO), " mm") as "Média pluviosidade"
FROM Clima
INNER JOIN Regiao ON Clima.ID_REGIAO = Regiao.ID
GROUP BY Regiao.ID, Clima.ANO
HAVING Regiao.ID IN (33, 51) and Clima.ANO BETWEEN 2003 AND 2013;

-- Seleciona as informações sobre o clima de várias regiiões, baseado em seus IDs e em um período de mêses
SELECT Regiao.ID, Regiao.nome as "Nome", Clima.MES as "Mês", Clima.ANO as "Ano",
CONCAT(Clima.TEMPERATURA_MEDIA, " °", Clima.UNIDADE_TEMPERATURA) as "Temperatura média", CONCAT(Clima.INDICE_PLUVIOMETRICO, " mm") as "Pluviosidade"
FROM Clima
INNER JOIN Regiao ON Clima.ID_REGIAO = Regiao.ID
WHERE Regiao.ID IN (51, 66) and Clima.MES between 4 and 9;

-- Seleciona a média das informações sobre o clima de várias regiiões, baseado em seus IDs e em um período de mêses
SELECT Regiao.ID, Regiao.nome as "Nome", Clima.MES as "Mês",
CONCAT(AVG(Clima.TEMPERATURA_MEDIA), " °", Clima.UNIDADE_TEMPERATURA) as "Temperatura média",
CONCAT(AVG(Clima.INDICE_PLUVIOMETRICO), " mm") as "Média pluviosidade"
FROM Clima
INNER JOIN Regiao ON Clima.ID_REGIAO = Regiao.ID
GROUP BY Regiao.ID, Clima.MES
HAVING Regiao.ID IN (51, 66) and Clima.MES between 4 and 9;


-- Seleciona os dados de vegetação, baseado nos ids de várias regiões
SELECT Regiao.ID, Regiao.nome as "Nome", Vegetacao.MES as "Mês", Vegetacao.ANO as "Ano", Vegetacao.QTD_QUEIMADAS as "Queimadas (km²)",
Vegetacao.INDICE_MATA_NATIVA as "Mata nativa (km²)", Vegetacao.INDICE_REFLORESTAMENTO as "Reflorestamento (km²)",
Vegetacao.INDICE_DESMATAMENTO as "Área desmatada (km²)"
FROM Vegetacao
INNER JOIN Regiao ON Vegetacao.ID_REGIAO = Regiao.ID
WHERE Regiao.ID IN (51, 52, 53, 54);

-- Seleciona os dados de vegetação, baseado nos ids de várias regiões e em um período de anos
SELECT Regiao.ID, Regiao.nome as "Nome", Vegetacao.MES as "Mês", Vegetacao.ANO as "Ano", Vegetacao.QTD_QUEIMADAS as "Queimadas (km²)",
Vegetacao.INDICE_MATA_NATIVA as "Mata nativa (km²)", Vegetacao.INDICE_REFLORESTAMENTO as "Reflorestamento (km²)",
Vegetacao.INDICE_DESMATAMENTO as "Área desmatada (km²)"
FROM Vegetacao
INNER JOIN Regiao ON Vegetacao.ID_REGIAO = Regiao.ID
WHERE Regiao.ID IN (48, 51) and Vegetacao.ANO BETWEEN 1994 and 2008;

-- Seleciona a média dos dados de vegetação, baseado nos ids de várias regiões e em um período de anos
SELECT Regiao.ID, Regiao.nome as "Nome", Vegetacao.ANO as "Ano", AVG(Vegetacao.QTD_QUEIMADAS) as "Média queimadas (km²)",
AVG(Vegetacao.INDICE_MATA_NATIVA) as "Média mata nativa (km²)", AVG(Vegetacao.INDICE_REFLORESTAMENTO) as "Média reflorestamento (km²)",
AVG(Vegetacao.INDICE_DESMATAMENTO) as "Média área desmatada (km²)"
FROM Vegetacao
INNER JOIN Regiao ON Vegetacao.ID_REGIAO = Regiao.ID
GROUP BY Regiao.ID, Vegetacao.ANO
HAVING Regiao.ID IN (48, 51) and Vegetacao.ANO BETWEEN 1994 and 2008;

-- Seleciona os dados de vegetação, baseado nos ids de várias regiões e em um período de meses
SELECT Regiao.ID, Regiao.nome as "Nome", Vegetacao.MES as "Mês", Vegetacao.ANO as "Ano", Vegetacao.QTD_QUEIMADAS as "Queimadas (km²)",
Vegetacao.INDICE_MATA_NATIVA as "Mata nativa (km²)", Vegetacao.INDICE_REFLORESTAMENTO as "Reflorestamento (km²)",
Vegetacao.INDICE_DESMATAMENTO as "Área desmatada (km²)"
FROM Vegetacao
INNER JOIN Regiao ON Vegetacao.ID_REGIAO = Regiao.ID
WHERE Regiao.ID IN (40, 51) and Vegetacao.MES IN (4, 5, 6);

-- Seleciona a média dos dados de vegetação, baseado nos ids de várias regiões e em um período de meses
SELECT Regiao.ID, Regiao.nome as "Nome", Vegetacao.MES as "Mês", AVG(Vegetacao.QTD_QUEIMADAS) as "Média queimadas (km²)",
AVG(Vegetacao.INDICE_MATA_NATIVA) as "Média mata nativa (km²)", AVG(Vegetacao.INDICE_REFLORESTAMENTO) as "Média reflorestamento (km²)",
AVG(Vegetacao.INDICE_DESMATAMENTO) as "Média área desmatada (km²)"
FROM Vegetacao
INNER JOIN Regiao ON Vegetacao.ID_REGIAO = Regiao.ID
GROUP BY Regiao.ID, Vegetacao.MES
HAVING Regiao.ID IN (40, 51) and Vegetacao.MES IN (4, 5, 6);


-- Seleciona os dados de impacto, baseado nos ids de várias regiões
SELECT Regiao.ID as "ID Região", Regiao.NOME as "Região", TipoImpacto.NOME as "Tipo de Impacto", Impacto.MES as "Mês", Impacto.ANO as "Ano", Impacto.VALOR as "Impacto"
FROM Impacto
INNER JOIN Regiao ON Impacto.ID_REGIAO = Regiao.ID
inner JOIN TipoImpacto on Impacto.ID_TIPO_IMPACTO = TipoImpacto.ID
group by Regiao.NOME, TipoImpacto.NOME
having Regiao.ID in (50, 55);

-- Seleciona os dados de impacto, baseado nos ids de várias regiões e em um período de anos
SELECT Regiao.ID as "ID Região", Regiao.NOME as "Região", TipoImpacto.NOME as "Tipo de Impacto", Impacto.MES as "Mês", Impacto.ANO as "Ano", Impacto.VALOR as "Impacto"
FROM Impacto
INNER JOIN Regiao ON Impacto.ID_REGIAO = Regiao.ID
inner JOIN TipoImpacto on Impacto.ID_TIPO_IMPACTO = TipoImpacto.ID
group by Regiao.NOME, TipoImpacto.NOME
having Regiao.ID in (50, 55) and Impacto.ANO BETWEEN 1994 and 2008;

-- Seleciona a média dos dados de impacto, baseado nos ids de várias regiões e em um período de anos
SELECT Regiao.ID as "ID Região", Regiao.NOME, TipoImpacto.NOME as "Tipo de Impacto", Impacto.ANO as "Ano",
AVG(Impacto.VALOR) as "Impacto médio"
FROM Impacto
INNER JOIN Regiao ON Impacto.ID_REGIAO = Regiao.ID
inner JOIN TipoImpacto on Impacto.ID_TIPO_IMPACTO = TipoImpacto.ID
GROUP BY Regiao.ID, Impacto.ANO
HAVING Regiao.ID IN (51, 66) and Impacto.ANO between 1980 and 1990;

-- Seleciona os dados de impacto, baseado nos ids de várias regiões e em um período de meses
SELECT Regiao.ID as "ID Região", Regiao.NOME as "Região", TipoImpacto.NOME as "Tipo de Impacto", Impacto.MES as "Mês", Impacto.ANO as "Ano", Impacto.VALOR as "Impacto"
FROM Impacto
INNER JOIN Regiao ON Impacto.ID_REGIAO = Regiao.ID
inner JOIN TipoImpacto on Impacto.ID_TIPO_IMPACTO = TipoImpacto.ID
group by Regiao.NOME, TipoImpacto.NOME
having Regiao.ID in (112, 113, 114) and Impacto.MES BETWEEN 3 and 8;

-- Seleciona a média dos dados de impacto, baseado nos ids de várias regiões e em um período de meses
SELECT Regiao.ID as "ID Região", Regiao.NOME, TipoImpacto.NOME as "Tipo de Impacto", Impacto.MES as "Mês",
AVG(Impacto.VALOR) as "Impacto médio"
FROM Impacto
INNER JOIN Regiao ON Impacto.ID_REGIAO = Regiao.ID
inner JOIN TipoImpacto on Impacto.ID_TIPO_IMPACTO = TipoImpacto.ID
GROUP BY Regiao.ID, Impacto.MES
HAVING Regiao.ID IN (51, 66) and Impacto.MES between 1 and 4;

-- Seleciona os dados de impacto, baseado nos ids de várias regiões e em um determinado tipo de impacto
SELECT Regiao.ID as "ID Região", Regiao.NOME as "Região", TipoImpacto.ID, TipoImpacto.NOME as "Tipo de Impacto", Impacto.MES as "Mês", Impacto.ANO as "Ano", Impacto.VALOR as "Impacto"
FROM Impacto
INNER JOIN Regiao ON Impacto.ID_REGIAO = Regiao.ID
inner JOIN TipoImpacto on Impacto.ID_TIPO_IMPACTO = TipoImpacto.ID
group by Regiao.NOME, TipoImpacto.NOME
having Regiao.ID in (50, 55) and TipoImpacto.ID = 3;


-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Seleciona os dados de emissão, baseado nos ids de várias regiões
SELECT Regiao.ID as "ID Região", Regiao.NOME as "Região", TipoEmissao.NOME as "Gás Emitido", Emissao.EMITIDO, Emissao.MES as "Mês", Emissao.ANO as "Ano"
FROM Emissao
INNER JOIN Regiao ON Emissao.ID_REGIAO = Regiao.ID
inner JOIN TipoEmissao on Emissao.ID_TIPO_EMISSAO = TipoEmissao.ID
group by Regiao.NOME, TipoEmissao.NOME
having Regiao.ID in (150, 155);

-- Seleciona os dados de emissão, baseado nos ids de várias regiões e em um período de anos
SELECT Regiao.ID as "ID Região", Regiao.NOME as "Região", TipoEmissao.NOME as "Gás Emitido", Emissao.EMITIDO, Emissao.MES as "Mês", Emissao.ANO as "Ano"
FROM Emissao
INNER JOIN Regiao ON Emissao.ID_REGIAO = Regiao.ID
inner JOIN TipoEmissao on Emissao.ID_TIPO_EMISSAO = TipoEmissao.ID
group by Regiao.NOME, TipoEmissao.NOME
having Regiao.ID in (90, 95) and Emissao.ANO BETWEEN 1994 and 1996;

-- Seleciona a média dos dados de emissão, baseado nos ids de várias regiões e em um período de anos
SELECT Regiao.ID as "ID Região", Regiao.NOME, TipoEmissao.NOME as "Gás Emitido", Emissao.ANO as "Ano",
AVG(Emissao.EMITIDO) as "Emissão média"
FROM Emissao
INNER JOIN Regiao ON Emissao.ID_REGIAO = Regiao.ID
inner JOIN TipoEmissao on Emissao.ID_TIPO_EMISSAO = TipoEmissao.ID
GROUP BY Regiao.ID, Emissao.ANO
HAVING Regiao.ID IN (51, 66) and Emissao.ANO between 1980 and 1990;

-- Seleciona os dados de emissão, baseado nos ids de várias regiões e em um período de meses
SELECT Regiao.ID as "ID Região", Regiao.NOME as "Região", TipoEmissao.NOME as "Gás Emitido", Emissao.EMITIDO, Emissao.MES as "Mês", Emissao.ANO as "Ano"
FROM Emissao
INNER JOIN Regiao ON Emissao.ID_REGIAO = Regiao.ID
inner JOIN TipoEmissao on Emissao.ID_TIPO_EMISSAO = TipoEmissao.ID
group by Regiao.NOME, TipoEmissao.NOME
having Regiao.ID in (90, 95) and Emissao.Mes BETWEEN 1 and 6;

-- Seleciona a média dos dados de emissão baseado nos ids de várias regiões e em um período de meses
SELECT Regiao.ID as "ID Região", Regiao.NOME, TipoEmissao.NOME as "Gás Emitido", Emissao.MES as "Mês",
AVG(Emissao.EMITIDO) as "Emissão média"
FROM Emissao
INNER JOIN Regiao ON Emissao.ID_REGIAO = Regiao.ID
inner JOIN TipoEmissao on Emissao.ID_TIPO_EMISSAO = TipoEmissao.ID
GROUP BY Regiao.ID, Emissao.MES
HAVING Regiao.ID IN (51, 66) and Emissao.MES between 8 and 11;

-- Seleciona os dados de emissão, baseado nos ids de várias regiões e em um determinado gás
SELECT Regiao.ID as "ID Região", Regiao.NOME as "Região", TipoEmissao.ID, TipoEmissao.NOME as "Gás Emitido", Emissao.EMITIDO, Emissao.MES as "Mês", Emissao.ANO as "Ano"
FROM Emissao
INNER JOIN Regiao ON Emissao.ID_REGIAO = Regiao.ID
inner JOIN TipoEmissao on Emissao.ID_TIPO_EMISSAO = TipoEmissao.ID
group by Regiao.NOME
having Regiao.ID in (51, 155) and TipoEmissao.ID = 2;


-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Seleciona os dados de matriz energética, baseado nos ids de várias regiões
SELECT Regiao.ID as "ID Região", Regiao.NOME as "Região", TipoEnergia.ID, TipoEnergia.NOME as "Tipo de fonte de energia", MatrizEnergetica.QTD_GERADO, MatrizEnergetica.MES as "Mês", MatrizEnergetica.ANO as "Ano"
FROM MatrizEnergetica
INNER JOIN Regiao ON MatrizEnergetica.ID_REGIAO = Regiao.ID
inner JOIN TipoEnergia on MatrizEnergetica.ID_TIPO_ENERGIA = TipoEnergia.ID
group by Regiao.NOME, TipoEnergia.NOME
having Regiao.ID in (150, 155);

-- Seleciona os dados de matriz energética, baseado nos ids de várias regiões e em um período de anos
SELECT Regiao.ID as "ID Região", Regiao.NOME as "Região", TipoEnergia.NOME as "Tipo de fonte de energia", MatrizEnergetica.QTD_GERADO, MatrizEnergetica.MES as "Mês", MatrizEnergetica.ANO as "Ano"
FROM MatrizEnergetica
INNER JOIN Regiao ON MatrizEnergetica.ID_REGIAO = Regiao.ID
inner JOIN TipoEnergia on MatrizEnergetica.ID_TIPO_ENERGIA = TipoEnergia.ID
group by Regiao.NOME, TipoEnergia.NOME
having Regiao.ID in (150, 155) and MatrizEnergetica.ANO BETWEEN 1999 and 2006;

-- Seleciona a média dos dados de matriz energética, baseado nos ids de várias regiões e em um período de anos
SELECT Regiao.ID as "ID Região", Regiao.NOME, TipoEnergia.NOME as "Tipo de fonte de energia", MatrizEnergetica.ANO as "Ano",
AVG(MatrizEnergetica.QTD_GERADO) as "Média de Energia Gerada"
FROM MatrizEnergetica
INNER JOIN Regiao ON MatrizEnergetica.ID_REGIAO = Regiao.ID
inner JOIN TipoEnergia on MatrizEnergetica.ID_TIPO_ENERGIA = TipoEnergia.ID
GROUP BY Regiao.ID, MatrizEnergetica.ANO
HAVING Regiao.ID IN (51, 66) and MatrizEnergetica.ANO between 1980 and 2010;

-- Seleciona os dados de matriz energética, baseado nos ids de várias regiões e em um período de meses
SELECT Regiao.ID as "ID Região", Regiao.NOME as "Região", TipoEnergia.NOME as "Tipo de fonte de energia", MatrizEnergetica.QTD_GERADO, MatrizEnergetica.MES as "Mês", MatrizEnergetica.ANO as "Ano"
FROM MatrizEnergetica
INNER JOIN Regiao ON MatrizEnergetica.ID_REGIAO = Regiao.ID
inner JOIN TipoEnergia on MatrizEnergetica.ID_TIPO_ENERGIA = TipoEnergia.ID
group by Regiao.NOME, TipoEnergia.NOME
having Regiao.ID in (150, 155) and MatrizEnergetica.MES BETWEEN 2 and 10;

-- Seleciona a média dos dados de matriz energética, baseado nos ids de várias regiões e em um período de meses
SELECT Regiao.ID as "ID Região", Regiao.NOME, TipoEnergia.NOME as "Tipo de fonte de energia", MatrizEnergetica.MES as "Mês",
AVG(MatrizEnergetica.QTD_GERADO) as "Média de Energia Gerada"
FROM MatrizEnergetica
INNER JOIN Regiao ON MatrizEnergetica.ID_REGIAO = Regiao.ID
inner JOIN TipoEnergia on MatrizEnergetica.ID_TIPO_ENERGIA = TipoEnergia.ID
GROUP BY Regiao.ID, MatrizEnergetica.MES
HAVING Regiao.ID IN (51, 66) and MatrizEnergetica.MES between 8 and 11;

-- Seleciona os dados de matriz energética, baseado nos ids de várias regiões e com uma determinada fonte de energia
SELECT Regiao.ID as "ID Região", Regiao.NOME as "Região", TipoEnergia.ID, TipoEnergia.NOME as "Tipo de fonte de energia", MatrizEnergetica.QTD_GERADO, MatrizEnergetica.MES as "Mês", MatrizEnergetica.ANO as "Ano"
FROM MatrizEnergetica
INNER JOIN Regiao ON MatrizEnergetica.ID_REGIAO = Regiao.ID
inner JOIN TipoEnergia on MatrizEnergetica.ID_TIPO_ENERGIA = TipoEnergia.ID
group by Regiao.NOME, TipoEnergia.ID
having Regiao.ID in (150, 155) and TipoEnergia.ID = 2;


-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Seleciona os dados dos editores das regiões escolhidas
select * from Editor where ID_REGIAO in (29, 30, 31, 32);


-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Seleciona os dados de todas as regiões de um determinado tipo de região
select * from Regiao where ID_TIPO_REGIAO = 2;
