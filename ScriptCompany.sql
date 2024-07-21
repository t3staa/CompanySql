--Leonardo Testa | Laboratório de Banco de dados 
--Análise e Desenvolvimento de Sistemas - 5º Semestre 
--Data: 10/06/2024

--CRIANDO AS TABELAS
CREATE TABLE tb_regiao(
id_regiao   NUMBER CONSTRAINT nn_id_regiao NOT NULL,
nm_regiao   VARCHAR(25)
);

CREATE UNIQUE INDEX pk_id_regiao
ON tb_regiao(id_regiao);

ALTER TABLE tb_regiao
ADD(CONSTRAINT pk_id_regiao
    PRIMARY KEY(id_regiao));

DESCRIBE tb_regiao;

CREATE TABLE tb_pais(
id_pais     CHAR(2) CONSTRAINT nn_id_pais NOT NULL,
nm_pais     VARCHAR2(40),
id_regiao   NUMBER,
CONSTRAINT pk_id_pais PRIMARY KEY(id_pais));

ALTER TABLE tb_pais
ADD(CONSTRAINT fk_regiao_pais FOREIGN KEY(id_regiao)
                              REFERENCES tb_regiao(id_regiao));

CREATE TABLE tb_localizacao(
id_localizacao  NUMBER(4),
id_pais         CHAR(2),
endereco        VARCHAR2(40),
cep             VARCHAR2(12),
cidade          VARCHAR2(30) CONSTRAINT nn_loc_cidade NOT NULL,
estado          VARCHAR2(25));

CREATE UNIQUE INDEX pk_id_localizacao
ON tb_localizacao(id_localizacao);

ALTER TABLE tb_localizacao
ADD(CONSTRAINT pk_id_loc PRIMARY KEY(id_localizacao),
    CONSTRAINT fk_id_pais FOREIGN KEY(id_pais) REFERENCES tb_pais(id_pais));
    
CREATE SEQUENCE seq_localizacao
START WITH      3300
INCREMENT BY    100
MAXVALUE       9900
NOCACHE
NOCYCLE;

CREATE TABLE tb_departamento(
id_departamento     NUMBER(4),
nm_departamento     VARCHAR2(30) CONSTRAINT nn_nm_depto NOT NULL,
id_gerente          NUMBER(6),
id_localizacao      NUMBER(4));

ALTER TABLE tb_departamento
ADD(CONSTRAINT pk_id_departamento PRIMARY KEY(id_departamento),
    CONSTRAINT fk_loc_departamento FOREIGN KEY(id_localizacao) 
                                   REFERENCES tb_localizacao(id_localizacao));

CREATE SEQUENCE seq_departamento
START WITH      280
INCREMENT BY    10
MAXVALUE        9990
NOCACHE
NOCYCLE;

CREATE TABLE tb_funcao(
id_funcao       VARCHAR2(10),
ds_funcao       VARCHAR2(35) CONSTRAINT nn_ds_funcao NOT NULL,
base_salario    NUMBER(8,2),
teto_salario    NUMBER(8,2));

CREATE UNIQUE INDEX pk_id_funcao
ON tb_funcao(id_funcao);

ALTER TABLE tb_funcao
ADD(CONSTRAINT pk_id_funcao PRIMARY KEY(id_funcao));

CREATE TABLE tb_empregado(
id_empregado        NUMBER(6),
nome                VARCHAR2(20),
sobrenome           VARCHAR2(25) CONSTRAINT nn_emp_sobrenome NOT NULL,
email               VARCHAR2(25) CONSTRAINT nn_emp_email NOT NULL,
telefone            VARCHAR2(20),
data_admissao       DATE CONSTRAINT nn_emp_dt_adm NOT NULL,
id_funcao           VARCHAR2(10) CONSTRAINT nn_emp_funcao NOT NULL,
salario             NUMBER(8,2),
percentual_comissao NUMBER(2,2),
id_gerente          NUMBER(6),
id_departamento     NUMBER(4),
CONSTRAINT min_emp_salario CHECK(salario > 0),
CONSTRAINT un_emp_email UNIQUE(email));

CREATE UNIQUE INDEX pk_id_emp
ON tb_empregado(id_empregado);

ALTER TABLE tb_empregado
ADD(CONSTRAINT pk_id_emp PRIMARY KEY(id_empregado),
    CONSTRAINT fk_emp_depto FOREIGN KEY(id_departamento)
                            REFERENCES tb_departamento,
    CONSTRAINT fk_emp_funcao FOREIGN KEY(id_funcao)
                             REFERENCES tb_funcao(id_funcao),
    CONSTRAINT fk_emp_gerente FOREIGN KEY(id_gerente)
                              REFERENCES tb_empregado);

ALTER TABLE tb_departamento
ADD(CONSTRAINT fk_gerente_depto FOREIGN KEY(id_gerente)
                                REFERENCES tb_empregado(id_empregado));
                                
CREATE SEQUENCE seq_empregado
START WITH      207
INCREMENT BY    1
NOCACHE
NOCYCLE;

CREATE TABLE tb_historico_funcao(
id_empregado        NUMBER(6) CONSTRAINT nn_hist_emp_id_emp NOT NULL,
data_inicio         DATE CONSTRAINT nn_hist_emp_dt_inicio NOT NULL,
data_termino        DATE CONSTRAINT nn_hist_emp_dt_termino NOT NULL,
id_funcao           VARCHAR2(10) CONSTRAINT nn_hist_emp_id_funcao NOT NULL,
id_departamento     NUMBER(4),
CONSTRAINT ck_hist_emp_data_intervalo CHECK(data_termino > data_inicio));

CREATE UNIQUE INDEX pk_hist_emp_id_emp
ON tb_historico_funcao(id_empregado, data_inicio);

ALTER TABLE tb_historico_funcao
ADD(CONSTRAINT pk_hist_emp_id_emp PRIMARY KEY(id_empregado, data_inicio),
    CONSTRAINT fk_hist_funcao_funcao FOREIGN KEY(id_funcao)
                                     REFERENCES tb_funcao,
    CONSTRAINT fk_hist_funcao_emp FOREIGN KEY(id_empregado)
                                  REFERENCES tb_empregado,
    CONSTRAINT fk_hist_funcao_depto FOREIGN KEY(id_departamento)
                                    REFERENCES tb_departamento);
                                    
--INSERINDO DADOS NA TABELA tb_regiao
INSERT INTO tb_regiao  
VALUES (1, 'Europa'); 

INSERT INTO tb_regiao 
VALUES (2, 'Américas'); 

INSERT INTO tb_regiao  
VALUES (3, 'Ásia'); 

INSERT INTO tb_regiao  
VALUES (4, 'Oriente Médio e África');

--VERIFICANDO OS DADOS NA TABELA
SELECT *
FROM tb_regiao;

--INSERINDO DADOS NA TABELA tb_pais
INSERT INTO tb_pais  
VALUES ( 'IT', 'Itália', 1); 

INSERT INTO tb_pais  
VALUES ( 'JP', 'Japão', 3); 

INSERT INTO tb_pais  
VALUES ( 'US', 'EUA', 2); 

INSERT INTO tb_pais  
VALUES ( 'CA', 'Canadá', 2); 

INSERT INTO tb_pais  
VALUES ( 'CN', 'China', 3); 

INSERT INTO tb_pais  
VALUES ( 'IN', 'Índia', 3); 

INSERT INTO tb_pais  
VALUES ( 'AU', 'Austrália', 3); 

INSERT INTO tb_pais  
VALUES ( 'ZW', 'Zimbábue', 4); 

INSERT INTO tb_pais
VALUES('SG', 'Cingapura', 3);

INSERT INTO tb_pais  
VALUES ( 'UK', 'Reino Unido', 1); 

INSERT INTO tb_pais  
VALUES ( 'FR', 'França', 1); 

INSERT INTO tb_pais  
VALUES ( 'DE', 'Alemanha', 1); 

INSERT INTO tb_pais  
VALUES ( 'ZM', 'Zâmbia', 4); 

INSERT INTO tb_pais  
VALUES ( 'EG', 'Egito', 4); 

INSERT INTO tb_pais  
VALUES ( 'BR', 'Brasil', 2); 

