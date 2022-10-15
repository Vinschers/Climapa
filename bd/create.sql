CREATE TABLE TipoImpacto (
	ID int NOT NULL AUTO_INCREMENT,
	NOME varchar(30) NOT NULL,
	DESCRICAO varchar(50) NOT NULL,
	CONSTRAINT PK_TipoImpacto PRIMARY KEY (ID)
);

CREATE TABLE TipoEmissao (
	ID int NOT NULL AUTO_INCREMENT,
	NOME varchar(30) NOT NULL,
	DESCRICAO varchar(50) NOT NULL,
	NOCIVIDADE double NOT NULL,
	CONSTRAINT PK_TipoEmissao PRIMARY KEY (ID)
);

CREATE TABLE TipoEnergia (
	ID int NOT NULL AUTO_INCREMENT,
	NOME varchar(30) NOT NULL,
	DESCRICAO varchar(50) NOT NULL,
	CONSTRAINT PK_TipoEnergia PRIMARY KEY (ID)
);

CREATE TABLE TipoRegiao (
	ID int NOT NULL AUTO_INCREMENT,
	NOME varchar(30) NOT NULL,
	PLURAL varchar(30) NOT NULL,
	CONSTRAINT PK_TipoRegiao PRIMARY KEY (ID)
);

CREATE TABLE Regiao (
	ID int NOT NULL AUTO_INCREMENT,
	NOME varchar(30) NOT NULL,
	TAMANHO int NOT NULL,
	ID_TIPO_REGIAO int NOT NULL,
	ID_REGIAO_PAI int NOT NULL,
	ARTIGO varchar(1) NOT NULL,
	CONSTRAINT PK_Regiao PRIMARY KEY (ID),
	CONSTRAINT FK_TipoRegiaoRegiao FOREIGN KEY (ID_TIPO_REGIAO)
	REFERENCES TipoRegiao(ID),
	CONSTRAINT FK_RegiaoPaiRegiao FOREIGN KEY (ID_REGIAO_PAI)
	REFERENCES Regiao(ID)
);

CREATE TABLE Editor (
	ID int NOT NULL AUTO_INCREMENT,
	NOME varchar(30) NOT NULL,
	FORMACAO varchar(20) NOT NULL,
	ID_REGIAO int NOT NULL,
	CONSTRAINT PK_Editor PRIMARY KEY (ID),
	CONSTRAINT FK_RegiaoEditor FOREIGN KEY (ID_REGIAO)
	REFERENCES Regiao(ID)
);

CREATE TABLE Populacao (
	ID_REGIAO int NOT NULL,
	MES int NOT NULL,
	ANO int NOT NULL,
	QTD_PESSOAS int NOT NULL,
	QTD_NASCIMENTOS int NOT NULL,
	QTD_MORTES int NOT NULL,
	CONSTRAINT PK_Populacao PRIMARY KEY (ID_REGIAO, MES, ANO),
	CONSTRAINT FK_RegiaoPopulacao FOREIGN KEY (ID_REGIAO)
	REFERENCES Regiao(ID)
);

CREATE TABLE Clima (
	ID_REGIAO int NOT NULL,
	MES int NOT NULL,
	ANO int NOT NULL,
	TEMPERATURA_MEDIA double NOT NULL,
	UNIDADE_TEMPERATURA varchar(1) NOT NULL,
	INDICE_PLUVIOMETRICO int NOT NULL,
	CONSTRAINT PK_Clima PRIMARY KEY (ID_REGIAO, MES, ANO),
	CONSTRAINT FK_RegiaoClima FOREIGN KEY (ID_REGIAO)
	REFERENCES Regiao(ID)
);

CREATE TABLE Vegetacao (
	ID_REGIAO int NOT NULL,
	MES int NOT NULL,
	ANO int NOT NULL,
	QTD_QUEIMADAS int NOT NULL,
	INDICE_MATA_NATIVA int NOT NULL,
	INDICE_REFLORESTAMENTO int NOT NULL,
	INDICE_DESMATAMENTO int NOT NULL,
	CONSTRAINT PK_Vegetacao PRIMARY KEY (ID_REGIAO, MES, ANO),
	CONSTRAINT FK_RegiaoVegetacao FOREIGN KEY (ID_REGIAO)
	REFERENCES Regiao(ID)
);

CREATE TABLE Impacto (
	ID_REGIAO int NOT NULL,
	MES int NOT NULL,
	ANO int NOT NULL,
	VALOR int NOT NULL,
	ID_TIPO_IMPACTO int NOT NULL,
	CONSTRAINT PK_Impacto PRIMARY KEY (ID_REGIAO, MES, ANO),
	CONSTRAINT FK_RegiaoImpacto FOREIGN KEY (ID_REGIAO)
	REFERENCES Regiao(ID),
	CONSTRAINT FK_TipoImpactoImpacto FOREIGN KEY (ID_TIPO_IMPACTO)
	REFERENCES TipoImpacto(ID)
);

CREATE TABLE Emissao (
	ID_REGIAO int NOT NULL,
	MES int NOT NULL,
	ANO int NOT NULL,
	ID_TIPO_EMISSAO int NOT NULL,
	EMITIDO varchar(20) NOT NULL,
	CONSTRAINT PK_Emissao PRIMARY KEY (ID_REGIAO, MES, ANO),
	CONSTRAINT FK_RegiaoEmissao FOREIGN KEY (ID_REGIAO)
	REFERENCES Regiao(ID),
	CONSTRAINT FK_TipoEmissaoEmissao FOREIGN KEY (ID_TIPO_EMISSAO)
	REFERENCES TipoEmissao(ID)
);

CREATE TABLE MatrizEnergetica (
	ID_REGIAO int NOT NULL,
	MES int NOT NULL,
	ANO int NOT NULL,
	ID_TIPO_ENERGIA int NOT NULL,
	QTD_GERADO int NOT NULL,
	CONSTRAINT PK_MatrizEnergetica PRIMARY KEY (ID_REGIAO, MES, ANO),
	CONSTRAINT FK_RegiaoMatrizEnergetica FOREIGN KEY (ID_REGIAO)
	REFERENCES Regiao(ID),
	CONSTRAINT FK_TipoEnergiaMatrizEnergetica FOREIGN KEY (ID_TIPO_ENERGIA)
	REFERENCES TipoEnergia(ID)
);