INSERT INTO tb_pais  
VALUES ( 'CH', 'Suíça', 1); 

INSERT INTO tb_pais  
VALUES ( 'NL', 'Holanda', 1); 

INSERT INTO tb_pais  
VALUES ( 'MX', 'México', 2); 

INSERT INTO tb_pais  
VALUES ( 'KW', 'Kuweit', 4); 

INSERT INTO tb_pais  
VALUES ( 'IL', 'Israel', 4 ); 

INSERT INTO tb_pais  
VALUES ( 'DK', 'Dinamarca', 1); 

INSERT INTO tb_pais  
VALUES ( 'HK', 'Hong Kong', 3); 

INSERT INTO tb_pais  
VALUES ( 'NG', 'Nigéria', 4 ); 

INSERT INTO tb_pais  
VALUES ( 'AR', 'Argentina', 2); 

INSERT INTO tb_pais  
VALUES ( 'BE', 'Bélgica', 1 ); 
                                  
--VERIFICANDO OS DADOS NA TABELA
SELECT *
FROM tb_pais;

--INSERINDO OS DADOS NA TABELA tb_localizacao
INSERT INTO tb_localizacao
VALUES(1000, 'IT', 'Via Cola di Rie, 1297', '00989', 'Roma', NULL);

INSERT INTO tb_localizacao  
VALUES ( 1100, 'IT', 'Calle della Testa, 93091', '10934', 'Veneza', NULL); 

INSERT INTO tb_localizacao  
VALUES ( 1200, 'JP', 'Shinjuku-ku, 2017 ', '1689', 'Tóquio', 'Prefeitura de Tóquio'); 

INSERT INTO tb_localizacao  
VALUES ( 1300, 'JP', 'Kamiya-cho, 9450 ', '6823', 'Hiroshima', NULL); 

INSERT INTO tb_localizacao  
VALUES ( 1400, 'US' , 'Jabberwocky Rd, 2014 ', '26192', 'Southlake', 'Texas'); 

INSERT INTO tb_localizacao  
VALUES  (1500, 'US', 'Interiors Blvd, 2011 ', '99236', 'Sul de São Francisco', 'Califórnia'); 

INSERT INTO tb_localizacao  
VALUES (1600, 'US', 'Zagora St, 2007 ', '50090', 'South Brunswick', 'New Jersey'); 

INSERT INTO tb_localizacao  
VALUES (1700, 'US', 'Charade Rd, 2004 ', '98199', 'Seattle', 'Washington'); 

INSERT INTO tb_localizacao  
VALUES (1800, 'CA', 'Spadina Ave, 147 ', 'M5V 2L7', 'Toronto', 'Ontário'); 

INSERT INTO tb_localizacao  
VALUES (1900, 'CA', 'Boxwood St, 6092 ', 'YSW 9T2', 'Whitehorse', 'Yukon'); 

INSERT INTO tb_localizacao  
VALUES (2000, 'CN', 'Laogianggen, 40-5-12', '190518', 'Pequim', NULL); 

INSERT INTO tb_localizacao  
VALUES (2100, 'IN', 'Vileparle (E), 1298 ', '490231', 'Bombaim', 'Maharashtra'); 

INSERT INTO tb_localizacao  
VALUES (2200, 'AU', 'Victoria Street, 12-98', '2901', 'Sydney', 'Nova Gales do Sul'); 

INSERT INTO tb_localizacao  
VALUES (2300, 'SG', 'Clementi North, 198 ', '540198', 'Cingapua', NULL); 

INSERT INTO tb_localizacao  
VALUES (2400, 'UK', 'Arthur St, 8204 ', NULL, 'Londres', NULL); 

INSERT INTO tb_localizacao  
VALUES (2500, 'UK', 'Magdalen Centre, The Oxford Science Park', 'OX9 9ZB', 'Oxford', 'Oxford'); 

INSERT INTO tb_localizacao 
VALUES (2600, 'UK', 'Chester Road, 9702 ', '09629850293', 'Stretford', 'Manchester'); 

INSERT INTO tb_localizacao  
VALUES (2700, 'DE', 'Schwanthalerstr. 7031', '80925', 'Munique', 'Bavaria'); 

INSERT INTO tb_localizacao  
VALUES (2800, 'BR', 'Rua Frei Caneca 1360 ', '01307-002', 'São Paulo', 'São Paulo'); 

INSERT INTO tb_localizacao  
VALUES (2900, 'CH', 'Rue des Corps-Saints, 20', '1730', 'Geneva', 'Geneve'); 

INSERT INTO tb_localizacao  
VALUES (3000, 'CH', 'Murtenstrasse 921', '3095', 'Bern', 'BE'); 

INSERT INTO tb_localizacao  
VALUES (3100, 'NL', 'Pieter Breughelstraat 837', '3029SK', 'Utrecht', 'Utrecht'); 

INSERT INTO tb_localizacao  
VALUES (3200, 'MX', 'Mariano Escobedo 9991', '11932', 'Cidade do México', 'Distrito Federal');

--VERIFICANDO OS DADOS NA TABELA
SELECT *
FROM tb_localizacao;

--DESATIVANDO A RESTRIÇÃO DE INTEGRIDADE DA "tb_empregado" PARA CARREGAR OS DADOS
ALTER TABLE tb_departamento
    DISABLE CONSTRAINT fk_gerente_depto;

--INSERTINDO OS DADOS NA TABELA tb_departamento
INSERT INTO tb_departamento  
VALUES (10, 'Administração', 200, 1700); 

INSERT INTO tb_departamento  
VALUES (20, 'Marketing', 201, 1800); 

INSERT INTO tb_departamento  
VALUES (30, 'Aquisição', 114, 1700); 

INSERT INTO tb_departamento  
VALUES (40, 'Recursos Humanos', 203, 2400); 

INSERT INTO tb_departamento  
VALUES (50, 'Expedição', 121, 1500); 

INSERT INTO tb_departamento  
VALUES (60, 'TI', 103, 1400); 

INSERT INTO tb_departamento  
VALUES (70, 'Relações Públicas', 204, 2700); 

INSERT INTO tb_departamento  
VALUES (80, 'Vendas', 145, 2500); 

INSERT INTO tb_departamento  
VALUES (90, 'Executivo', 100, 1700); 

INSERT INTO tb_departamento  
VALUES (100, 'Financeiro', 108, 1700); 

INSERT INTO tb_departamento  
VALUES (110, 'Contabilidade', 205, 1700); 

INSERT INTO tb_departamento  
VALUES (120, 'Tesouraria', NULL, 1700); 

INSERT INTO tb_departamento  
VALUES (130, 'Corporativo', NULL, 1700); 

INSERT INTO tb_departamento  
VALUES (140, 'Controle de Crédito', NULL, 1700); 

INSERT INTO tb_departamento  
VALUES (150, 'Suporte de Serviços', NULL, 1700); 

INSERT INTO tb_departamento  
VALUES (160, 'Benefícios', NULL, 1700); 

INSERT INTO tb_departamento  
VALUES (170, 'Fábrica', NULL, 1700); 

INSERT INTO tb_departamento  
VALUES (180, 'Construção', NULL, 1700); 

INSERT INTO tb_departamento  
VALUES (190, 'Contratante', NULL, 1700); 

INSERT INTO tb_departamento  
VALUES (200, 'Operações', NULL, 1700); 

INSERT INTO tb_departamento  
VALUES (210, 'Suporte de TI', NULL, 1700); 

INSERT INTO tb_departamento  
VALUES (220, 'NOC', NULL, 1700); 

INSERT INTO tb_departamento  
VALUES (230, 'Helpdesk', NULL, 1700); 

INSERT INTO tb_departamento  
VALUES (240, 'Vendas Governo', NULL, 1700);

INSERT INTO tb_departamento  
VALUES (250, 'Vendas Varejo', NULL, 1700); 

INSERT INTO tb_departamento  
VALUES (260, 'Recrutamento', NULL, 1700); 

INSERT INTO tb_departamento  
VALUES (270, 'Folha de Pagamentos', NULL, 1700); 

--VERIFICANDO OS DADOS NA TABELA
SELECT *
FROM tb_departamento;

--INSERINDO DADOS NA TABELA tb_funcao
INSERT INTO tb_funcao  
VALUES ('AD_PRES', 'Presidente', 20000, 40000); 

INSERT INTO tb_funcao  
VALUES ('AD_VP', 'Vice Presidente Administrativo', 15000, 30000); 

INSERT INTO tb_funcao  
VALUES ('AD_ASST', 'Assistente Administrativo', 3000, 6000); 

INSERT INTO tb_funcao  
VALUES ('FI_MGR', 'Gerente Financeiro', 8200, 16000); 

INSERT INTO tb_funcao  
VALUES ('FI_ACCOUNT', 'Contador', 4200, 9000); 

INSERT INTO tb_funcao  
VALUES ('AC_MGR', 'Gerente de Contabilidade', 8200, 16000); 

INSERT INTO tb_funcao  
VALUES ('AC_ACCOUNT', 'Contador Público', 4200, 9000); 

INSERT INTO tb_funcao  
VALUES ('SA_MAN', 'Gerente de Vendas', 10000, 20000); 

INSERT INTO tb_funcao  
VALUES ('SA_REP', 'Representante de Vendas', 6000, 12000); 

INSERT INTO tb_funcao  
VALUES ('PU_MAN', 'Gerente de Compras', 8000, 15000); 

INSERT INTO tb_funcao  
VALUES ('PU_CLERK', 'Compras', 2500, 5500); 

INSERT INTO tb_funcao  
VALUES ('ST_MAN', 'Gerente de Estoque', 5500, 8500); 

INSERT INTO tb_funcao  
VALUES ('ST_CLERK', 'Estoque', 2000, 5000); 

INSERT INTO tb_funcao  
VALUES ('SH_CLERK', 'Despachante', 2500, 5500); 

INSERT INTO tb_funcao  
VALUES ('IT_PROG', 'Programador', 4000, 10000); 

INSERT INTO tb_funcao  
VALUES ('MK_MAN', 'Gerente de Marketing', 9000, 15000); 

INSERT INTO tb_funcao  
VALUES ('MK_REP', 'Representante de Marketing', 4000, 9000); 

INSERT INTO tb_funcao  
VALUES ( 'HR_REP', 'Representante de RH', 4000, 9000); 

DESCRIBE tb_funcao;

--MODIFICANDO O TAMANHO DA COLUNA ds_funcao DA tb_funcao
ALTER TABLE tb_funcao MODIFY ds_funcao VARCHAR2(40);

INSERT INTO tb_funcao  
VALUES ('PR_REP', 'Representante de Relações Pública', 4500, 10500);

--VERIFICANDO OS DADOS DA TABELA
SELECT *
FROM tb_funcao;

--INSERINDO DADOS NA TABELA tb_empregados
INSERT INTO tb_empregado  
VALUES  
( 100, 'Steven', 'King', 'SKING', '515.123.4567', TO_DATE('17-JUN-1987', 'dd-MON-yyyy') 
, 'AD_PRES', 24000.00, NULL, NULL, 90); 

INSERT INTO tb_empregado  
VALUES  
( 101, 'Neena', 'Kochhar', 'NKOCHHAR', '515.123.4568', TO_DATE('21-SET-1989', 'dd-MON-yyyy') 
, 'AD_VP', 17000.00, NULL, 100, 90); 

INSERT INTO tb_empregado  
VALUES  
( 102, 'Lex', 'De Haan', 'LDEHAAN', '515.123.4569', TO_DATE('13-JAN-1993', 'dd-MON-yyyy') 
, 'AD_VP', 17000.00, NULL, 100, 90); 

INSERT INTO tb_empregado  
VALUES  
( 103, 'Alexander', 'Hunold', 'AHUNOLD', '590.423.4567', TO_DATE('03-JAN-1990', 'dd-MON-yyyy') 
, 'IT_PROG', 9000.00, NULL, 102, 60); 

INSERT INTO tb_empregado  
VALUES  
( 104, 'Bruce', 'Ernst', 'BERNST', '590.423.4568', TO_DATE('21-MAI-1991', 'dd-MON-yyyy') 
, 'IT_PROG', 6000.00, NULL, 103, 60); 

INSERT INTO tb_empregado  
VALUES  
( 105, 'David', 'Austin', 'DAUSTIN', '590.423.4569', TO_DATE('25-JUN-1997', 'dd-MON-yyyy') 
, 'IT_PROG', 4800.00, NULL, 103, 60); 

INSERT INTO tb_empregado  
VALUES  
( 106, 'Valli', 'Pataballa', 'VPATABAL', '590.423.4560', TO_DATE('05-FEV-1998', 'dd-MON-yyyy') 
, 'IT_PROG', 4800.00, NULL, 103, 60);

INSERT INTO tb_empregado  
VALUES  
( 107, 'Diana', 'Lorentz', 'DLORENTZ', '590.423.5567', TO_DATE('07-FEV-1999', 'dd-MON-yyyy') 
, 'IT_PROG', 4200.00, NULL, 103, 60); 

INSERT INTO tb_empregado  
VALUES  
( 108, 'Nancy', 'Greenberg', 'NGREENBE', '515.124.4569', TO_DATE('17-AGO-1994', 'dd-MON-yyyy') 
, 'FI_MGR', 12000.00, NULL, 101, 100); 

INSERT INTO tb_empregado  
VALUES  
( 109, 'Daniel', 'Faviet', 'DFAVIET', '515.124.4169', TO_DATE('16-AGO-1994', 'dd-MON-yyyy') 
, 'FI_ACCOUNT', 9000.00, NULL, 108, 100); 

INSERT INTO tb_empregado  
VALUES  
( 110, 'John', 'Chen', 'JCHEN', '515.124.4269', TO_DATE('28-SET-1997', 'dd-MON-yyyy') 
, 'FI_ACCOUNT', 8200.00, NULL, 108, 100); 

INSERT INTO tb_empregado  
VALUES  
( 111, 'Ismael', 'Sciarra', 'ISCIARRA', '515.124.4369', TO_DATE('30-SET-1997', 'dd-MON-yyyy') 
, 'FI_ACCOUNT', 7700.00, NULL, 108, 100); 

INSERT INTO tb_empregado  
VALUES  
( 112, 'Jose Manuel', 'Urman', 'JMURMAN', '515.124.4469', TO_DATE('07-MAR-1998', 'dd-MON-yyyy') 
, 'FI_ACCOUNT', 7800.00, NULL, 108, 100); 

INSERT INTO tb_empregado  
VALUES  
( 113, 'Luis', 'Popp', 'LPOPP', '515.124.4567', TO_DATE('07-DEZ-1999', 'dd-MON-yyyy') 
, 'FI_ACCOUNT', 6900.00, NULL, 108, 100); 

INSERT INTO tb_empregado  
VALUES  
( 114, 'Den', 'Raphaely', 'DRAPHEAL', '515.127.4561', TO_DATE('07-DEZ-1994', 'dd-MON-yyyy') 
, 'PU_MAN', 11000.00, NULL, 100, 30);

INSERT INTO tb_empregado  
VALUES  
( 115, 'Alexander', 'Khoo', 'AKHOO', '515.127.4562', TO_DATE('18-MAI-1995', 'dd-MON-yyyy') 
, 'PU_CLERK', 3100.00, NULL, 114, 30); 

INSERT INTO tb_empregado  
VALUES  
( 116, 'Shelli', 'Baida', 'SBAIDA', '515.127.4563', TO_DATE('24-DEZ-1997', 'dd-MON-yyyy') 
, 'PU_CLERK', 2900.00, NULL, 114, 30); 

INSERT INTO tb_empregado  
VALUES  
( 117, 'Sigal', 'Tobias', 'STOBIAS', '515.127.4564', TO_DATE('24-JUL-1997', 'dd-MON-yyyy') 
, 'PU_CLERK', 2800.00, NULL, 114, 30); 

INSERT INTO tb_empregado  
VALUES  
( 118, 'Guy', 'Himuro', 'GHIMURO', '515.127.4565', TO_DATE('15-NOV-1998', 'dd-MON-yyyy') 
, 'PU_CLERK', 2600.00, NULL, 114, 30); 

INSERT INTO tb_empregado  
VALUES  
( 119, 'Karen', 'Colmenares', 'KCOLMENA', '515.127.4566', TO_DATE('10-AGO-1999', 'dd-MON-yyyy') 
, 'PU_CLERK', 2500.00, NULL, 114, 30); 

INSERT INTO tb_empregado  
VALUES  
( 120, 'Matthew', 'Weiss', 'MWEISS', '650.123.1234', TO_DATE('18-JUL-1996', 'dd-MON-yyyy') 
, 'ST_MAN', 8000.00, NULL, 100, 50); 

INSERT INTO tb_empregado  
VALUES  
( 121, 'Adam', 'Fripp', 'AFRIPP', '650.123.2234', TO_DATE('10-ABR-1997', 'dd-MON-yyyy') 
, 'ST_MAN', 8200.00, NULL, 100, 50); 

INSERT INTO tb_empregado  
VALUES  
( 122, 'Payam', 'Kaufling', 'PKAUFLIN', '650.123.3234', TO_DATE('01-MAI-1995', 'dd-MON-yyyy') 
, 'ST_MAN', 7900.00, NULL, 100, 50); 

INSERT INTO tb_empregado  
VALUES  
( 123, 'Shanta', 'Vollman', 'SVOLLMAN', '650.123.4234', TO_DATE('10-OUT-1997', 'dd-MON-yyyy') 
, 'ST_MAN', 6500.00, NULL, 100, 50); 

INSERT INTO tb_empregado  
VALUES  
( 124, 'Kevin', 'Mourgos', 'KMOURGOS', '650.123.5234', TO_DATE('16-NOV-1999', 'dd-MON-yyyy') 
, 'ST_MAN', 5800.00, NULL, 100, 50);

INSERT INTO tb_empregado  
VALUES  
( 125, 'Julia', 'Nayer', 'JNAYER', '650.124.1214', TO_DATE('16-JUL-1997', 'dd-MON-yyyy') 
, 'ST_CLERK', 3200.00, NULL, 120, 50); 

INSERT INTO tb_empregado  
VALUES  
( 126, 'Irene', 'Mikkilineni', 'IMIKKILI', '650.124.1224', TO_DATE('28-SET-1998', 'dd-MON-yyyy') 
, 'ST_CLERK', 2700.00, NULL, 120, 50); 

INSERT INTO tb_empregado  
VALUES  
( 127, 'James', 'Landry', 'JLANDRY', '650.124.1334', TO_DATE('14-JAN-1999', 'dd-MON-yyyy') 
, 'ST_CLERK', 2400.00, NULL, 120, 50); 

INSERT INTO tb_empregado  
VALUES  
( 128, 'Steven', 'Markle', 'SMARKLE', '650.124.1434', TO_DATE('08-MAR-2000', 'dd-MON-yyyy') 
, 'ST_CLERK', 2200.00, NULL, 120, 50); 

INSERT INTO tb_empregado  
VALUES  
( 129, 'Laura', 'Bissot', 'LBISSOT', '650.124.5234', TO_DATE('20-AGO-1997', 'dd-MON-yyyy') 
, 'ST_CLERK', 3300.00, NULL, 121, 50); 

INSERT INTO tb_empregado  
VALUES  
( 130, 'Mozhe', 'Atkinson', 'MATKINSO', '650.124.6234', TO_DATE('30-OUT-1997', 'dd-MON-yyyy') 
, 'ST_CLERK', 2800.00, NULL, 121, 50); 

INSERT INTO tb_empregado  
VALUES  
( 131, 'James', 'Marlow', 'JAMRLOW', '650.124.7234', TO_DATE('16-FEV-1997', 'dd-MON-yyyy') 
, 'ST_CLERK', 2500.00, NULL, 121, 50); 

INSERT INTO tb_empregado  
VALUES  
( 132, 'TJ', 'Olson', 'TJOLSON', '650.124.8234', TO_DATE('10-ABR-1999', 'dd-MON-yyyy') 
, 'ST_CLERK', 2100.00, NULL, 121, 50); 

INSERT INTO tb_empregado  
VALUES  
( 133, 'Jason', 'Mallin', 'JMALLIN', '650.127.1934', TO_DATE('14-JUN-1996', 'dd-MON-yyyy') 
, 'ST_CLERK', 3300.00, NULL, 122, 50); 

INSERT INTO tb_empregado  
VALUES  
( 134, 'Michael', 'Rogers', 'MROGERS', '650.127.1834', TO_DATE('26-AGO-1998', 'dd-MON-yyyy') 
, 'ST_CLERK', 2900.00, NULL, 122, 50);

INSERT INTO tb_empregado  
VALUES  
( 135, 'Ki', 'Gee', 'KGEE', '650.127.1734', TO_DATE('12-DEZ-1999', 'dd-MON-yyyy') 
, 'ST_CLERK', 2400.00, NULL, 122, 50); 

INSERT INTO tb_empregado  
VALUES  
( 136, 'Hazel', 'Philtanker', 'HPHILTAN', '650.127.1634', TO_DATE('06-FEV-2000', 'dd-MON-yyyy') 
, 'ST_CLERK', 2200.00, NULL, 122, 50); 

INSERT INTO tb_empregado  
VALUES  
( 137, 'Renske', 'Ladwig', 'RLADWIG', '650.121.1234', TO_DATE('14-JUL-1995', 'dd-MON-yyyy') 
, 'ST_CLERK', 3600.00, NULL, 123, 50); 

INSERT INTO tb_empregado  
VALUES  
( 138, 'Stephen', 'Stiles', 'SSTILES', '650.121.2034', TO_DATE('26-OUT-1997', 'dd-MON-yyyy') 
, 'ST_CLERK', 3200.00, NULL, 123, 50); 

INSERT INTO tb_empregado  
VALUES  
( 139, 'John', 'Seo', 'JSEO', '650.121.2019', TO_DATE('12-FEV-1998', 'dd-MON-yyyy') 
, 'ST_CLERK', 2700.00, NULL, 123, 50); 

INSERT INTO tb_empregado  
VALUES  
( 140, 'Joshua', 'Patel', 'JPATEL', '650.121.1834', TO_DATE('06-ABR-1998', 'dd-MON-yyyy') 
, 'ST_CLERK', 2500.00, NULL, 123, 50); 

INSERT INTO tb_empregado  
VALUES  
( 141, 'Trenna', 'Rajs', 'TRAJS', '650.121.8009', TO_DATE('17-OUT-1995', 'dd-MON-yyyy') 
, 'ST_CLERK', 3500.00, NULL, 124, 50); 

INSERT INTO tb_empregado  
VALUES  
( 142, 'Curtis', 'Davies', 'CDAVIES', '650.121.2994', TO_DATE('29-JAN-1997', 'dd-MON-yyyy') 
, 'ST_CLERK', 3100.00, NULL, 124, 50); 

INSERT INTO tb_empregado  
VALUES  
( 143, 'Randall', 'Matos', 'RMATOS', '650.121.2874', TO_DATE('15-MAR-1998', 'dd-MON-yyyy') 
, 'ST_CLERK', 2600.00, NULL, 124, 50); 

INSERT INTO tb_empregado  
VALUES  
( 144, 'Peter', 'Vargas', 'PVARGAS', '650.121.2004', TO_DATE('09-JUL-1998', 'dd-MON-yyyy') 
, 'ST_CLERK', 2500.00, NULL, 124, 50);

INSERT INTO tb_empregado  
VALUES  
( 145, 'John', 'Russell', 'JRUSSEL', '011.44.1344.429268', TO_DATE('01-OUT-1996', 'dd-MON-yyyy') 
, 'SA_MAN', 14000.00, .4, 100, 80); 

INSERT INTO tb_empregado  
VALUES  
( 146, 'Karen', 'Partners', 'KPARTNER', '011.44.1344.467268', TO_DATE('05-JAN-1997', 'dd-MON-yyyy') 
, 'SA_MAN', 13500.00, .3, 100, 80); 

INSERT INTO tb_empregado  
VALUES  
( 147, 'Alberto', 'Errazuriz', 'AERRAZUR', '011.44.1344.429278', TO_DATE('10-MAR-1997', 'dd-MON-yyyy') 
, 'SA_MAN', 12000.00, .3, 100, 80); 

INSERT INTO tb_empregado  
VALUES  
( 148, 'Gerald', 'Cambrault', 'GCAMBRAU', '011.44.1344.619268', TO_DATE('15-OUT-1999', 'dd-MON-yyyy') 
, 'SA_MAN', 11000.00, .3, 100, 80); 

INSERT INTO tb_empregado  
VALUES  
( 149, 'Eleni', 'Zlotkey', 'EZLOTKEY', '011.44.1344.429018', TO_DATE('29-JAN-2000', 'dd-MON-yyyy') 
, 'SA_MAN', 10500.00, .2, 100, 80); 

INSERT INTO tb_empregado  
VALUES  
( 150, 'Peter', 'Tucker', 'PTUCKER', '011.44.1344.129268', TO_DATE('30-JAN-1997', 'dd-MON-yyyy') 
, 'SA_REP', 10000.00, .3, 145, 80); 

INSERT INTO tb_empregado  
VALUES  
( 151, 'David', 'Bernstein', 'DBERNSTE', '011.44.1344.345268', TO_DATE('24-MAR-1997', 'dd-MON-yyyy') 
, 'SA_REP', 9500.00, .25, 145, 80); 

INSERT INTO tb_empregado  
VALUES  
( 152, 'Peter', 'Hall', 'PHALL', '011.44.1344.478968', TO_DATE('20-AGO-1997', 'dd-MON-yyyy') 
, 'SA_REP', 9000.00, .25, 145, 80); 

INSERT INTO tb_empregado  
VALUES  
( 153, 'Christopher', 'Olsen', 'COLSEN', '011.44.1344.498718', TO_DATE('30-MAR-1998', 'dd-MON-yyyy') 
, 'SA_REP', 8000.00, .2, 145, 80); 

INSERT INTO tb_empregado  
VALUES  
( 154, 'Nanette', 'Cambrault', 'NCAMBRAU', '011.44.1344.987668', TO_DATE('09-DEZ-1998', 'dd-MON-yyyy') 
, 'SA_REP', 7500.00, .2, 145, 80); 

INSERT INTO tb_empregado  
VALUES  
( 155, 'Oliver', 'Tuvault', 'OTUVAULT', '011.44.1344.486508', TO_DATE('23-NOV-1999', 'dd-MON-yyyy') 
, 'SA_REP', 7000.00, .15, 145, 80); 

INSERT INTO tb_empregado  
VALUES  
( 156, 'Janette', 'King', 'JKING', '011.44.1345.429268', TO_DATE('30-JAN-1996', 'dd-MON-yyyy') 
, 'SA_REP', 10000.00, .35, 146, 80); 

INSERT INTO tb_empregado  
VALUES  
( 157, 'Patrick', 'Sully', 'PSULLY', '011.44.1345.929268', TO_DATE('04-MAR-1996', 'dd-MON-yyyy') 
, 'SA_REP', 9500.00, .35, 146, 80); 

INSERT INTO tb_empregado  
VALUES  
( 158, 'Allan', 'McEwen', 'AMCEWEN', '011.44.1345.829268', TO_DATE('01-AGO-1996', 'dd-MON-yyyy') 
, 'SA_REP', 9000.00, .35, 146, 80); 

INSERT INTO tb_empregado  
VALUES  
( 159, 'Lindsey', 'Smith', 'LSMITH', '011.44.1345.729268', TO_DATE('10-MAR-1997', 'dd-MON-yyyy') 
, 'SA_REP', 8000.00, .3, 146, 80); 

INSERT INTO tb_empregado  
VALUES  
( 160, 'Louise', 'Doran', 'LDORAN', '011.44.1345.629268', TO_DATE('15-DEZ-1997', 'dd-MON-yyyy') 
, 'SA_REP', 7500.00, .3, 146, 80); 

INSERT INTO tb_empregado  
VALUES  
( 161, 'Sarath', 'Sewall', 'SSEWALL', '011.44.1345.529268', TO_DATE('03-NOV-1998', 'dd-MON-yyyy') 
, 'SA_REP', 7000.00, .25, 146, 80); 

INSERT INTO tb_empregado  
VALUES  
( 162, 'Clara', 'Vishney', 'CVISHNEY', '011.44.1346.129268', TO_DATE('11-NOV-1997', 'dd-MON-yyyy') 
, 'SA_REP', 10500.00, .25, 147, 80); 

INSERT INTO tb_empregado  
VALUES  
( 163, 'Danielle', 'Greene', 'DGREENE', '011.44.1346.229268', TO_DATE('19-MAR-1999', 'dd-MON-yyyy') 
, 'SA_REP', 9500.00, .15, 147, 80); 

INSERT INTO tb_empregado  
VALUES  
( 164, 'Mattea', 'Marvins', 'MMARVINS', '011.44.1346.329268', TO_DATE('24-JAN-2000', 'dd-MON-yyyy') 
, 'SA_REP', 7200.00, .10, 147, 80);

INSERT INTO tb_empregado  
VALUES  
( 165, 'David', 'Lee', 'DLEE', '011.44.1346.529268', TO_DATE('23-FEV-2000', 'dd-MON-yyyy') 
, 'SA_REP', 6800.00, .1, 147, 80); 

INSERT INTO tb_empregado  
VALUES  
( 166, 'Sundar', 'Ande', 'SANDE', '011.44.1346.629268', TO_DATE('24-MAR-2000', 'dd-MON-yyyy') 
, 'SA_REP', 6400.00, .10, 147, 80); 

INSERT INTO tb_empregado  
VALUES  
( 167, 'Amit', 'Banda', 'ABANDA', '011.44.1346.729268', TO_DATE('21-ABR-2000', 'dd-MON-yyyy') 
, 'SA_REP', 6200.00, .10, 147, 80); 

INSERT INTO tb_empregado  
VALUES  
( 168, 'Lisa', 'Ozer', 'LOZER', '011.44.1343.929268', TO_DATE('11-MAR-1997', 'dd-MON-yyyy') 
, 'SA_REP', 11500.00, .25, 148, 80); 

INSERT INTO tb_empregado  
VALUES  
( 169, 'Harrison', 'Bloom', 'HBLOOM', '011.44.1343.829268', TO_DATE('23-MAR-1998', 'dd-MON-yyyy') 
, 'SA_REP', 10000.00, .20, 148, 80); 

INSERT INTO tb_empregado  
VALUES  
( 170, 'Tayler', 'Fox', 'TFOX', '011.44.1343.729268', TO_DATE('24-JAN-1998', 'dd-MON-yyyy') 
, 'SA_REP', 9600.00, .20, 148, 80); 

INSERT INTO tb_empregado  
VALUES  
( 171, 'William', 'Smith', 'WSMITH', '011.44.1343.629268', TO_DATE('23-FEV-1999', 'dd-MON-yyyy') 
, 'SA_REP', 7400.00, .15, 148, 80); 

INSERT INTO tb_empregado  
VALUES  
( 172, 'Elizabeth', 'Bates', 'EBATES', '011.44.1343.529268', TO_DATE('24-MAR-1999', 'dd-MON-yyyy') 
, 'SA_REP', 7300.00, .15, 148, 80); 

INSERT INTO tb_empregado  
VALUES  
( 173, 'Sundita', 'Kumar', 'SKUMAR', '011.44.1343.329268', TO_DATE('21-ABR-2000', 'dd-MON-yyyy') 
, 'SA_REP', 6100.00, .10, 148, 80); 

INSERT INTO tb_empregado  
VALUES  
( 174, 'Ellen', 'Abel', 'EABEL', '011.44.1644.429267', TO_DATE('11-MAI-1996', 'dd-MON-yyyy') 
, 'SA_REP', 11000.00, .30, 149, 80);

INSERT INTO tb_empregado  
VALUES  
( 175, 'Alyssa', 'Hutton', 'AHUTTON', '011.44.1644.429266', TO_DATE('19-MAR-1997', 'dd-MON-yyyy') 
, 'SA_REP', 8800.00, .25, 149, 80); 

INSERT INTO tb_empregado  
VALUES  
( 176, 'Jonathon', 'Taylor', 'JTAYLOR', '011.44.1644.429265', TO_DATE('24-MAR-1998', 'dd-MON-yyyy') 
, 'SA_REP', 8600.00, .20, 149, 80); 

INSERT INTO tb_empregado  
VALUES  
( 177, 'Jack', 'Livingston', 'JLIVINGS', '011.44.1644.429264', TO_DATE('23-ABR-1998', 'dd-MON-yyyy') 
, 'SA_REP', 8400.00, .20, 149, 80); 

INSERT INTO tb_empregado  
VALUES  
( 178, 'Kimberely', 'Grant', 'KGRANT', '011.44.1644.429263', TO_DATE('24-MAI-1999', 'dd-MON-yyyy') 
, 'SA_REP', 7000.00, .15, 149, NULL); 

INSERT INTO tb_empregado  
VALUES  
( 179, 'Charles', 'Johnson', 'CJOHNSON', '011.44.1644.429262', TO_DATE('04-JAN-2000', 'dd-MON-yyyy') 
, 'SA_REP', 6200.00, .10, 149, 80); 

INSERT INTO tb_empregado  
VALUES  
( 180, 'Winston', 'Taylor', 'WTAYLOR', '650.507.9876', TO_DATE('24-JAN-1998', 'dd-MON-yyyy') 
, 'SH_CLERK', 3200.00, NULL, 120, 50); 

INSERT INTO tb_empregado  
VALUES  
( 181, 'Jean', 'Fleaur', 'JFLEAUR', '650.507.9877', TO_DATE('23-FEV-1998', 'dd-MON-yyyy') 
, 'SH_CLERK', 3100.00, NULL, 120, 50); 

INSERT INTO tb_empregado  
VALUES  
( 182, 'Martha', 'Sullivan', 'MSULLIVA', '650.507.9878', TO_DATE('21-JUN-1999', 'dd-MON-yyyy') 
, 'SH_CLERK', 2500.00, NULL, 120, 50); 

INSERT INTO tb_empregado  
VALUES  
( 183, 'Girard', 'Geoni', 'GGEONI', '650.507.9879', TO_DATE('03-FEV-2000', 'dd-MON-yyyy') 
, 'SH_CLERK', 2800.00, NULL, 120, 50); 

INSERT INTO tb_empregado  
VALUES  
( 184, 'Nandita', 'Sarchand', 'NSARCHAN', '650.509.1876', TO_DATE('27-JAN-1996', 'dd-MON-yyyy') 
, 'SH_CLERK', 4200.00, NULL, 121, 50);

INSERT INTO tb_empregado  
VALUES  
( 185, 'Alexis', 'Bull', 'ABULL', '650.509.2876', TO_DATE('20-FEV-1997', 'dd-MON-yyyy') 
, 'SH_CLERK', 4100.00, NULL, 121, 50); 

INSERT INTO tb_empregado  
VALUES  
( 186, 'Julia', 'Dellinger', 'JDELLING', '650.509.3876', TO_DATE('24-JUN-1998', 'dd-MON-yyyy') 
, 'SH_CLERK', 3400.00, NULL, 121, 50); 

INSERT INTO tb_empregado  
VALUES  
( 187, 'Anthony', 'Cabrio', 'ACABRIO', '650.509.4876', TO_DATE('07-FEV-1999', 'dd-MON-yyyy') 
, 'SH_CLERK', 3000.00, NULL, 121, 50); 

INSERT INTO tb_empregado  
VALUES  
( 188, 'Kelly', 'Chung', 'KCHUNG', '650.505.1876', TO_DATE('14-JUN-1997', 'dd-MON-yyyy') 
, 'SH_CLERK', 3800.00, NULL, 122, 50); 

INSERT INTO tb_empregado  
VALUES  
( 189, 'Jennifer', 'Dilly', 'JDILLY', '650.505.2876', TO_DATE('13-AGO-1997', 'dd-MON-yyyy') 
, 'SH_CLERK', 3600.00, NULL, 122, 50); 

INSERT INTO tb_empregado  
VALUES  
( 190, 'Timothy', 'Gates', 'TGATES', '650.505.3876', TO_DATE('11-JUL-1998', 'dd-MON-yyyy') 
, 'SH_CLERK', 2900.00, NULL, 122, 50); 

INSERT INTO tb_empregado  
VALUES  
( 191, 'Randall', 'Perkins', 'RPERKINS', '650.505.4876', TO_DATE('19-DEZ-1999', 'dd-MON-yyyy') 
, 'SH_CLERK', 2500.00, NULL, 122, 50); 

INSERT INTO tb_empregado  
VALUES  
( 192, 'Sarah', 'Bell', 'SBELL', '650.501.1876', TO_DATE('04-FEV-1996', 'dd-MON-yyyy') 
, 'SH_CLERK', 4000.00, NULL, 123, 50); 

INSERT INTO tb_empregado  
VALUES  
( 193, 'Britney', 'Everett', 'BEVERETT', '650.501.2876', TO_DATE('03-MAR-1997', 'dd-MON-yyyy') 
, 'SH_CLERK', 3900.00, NULL, 123, 50); 

INSERT INTO tb_empregado  
VALUES  
( 194, 'Samuel', 'McCain', 'SMCCAIN', '650.501.3876', TO_DATE('01-JUL-1998', 'dd-MON-yyyy') 
, 'SH_CLERK', 3200.00, NULL, 123, 50);

INSERT INTO tb_empregado  
VALUES  
( 195, 'Vance', 'Jones', 'VJONES', '650.501.4876', TO_DATE('17-MAR-1999', 'dd-MON-yyyy') 
, 'SH_CLERK', 2800.00, NULL, 123, 50); 

INSERT INTO tb_empregado  
VALUES  
( 196, 'Alana', 'Walsh', 'AWALSH', '650.507.9811', TO_DATE('24-ABR-1998', 'dd-MON-yyyy') 
, 'SH_CLERK', 3100.00, NULL, 124, 50); 

INSERT INTO tb_empregado  
VALUES  
( 197, 'Kevin', 'Feeney', 'KFEENEY', '650.507.9822', TO_DATE('23-MAI-1998', 'dd-MON-yyyy') 
, 'SH_CLERK', 3000.00, NULL, 124, 50); 

INSERT INTO tb_empregado  
VALUES  
( 198, 'Donald', 'OConnell', 'DOCONNEL', '650.507.9833', TO_DATE('21-JUN-1999', 'dd-MON-yyyy') 
, 'SH_CLERK', 2600.00, NULL, 124, 50); 

INSERT INTO tb_empregado  
VALUES  
( 199, 'Douglas', 'Grant', 'DGRANT', '650.507.9844', TO_DATE('13-JAN-2000', 'dd-MON-yyyy') 
, 'SH_CLERK', 2600.00, NULL, 124, 50); 

INSERT INTO tb_empregado  
VALUES  
( 200, 'Jennifer', 'Whalen', 'JWHALEN', '515.123.4444', TO_DATE('17-SET-1987', 'dd-MON-yyyy') 
, 'AD_ASST', 4400.00, NULL, 101, 10); 

INSERT INTO tb_empregado  
VALUES  
( 201, 'Michael', 'Hartstein', 'MHARTSTE', '515.123.5555', TO_DATE('17-FEV-1996', 'dd-MON-yyyy') 
, 'MK_MAN', 13000.00, NULL, 100, 20); 

INSERT INTO tb_empregado  
VALUES  
( 202, 'Pat', 'Fay', 'PFAY', '603.123.6666', TO_DATE('17-AGO-1997', 'dd-MON-yyyy') 
, 'MK_REP', 6000.00, NULL, 201, 20); 

INSERT INTO tb_empregado  
VALUES  
( 203, 'Susan', 'Mavris', 'SMAVRIS', '515.123.7777', TO_DATE('07-JUN-1994', 'dd-MON-yyyy') 
, 'HR_REP', 6500.00, NULL, 101, 40); 

INSERT INTO tb_empregado  
VALUES  
( 204, 'Hermann', 'Baer', 'HBAER', '515.123.8888', TO_DATE('07-JUN-1994', 'dd-MON-yyyy') 
, 'PR_REP', 10000.00, NULL, 101, 70); 

INSERT INTO tb_empregado  
VALUES  
( 205, 'Shelley', 'Higgins', 'SHIGGINS', '515.123.8080', TO_DATE('07-JUN-1994', 'dd-MON-yyyy') 
, 'AC_MGR', 12000.00, NULL, 101, 110); 

INSERT INTO tb_empregado  
VALUES  
( 206, 'William', 'Gietz', 'WGIETZ', '515.123.8181', TO_DATE('07-JUN-1994', 'dd-MON-yyyy') 
, 'AC_ACCOUNT', 8300.00, NULL, 205, 110);

--VERIFICANDO OS DADOS DA TABELA
SELECT *
FROM tb_empregado;

--INSERINDO DADOS NA TABELA tb_historico_funcao
INSERT INTO tb_historico_funcao 
VALUES (102 
, TO_DATE('13-JAN-1993', 'dd-MON-yyyy') 
, TO_DATE('24-JUL-1998', 'dd-MON-yyyy') 
, 'IT_PROG' 
, 60); 

INSERT INTO tb_historico_funcao 
VALUES (101 
, TO_DATE('21-SET-1989', 'dd-MON-yyyy') 
, TO_DATE('27-OUT-1993', 'dd-MON-yyyy') 
, 'AC_ACCOUNT' 
, 110); 

INSERT INTO tb_historico_funcao 
VALUES (101 
, TO_DATE('28-OUT-1993', 'dd-MON-yyyy') 
, TO_DATE('15-MAR-1997', 'dd-MON-yyyy') 
, 'AC_MGR' 
, 110); 

INSERT INTO tb_historico_funcao 
VALUES (201 
, TO_DATE('17-FEV-1996', 'dd-MON-yyyy') 
, TO_DATE('19-DEZ-1999', 'dd-MON-yyyy') 
, 'MK_REP' 
, 20); 

INSERT INTO tb_historico_funcao 
VALUES  (114 
, TO_DATE('24-MAR-1998', 'dd-MON-yyyy') 
, TO_DATE('31-DEZ-1999', 'dd-MON-yyyy') 
, 'ST_CLERK' 
, 50);

INSERT INTO tb_historico_funcao 
VALUES  (122 
, TO_DATE('01-JAN-1999', 'dd-MON-yyyy') 
, TO_DATE('31-DEZ-1999', 'dd-MON-yyyy') 
, 'ST_CLERK' 
, 50 
); 

INSERT INTO tb_historico_funcao 
VALUES  (200 
, TO_DATE('17-SET-1987', 'dd-MON-yyyy') 
, TO_DATE('17-JUN-1993', 'dd-MON-yyyy') 
, 'AD_ASST' 
, 90 
); 

INSERT INTO tb_historico_funcao 
VALUES  (176 
, TO_DATE('24-MAR-1998', 'dd-MON-yyyy') 
, TO_DATE('31-DEZ-1998', 'dd-MON-yyyy') 
, 'SA_REP' 
, 80 
); 

INSERT INTO tb_historico_funcao 
VALUES  (176 
, TO_DATE('01-JAN-1999', 'dd-MON-yyyy') 
, TO_DATE('31-DEZ-1999', 'dd-MON-yyyy') 
, 'SA_MAN' 
, 80 
); 

INSERT INTO tb_historico_funcao 
VALUES  (200 
, TO_DATE('01-JUL-1994', 'dd-MON-yyyy') 
, TO_DATE('31-DEZ-1998', 'dd-MON-yyyy') 
, 'AC_ACCOUNT' 
, 90);

--VERIICANDO OS DADOS DA TABELA
SELECT * 
FROM tb_historico_funcao;

--HABILITANDO A RESTRIÇÃO DE INTEGRIDADE PARA A TABELA "tb_departamento"
ALTER TABLE tb_departamento
    ENABLE CONSTRAINT fk_gerente_depto;
    
--SALVANDO 
COMMIT;


--/////////////////////////////////// E X E R C I C I O S ///////////////////////////////////
--Exercicio 01
--Elabore uma consulta para exibir o nome do empregado e o valor da comissão. Caso o empregado não 
--tenha comissão, exibir o string Nenhuma comissão. Insira um label COMISSÃO para a coluna resultante. 
SELECT nome, NVL(TO_CHAR(percentual_comissao), 'Nenhuma Comissão') COMISSÃO
FROM tb_empregado;


--Exercicio 02
--Elabore uma consulta para exibir os nomes e as datas de admissão de todos os empregados junto com 
--o nome do gerente e a data de admissão de todos os empregados admitidos antes dos respectivos 
--gerentes. Insira um label Empregado, Empregado Data Admissão, Gerente e Gerente Data Admissão, 
--nas respectivas colunas.
SELECT e.nome "Funcionario", e.data_admissao "Funcionario Data Admissão", m.nome "Gerente", m.data_admissao "Gerente Data Admissão"
FROM tb_empregado e, tb_empregado m
WHERE e.id_gerente = m.id_empregado
AND e.data_admissao < m.data_admissao;


--Exercicio 03
--Elabore uma consulta para exibir o maior salário, o salário médio, o menor salário e a soma de todos os 
--salários de todos os empregados. Insira um label Máximo, Mínimo, Média e Somatório nas respectivas 
--colunas. Realize o arredondamento dos resultados para o número inteiro mais próximo. 
SELECT ROUND(MAX(salario), 0) "Máximo",
       ROUND(MIN(salario), 0) "Minimo", 
       ROUND(SUM(salario), 0) "Somatório",
       ROUND(AVG(salario), 0) "Média"
FROM tb_empregado;


--Exericio 04
--Elabore uma consulta para exibir o número do gerente e o salário do empregado com menor salário sob 
--a supervisão desse gerente. Desconsidere todos cujo gerente não seja conhecido. Desconsidere qualquer 
--grupo cujo salário-mínimo seja inferior a R$ 1.000,00. Ordene a saída de forma descendente pelo menor 
--salário. 
SELECT id_gerente, MIN(salario)
FROM tb_empregado
WHERE id_gerente IS NOT NULL
GROUP BY id_gerente
HAVING MIN(salario) > 1000
ORDER BY MIN(salario) DESC;


--Exercicio 05
--Elabore uma consulta responsável por exibir o número total de empregados e, desse total, o número 
--total de empregados contratados em 1990, 1991, 1992 e 1993. Insira os cabeçalhos apropriados nas 
--colunas. 
SELECT COUNT(*) total, SUM(DECODE(TO_CHAR(data_admissao, 'YYYY'), 1990, 1, 0)) "1990",
                       SUM(DECODE(TO_CHAR(data_admissao, 'YYYY'), 1991, 1, 0)) "1991",
                       SUM(DECODE(TO_CHAR(data_admissao, 'YYYY'), 1992, 1, 0)) "1992",
                       SUM(DECODE(TO_CHAR(data_admissao, 'YYYY'), 1993, 1, 0)) "1993"
FROM tb_empregado;


--Exercicio 06
--Elabore uma consulta para exibir os nomes dos empregados e indique o valor dos salários por meio de 
--asteriscos. Cada asterisco representa mil reais. Classifique as tuplas resultantes de forma descendente 
--pelo salário. Insira um label Funcionários e seus Salários para a coluna resultante. 
SELECT RPAD(nome, 8) || ' ' || RPAD(' ', salario/1000 + 1, '*') FUNCIONARIOS_E_SEUS_SALARIOS
FROM tb_empregado
ORDER BY salario DESC;


--Exercicio 07
--Elabore uma consulta para exibir todos os atributos da tb_empregado. Separe cada atributo por uma 
--vírgula. Identifique a coluna resultante como Saída.
SELECT id_empregado || ',' || nome || ',' || id_funcao || ',' || id_gerente || ',' || data_admissao 
                    || ',' || salario || ',' || percentual_comissao || ',' || id_departamento SAIDA
FROM tb_empregado;


--Exercicio 08
--Elabore uma consulta cuja finalidade é exibir a classe de todos os empregados com base no valor da 
--coluna id_funcao, de acordo com a tabela apresentada abaixo:
-----------------------------------------------
--|Descrição da Função            | Grade     |
-----------------------------------------------
--|SH_CLERK                       | A         |
--|ST_MAN                         | B         |
--|AC_ACCOUNT                     | C         |
--|AC_MGR                         | D         |
--|IT_PROG                        | E         |
--|Nenhuma das alternativas acima | 0 (zero)  |
-----------------------------------------------
SELECT id_funcao, DECODE(id_funcao, 'IT_PROG', 'E',
                                    'AC_MGR', 'D',
                                    'AC_ACCOUNT', 'C',
                                    'ST_MAN', 'B',
                                    'SH_CLERK', 'A',
                                    '0') GRADE
FROM tb_empregado;


--Exercicio 09
--Elabore uma consulta para exibir o nome de cada empregado e calcule o número de meses entre a data 
--atual e a data em que o empregado foi admitido. Coloque um label Meses Trabalhado para a coluna 
--resultante. Ordene as tuplas resultantes pelo número de meses desde a data de admissão. 
SELECT nome, MONTHS_BETWEEN(SYSDATE, data_admissao) MESES_TRABALHADO
FROM tb_empregado
ORDER BY MONTHS_BETWEEN(SYSDATE, data_admissao);


--Exercicio 10
--Elabore uma consulta para exibir o nome do empregado, o nome do departamento e a localização 
--(cidade e estado) de todos os empregados que recebem comissão. 
SELECT e.nome, d.nm_departamento, l.cidade, l.estado
FROM tb_empregado e, tb_departamento d, tb_localizacao l
WHERE e.id_departamento = d.id_departamento
AND d.id_localizacao = l.id_localizacao
AND e.percentual_comissao IS NOT NULL;


--Exercicio 11
--Você deseja conceder a Joao o privilégio de atualizar os dados na tb_departamento. Você também quer 
--permitir que Joao conceda esse privilégio a outros usuários. Que comando você utilizaria?
GRANT UPDATE ON tb_departamento TO joao WITH GRANT OPTION;


--Exercicio 12
-- Crie a tabela nomeada de tb_departamento_2 com base na descrição abaixo. Confirme se a tabela foi 
--criada corretamente demonstrando sua estrutura. 
-------------------------------------------
--|Column Name     | ID        | NM_DEPTO |
--|Key Type        |           |          |
--|Nulls/Unique    |           |          |
--|FK Table        |           |          |
--|FK Column       |           |          |
--|Data Type       | NUMBER    | VARCHAR2 |
--|Length          | 7         | 25       |
-------------------------------------------
CREATE TABLE tb_departamento_2(
id          NUMBER(7),
nm_depto    VARCHAR(25));

DESCRIBE tb_departamento_2;

-- a. Insira tuplas na tb_departamento_2 com os dados da tb_departamento. Inclua apenas as 
--    colunas necessárias. 
INSERT INTO tb_departamento_2
SELECT id_departamento, nm_departamento
FROM tb_departamento;

-- b. Acrescente um comentário na tb_departamento_2. Em seguida, consulte o dicionário de dados 
--    (catálogo) responsável pelo armazenamento, verificando se o comentário se encontra presente.  
COMMENT ON TABLE tb_departamento_2 IS 'Company departament information including name, code, and location.';

SELECT comments
FROM user_tab_comments
WHERE table_name = 'TB_DEPARTAMENTO_2';


--Exercicio 13
--Crie a tabela nomeada de tb_empregado_2 com base na estrutura abaixo. Confirme se a tabela foi 
--criada apresentando sua estrutura. 
----------------------------------------------------------------
--|Column Name   | ID      | SOBRENOME  | NOME      | ID_DEPTO |
--|Key Type      |         |            |           |          |
--|Nulls/Unique  |         |            |           |          |
--|FK Table      |         |            |           |          | 
--|FK Column     |         |            |           |          | 
--|Data Type     | NUMBER  | VARCHAR2   | VARCHAR2  | NUMBER   |
--|Length        | 7       | 25         | 25        | 7        |
----------------------------------------------------------------
CREATE TABLE tb_empregado_2(
id          NUMBER(7),
sobrenome   VARCHAR2(25),
nome        VARCHAR2(25),
id_depto    NUMBER(7));

DESCRIBE tb_empregado_2;

-- a. Modifique a tb_empregado_2 para permitir a inclusão de sobrenomes maiores. Confirme a 
--    sua modificação apresentando a estrutura da tabela.
ALTER TABLE tb_empregado_2
MODIFY (sobrenome VARCHAR2(50));

DESCRIBE tb_empregado_2;

-- b. Adicione na tb_empregado_2 uma restrição de chave primária na coluna ID. A restrição deve 
--    ser nomeada na sua criação como pk_emp_id. 
ALTER TABLE tb_empregado_2
ADD CONSTRAINT pk_emp_id PRIMARY KEY(id);

-- c. Adicione uma referência de chave estrangeira na tb_empregado_2 que garanta que o 
--    empregado não seja atribuído a um departamento inexistente. Nomeie a restrição de 
--    fk_emp_dept_id.
ALTER TABLE tb_empregado_2
ADD CONSTRAINT fk_emp_dept_id
FOREIGN KEY(id_depto) REFERENCES tb_departamento(id_departamento);


--Exercicio 14
--Crie a tabela intitulada tb_empregado_3 com base na estrutura da tabela tb_empregado. Inclua apenas 
--as colunas id_empregado, nome, sobrenome, salario e id_departamento. Nomeie as colunas em sua 
--nova tabela como ID, FIRST_NAME, LAST_NAME, SALARY e DEPT_ID, respectivamente. 
CREATE TABLE tb_empregado_3 AS
SELECT id_empregado id, nome first_name, sobrenome last_name, salario salary, id_departamento dept_id
FROM tb_empregado;

-- a. Remova a coluna FIRST_NAME da tb_empregado_3. Confirmar a remoção da coluna 
--    apresentando a estrutura atual da tabela.
ALTER TABLE tb_empregado_3 
DROP COLUMN first_name;

DESCRIBE tb_empregado_3;


--Exercicio 15
--Exibir o número do empregado, o nome, o salário e o aumento salarial de 15%, esse expresso como 
--inteiro. Adicione um label na coluna resultante como Novo Salário.
SELECT id_empregado, nome, salario,
       ROUND(salario * 1.15, 0) "Novo Salário"
FROM tb_empregado;


--Exercicio 16
--Exibir o nome do empregado, a data de admissão e a data de revisão do salário, que corresponde a 
--primeira segunda-feira após seis meses de trabalho. Coloque um label Revisão para a coluna. 
SELECT nome, data_admissao, TO_CHAR(NEXT_DAY(ADD_MONTHS(data_admissao, 6), 'SEGUNDA'), 'DD/MM/YYYY') Revisão
FROM tb_empregado;

SELECT nome, data_admissao, TO_CHAR(NEXT_DAY(ADD_MONTHS(data_admissao, 6), 2), 'DD/MM/YYYY') Revisão
FROM tb_empregado;


--Exercicio 17
--Elabore uma consulta para exibir o nome do empregado com a primeira letra em maiúsculo e todas as 
--outras em minúsculos, além do tamanho do nome, para todos os empregados cujo nome inicia-se pelos 
--caracteres J, A ou M. Forneça um label apropriado para cada coluna. 
SELECT INITCAP(nome) "Nome",
       LENGTH(nome) "Comprimento"
FROM tb_empregado
WHERE nome LIKE 'J%'
OR nome LIKE 'M%'
OR nome LIKE 'A%';


--Exercicio 18
--Elabore uma consulta responsável por substituir o string SH para SHIPPING da coluna id_funcao 
--presenta na tb_empregado, para todos as funções que iniciam com o string SH. 
SELECT id_empregado, REPLACE(id_funcao, 'SH', 'SHIPPING')
FROM tb_empregado
WHERE SUBSTR(id_funcao, 1, 2) = 'SH';


--Exercicio 19
--Elabore uma consulta para exibir o id_departamento, o menor e o maior salário, onde os menores 
--salários sejam inferiores a R$ 7.000,00. Ordene as tuplas resultantes pelos menores salários.
SELECT id_departamento, MIN(salario), MAX(salario)
FROM tb_empregado
GROUP BY id_departamento
HAVING MIN(salario) < 7000
ORDER BY MIN(salario);
 
 
--Exercicio 20
--Crie um índice composto para as colunas id_empregado e id_gerente, essas existentes na 
--tb_empregado. Na sequência, remova o índice com a instrução adequada. 
CREATE INDEX idx_emp_mgr_id
    ON tb_empregado(id_empregado, id_gerente);
    
DROP INDEX idx_emp_mgr_id;
