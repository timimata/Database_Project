--1.
CREATE DATABASE clinica;

CREATE SCHEMA consultamedica;

CREATE TABLE consultamedica.gabinete(
    id_gabinete INT PRIMARY KEY,
    descricao VARCHAR(2000)
);

CREATE TABLE consultamedica.tipo_seguro(
    id_tipo_seguro VARCHAR(10) PRIMARY KEY,
    descricao VARCHAR(1000)
);

CREATE TABLE consultamedica.especialidade_medico(
   id_especialidade INT,
   id_medico INT
);

CREATE TABLE consultamedica.especialidade(
  id_especialidade INT PRIMARY KEY,
  nome VARCHAR(100),
  descricao VARCHAR(2000)
);

CREATE TABLE consultamedica.anotacoes_consulta(
  id_anotacao INT,
  anotacao VARCHAR(2000),
  id_consulta INT
);

CREATE TABLE consultamedica.tipo_exame_medico(
  id_tipo_exame_medico INT,
  descricao VARCHAR(200)
);

--1.2
CREATE TABLE consultamedica.medico (
    id_medico INT PRIMARY KEY,
    nome VARCHAR(200),
    data_nascimento DATE,
    telemovel VARCHAR(15),
    cedula_profissional VARCHAR(15),
    observacoes VARCHAR(2000) NULL,
    
    -- Restrição de chave única no número de telemóvel
    CONSTRAINT UK_Telemovel UNIQUE (telemovel),
    
    -- Restrição de chave única na cédula profissional
    CONSTRAINT UK_CedulaProfissional UNIQUE (cedula_profissional)
);

--1.3
CREATE TABLE consultamedica.horario_base (
    id_medico INT,
    dia_semana VARCHAR(15),
    hora_inicio INT,
    hora_fim INT,
    duracao_consulta INT,

      -- Restrições para garantir que as horas estejam dentro do intervalo
    CONSTRAINT CK_HoraInicio2 CHECK (hora_inicio >= 0 AND hora_inicio <= 2359),
    CONSTRAINT CK_HoraFim2 CHECK (hora_fim >= 0 AND hora_fim <= 2359),
 
);

--1.5 ; 1.4; 1.7 ; 1.8
CREATE TABLE consultamedica.consulta (
    id_consulta INT PRIMARY KEY,
    id_medico INT,
    id_gabinete INT,
    dia DATE,
    hora_inicio INT,
    hora_fim INT,
    id_utente INT NULL, -- Definindo como NULL para permitir valores nulos
    
    -- Restrição para impedir valores repetidos na combinação especificada
    CONSTRAINT UK_Consulta_Unica 
        UNIQUE (id_medico, id_gabinete, dia, hora_inicio),
    
    -- Restrições para garantir que as horas estejam dentro do intervalo
    CONSTRAINT CK_HoraInicio CHECK (hora_inicio >= 0 AND hora_inicio <= 2359),
    CONSTRAINT CK_HoraFim CHECK (hora_fim >= 0 AND hora_fim <= 2359),
    
    -- Restrição para garantir que hora_inicio seja menor que hora_fim com diferença entre 5 e 90 minutos
    CONSTRAINT CK_DiferencaHoras CHECK (hora_inicio < hora_fim AND hora_fim - hora_inicio BETWEEN 5 AND 120)
);

--1.8
CREATE TABLE consultamedica.exame_medico(
    id_exame_medico INT,
    id_consulta INT PRIMARY KEY,
    id_tipo_exame_medico INT NULL,
    data_exame DATE,
    relatorio VARCHAR(2000),
    imagem VARCHAR(500) Null
);

--1.9;1.8
CREATE TABLE consultamedica.utente (
    id_utente INT PRIMARY KEY,
    nome VARCHAR(200),
    morada VARCHAR(200),
    codigo_postal VARCHAR(100),
    telefone VARCHAR(15),
    id_seguro VARCHAR(30) UNIQUE NULL,
    id_tipo_seguro VARCHAR(10)  NULL,
    
    -- Restrição para permitir NULL na coluna id_seguro
    CONSTRAINT CK_IdSeguro CHECK (id_seguro IS NULL OR id_seguro <> ''),
    
    -- Restrição para garantir que a coluna id_seguro não tenha valores repetidos
    CONSTRAINT UK_IdSeguro UNIQUE (id_seguro)
);

--1.10
-- Inserir 3 utentes que não moram na Av. de Madrid Lote 45
INSERT INTO consultamedica.utente (id_utente, nome, morada, codigo_postal, telefone, id_seguro, id_tipo_seguro)
VALUES
    (1, 'Utente1', 'Rua A', '12345', '123456789', 'TS1', 'Tipo1'),
    (2, 'Utente2', 'Rua B', '23456', '987654321', 'TS2', 'Tipo2'),
    (3, 'Utente3', 'Rua C', '34567', '456789012', 'TS3', 'Tipo3');

-- Inserir 2 utentes que moram na Av. de Madrid Lote 45
INSERT INTO consultamedica.utente (id_utente, nome, morada, codigo_postal, telefone, id_seguro, id_tipo_seguro)
VALUES
    (4, 'Utente4', 'Av. de Madrid Lote 45, Andar 1', '45678', '789012345', 'TS4', 'Tipo4'),
    (5, 'Utente5', 'Av. de Madrid Lote 45, Andar 2', '56789', '012345678', 'TS5', 'Tipo5');

--2.
-- Inserir 5 médicos com valores aleatórios
INSERT INTO consultamedica.medico (id_medico, nome, data_nascimento, telemovel, cedula_profissional, observacoes)
VALUES
    (1, 'Dr. Silva', '1980-05-15', '987654321', 'MP12345', 'Observacao1'),
    (2, 'Dra. Santos', '1975-09-22', '123456789', 'MP54321', 'Observacao2'),
    (3, 'Dr. Oliveira', '1990-03-10', '876543210', 'MP67890', 'Observacao3'),
    (4, 'Dra. Pereira', '1988-12-05', '234567890', 'MP09876', NULL),
    (5, 'Dr. Costa', '1985-07-18', '345678901', 'MP45678', 'Observacao5');

--3.
-- Inserir 5 especialidades com valores aleatórios
INSERT INTO consultamedica.especialidade (id_especialidade, nome, descricao)
VALUES
    (1, 'Cardiologia', 'Tratamento de doenças do coração.'),
    (2, 'Ortopedia', 'Diagnóstico e tratamento de problemas musculoesqueléticos.'),
    (3, 'Dermatologia', 'Tratamento de doenças da pele.'),
    (4, 'Ginecologia', 'Especialidade médica que trata da saúde da mulher.'),
    (5, 'Neurologia', 'Estudo do sistema nervoso e tratamento de doenças neurológicas.');

--4.
-- Inserir 5 gabinetes com valores aleatórios
INSERT INTO consultamedica.gabinete (id_gabinete, descricao)
VALUES
    (1, 'Gabinete 1 - Primeiro Andar'),
    (2, 'Gabinete 2 - Segundo Andar'),
    (3, 'Gabinete 3 - Terceiro Andar'),
    (4, 'Gabinete 4 - Quarto Andar'),
    (5, 'Gabinete 5 - Quinto Andar');

--5.
-- Inserir 5 tipos de seguro com valores aleatórios
INSERT INTO consultamedica.tipo_seguro (id_tipo_seguro, descricao)
VALUES
    ('TS1', 'Seguro de Saúde Básico'),
    ('TS2', 'Seguro Dentário'),
    ('TS3', 'Seguro de Vida'),
    ('TS4', 'Seguro de Proteses'),
    ('TS5', 'Seguro de Doenças Crônicas');

--6.
-- Inserir 5 exames médicos com valores aleatórios
INSERT INTO consultamedica.exame_medico (id_exame_medico, id_consulta, id_tipo_exame_medico, data_exame, relatorio, imagem)
VALUES
    (1, 1, 1, '2023-01-15', 'Relatório do Exame 1', '/caminho/para/imagem1.jpg'),
    (2, 2, 2, '2023-02-20', 'Relatório do Exame 2', '/caminho/para/imagem2.jpg'),
    (3, 3, 1, '2023-03-25', 'Relatório do Exame 3', NULL),
    (4, 4, NULL, '2023-04-30', 'Relatório do Exame 4', '/caminho/para/imagem4.jpg'),
    (5, 5, 3, '2023-05-10', 'Relatório do Exame 5', '/caminho/para/imagem5.jpg');
--7.
SELECT * FROM consultamedica.medico
SELECT * FROM consultamedica.especialidade
SELECT * FROM consultamedica.gabinete
SELECT * FROM consultamedica.tipo_seguro
SELECT * FROM consultamedica.exame_medico

--8.
SELECT id_seguro, COUNT(*)
FROM consultamedica.utente
GROUP BY id_seguro
HAVING COUNT(*) > 1;

SELECT telemovel, COUNT(*)
FROM consultamedica.medico
GROUP BY telemovel
HAVING COUNT(*) > 1;

SELECT cedula_profissional, COUNT(*)
FROM consultamedica.medico
GROUP BY cedula_profissional
HAVING COUNT(*) > 1;

--9.
UPDATE consultamedica.utente
SET morada = REPLACE(morada, 'Av. de Madrid Lote 45', 'Av. de Madrid, nº14')
WHERE morada LIKE 'Av. de Madrid Lote 45%';

--10.
-- Adicionando relação entre o horario_base e o medico
ALTER TABLE consultamedica.horario_base
ADD CONSTRAINT FK_Medico_Horario_base
FOREIGN KEY (id_medico)
REFERENCES consultamedica.medico(id_medico);

-- Adicionando relação entre consulta e medico
ALTER TABLE consultamedica.consulta
ADD CONSTRAINT FK_Medico_Consulta
FOREIGN KEY (id_medico)
REFERENCES consultamedica.medico(id_medico);

-- Adicionando relação entre consulta e gabinete
ALTER TABLE consultamedica.consulta
ADD CONSTRAINT FK_Gabinete_Consulta
FOREIGN KEY (id_gabinete)
REFERENCES consultamedica.gabinete(id_gabinete);

-- Adicionando relação entre consulta e utente
ALTER TABLE consultamedica.consulta
ADD CONSTRAINT FK_Utente_Consulta
FOREIGN KEY (id_utente)
REFERENCES consultamedica.utente(id_utente);

-- Adicionando relação entre medico e especialidade_medico
ALTER TABLE consultamedica.especialidade_medico
ADD CONSTRAINT FK_Medico_Consulta2
FOREIGN KEY (id_medico)
REFERENCES consultamedica.medico(id_medico);

-- Adicionando relação entre utente e tipo_seguro
ALTER TABLE consultamedica.utente
ADD CONSTRAINT FK_TipoSeguro_Utente
FOREIGN KEY (id_tipo_seguro)
REFERENCES consultamedica.tipo_seguro(id_tipo_seguro);

-- Adicionando relação entre exame_medico e consulta
ALTER TABLE consultamedica.exame_medico
ADD CONSTRAINT FK_Consulta_ExameMedico
FOREIGN KEY (id_consulta)
REFERENCES consultamedica.consulta(id_consulta);

-- Adicionando relação entre exame_medico e tipo_exame_medico 
ALTER TABLE consultamedica.exame_medico
ADD CONSTRAINT FK_TipoExameMedico_ExameMedico
FOREIGN KEY (id_tipo_exame_medico)
REFERENCES consultamedica.tipo_exame_medico(id_tipo_exame_medico);

ALTER TABLE consultamedica.especialidade_medico
ADD CONSTRAINT FK_EspecialidadeMedico_Especialidade
FOREIGN KEY (id_especialidade)
REFERENCES consultamedica.especialidade(id_especialidade);

--11.
--Visto que nao podia usar o ENUM no dia_semana e nao obtive resposta no forum quanto a pergunta tive de arranjar outro metodo.
-- Inserir horário base para o médico com id_medico = 3
INSERT INTO consultamedica.horario_base (id_medico, dia_semana, hora_inicio, hora_fim, duracao_consulta)
VALUES (3, 'SEG', 900, 1300, 30),
       (3, 'QUA', 1400, 1800, 30);

-- Inserir horário base para o médico com id_medico = 4
INSERT INTO consultamedica.horario_base (id_medico, dia_semana, hora_inicio, hora_fim, duracao_consulta)
VALUES (4, 'TER', 800, 1200, 30),
       (4, 'QUI', 1600, 2000, 30);

-- Inserir horário base para o médico com id_medico = 5
INSERT INTO consultamedica.horario_base (id_medico, dia_semana, hora_inicio, hora_fim, duracao_consulta)
VALUES (5, 'SEG', 1000, 1400, 30),
       (5, 'SEX', 1500, 1900, 30);

-- Inserir horário base para o médico com id_medico = 1
INSERT INTO consultamedica.horario_base (id_medico, dia_semana, hora_inicio, hora_fim, duracao_consulta)
VALUES (1, 'SEG', 800, 1200, 30),
       (1, 'QUI', 1400, 1800, 30);

-- Inserir horário base para o médico com id_medico = 2
INSERT INTO consultamedica.horario_base (id_medico, dia_semana, hora_inicio, hora_fim, duracao_consulta)
VALUES (2, 'TER', 900, 1300, 30),
       (2, 'SEX', 1600, 2000, 30);

-- Consulta para mostrar dados dos médicos e seus horários base
SELECT
    M.id_medico,
    M.nome AS nome_medico,
    HB.dia_semana,
    HB.hora_inicio,
    HB.hora_fim,
    HB.duracao_consulta
FROM
    consultamedica.medico M
JOIN
    consultamedica.horario_base HB ON M.id_medico = HB.id_medico
ORDER BY
    M.id_medico, HB.dia_semana;

--12.
INSERT INTO consultamedica.especialidade (id_especialidade, nome, descricao) VALUES
(101, 'Cardiologia', 'Tratamento do coração'),
(102, 'Ortopedia', 'Tratamento de problemas musculoesqueléticos'),
(103, 'Dermatologia', 'Tratamento da pele');


INSERT INTO consultamedica.especialidade_medico (id_especialidade,id_medico) VALUES
(1, 101), -- Dr. Smith - Cardiologia
(1, 102), -- Dr. Smith - Ortopedia
(2, 102), -- Dr. Johnson - Ortopedia
(3, 103); -- Dr. Brown - Dermatologia

-- Consulta para verificar médicos e suas especialidades
SELECT m.nome AS medico, e.nome AS especialidade
FROM consultamedica.medico m
JOIN consultamedica.especialidade_medico me ON m.id_medico = me.id_medico
JOIN consultamedica.especialidade e ON me.id_especialidade = e.id_especialidade;

--13.-- Consulta para listar gabinetes disponíveis para cada médico
SELECT
    m.id_medico,
    m.nome AS nome_medico,
    g.id_gabinete,
    g.descricao AS descricao_gabinete
FROM
    consultamedica.medico m
CROSS JOIN consultamedica.gabinete g
WHERE
    NOT EXISTS (
        SELECT 1
        FROM consultamedica.consulta c
        WHERE
            c.id_medico = m.id_medico
            AND c.id_gabinete = g.id_gabinete
    );

INSERT INTO consultamedica.consulta (id_consulta, id_medico, id_gabinete, dia, hora_inicio, hora_fim)
VALUES	(1, 1, 3, '2024-02-15', '0900', '0930'),
      	(2, 3, 2, '2024-02-11', '1000', '1010'),
        (3, 5, 1, '2024-02-12', '1400', '1500'),
        (4, 3, 4, '2024-02-13', '1600', '1700'),
        (5, 4, 2, '2024-02-14', '2000', '2100');
--14.
-- Atribuir utentes a todas as consultas, exceto uma
UPDATE consultamedica.consulta
SET id_utente = CASE
    WHEN id_consulta = 1 THEN NULL  -- Deixe uma consulta sem utente
    ELSE (SELECT TOP 1 id_utente FROM consultamedica.utente ORDER BY NEWID()) -- Atribuir um utente aleatório
END;

-- Consulta para mostrar as consultas com médicos e utentes
SELECT
    C.id_consulta,
    M.nome AS nome_medico,
    U.nome AS nome_utente,
    C.dia,
    C.hora_inicio,
    C.hora_fim
FROM
    consultamedica.consulta C
JOIN
    consultamedica.medico M ON C.id_medico = M.id_medico
LEFT JOIN
    consultamedica.utente U ON C.id_utente = U.id_utente;


--15.

-- Consulta 1
INSERT INTO consultamedica.anotacoes_consulta (id_anotacao, anotacao, id_consulta)
VALUES (1, 'Anotação para Consulta 1', 1);

INSERT INTO consultamedica.exame_medico (id_exame_medico, id_consulta, id_tipo_exame_medico, data_exame, relatorio, imagem)
VALUES (1, 1, 1, '2024-02-15', 'Relatório Exame Consulta 1', 'caminho_da_imagem1.jpg');

-- Consulta 2
INSERT INTO consultamedica.anotacoes_consulta (id_anotacao, anotacao, id_consulta)
VALUES (2, 'Anotação para Consulta 2', 2);

INSERT INTO consultamedica.exame_medico (id_exame_medico, id_consulta, id_tipo_exame_medico, data_exame, relatorio, imagem)
VALUES (2, 2, 2, '2024-02-11', 'Relatório Exame Consulta 2', 'caminho_da_imagem2.jpg');

-- Consulta 3
INSERT INTO consultamedica.anotacoes_consulta (id_anotacao, anotacao, id_consulta)
VALUES (3, 'Anotação para Consulta 3', 3);

INSERT INTO consultamedica.exame_medico (id_exame_medico, id_consulta, id_tipo_exame_medico, data_exame, relatorio, imagem)
VALUES (3, 3, 3, '2024-02-12', 'Relatório Exame Consulta 3', 'caminho_da_imagem3.jpg');

-- Consulta 4
INSERT INTO consultamedica.anotacoes_consulta (id_anotacao, anotacao, id_consulta)
VALUES (4, 'Anotação para Consulta 4', 4);

INSERT INTO consultamedica.exame_medico (id_exame_medico, id_consulta, id_tipo_exame_medico, data_exame, relatorio, imagem)
VALUES (4, 4, 4, '2024-02-13', 'Relatório Exame Consulta 4', 'caminho_da_imagem4.jpg');

-- Consulta 5
INSERT INTO consultamedica.anotacoes_consulta (id_anotacao, anotacao, id_consulta)
VALUES (5, 'Anotação para Consulta 5', 5);

INSERT INTO consultamedica.exame_medico (id_exame_medico, id_consulta, id_tipo_exame_medico, data_exame, relatorio, imagem)
VALUES (5, 5, 5, '2024-02-14', 'Relatório Exame Consulta 5', 'caminho_da_imagem5.jpg');


SELECT
    c.id_consulta,
    c.id_medico,
    c.id_gabinete,
    c.dia,
    c.hora_inicio,
    c.hora_fim,
    o.anotacao,
    em.id_tipo_exame_medico,
    em.data_exame,
    em.relatorio,
    em.imagem
FROM
    consultamedica.consulta c
LEFT JOIN consultamedica.anotacoes_consulta o ON c.id_consulta = o.id_consulta
LEFT JOIN consultamedica.exame_medico em ON c.id_consulta = em.id_consulta;


--16.
SELECT TOP 1
    id_medico,
    COUNT(*) AS total_consultas
FROM
    consultamedica.consulta
GROUP BY
    id_medico
ORDER BY
    total_consultas DESC;

--17.
-- Consulta para verificar consultas que não respeitam o horário base
SELECT
    C.id_consulta,
    M.nome AS nome_medico,
    C.dia,
    C.hora_inicio,
    C.hora_fim,
    HB.dia_semana,
    HB.hora_inicio AS horario_base_inicio,
    HB.hora_fim AS horario_base_fim
FROM
    consultamedica.consulta C
JOIN
    consultamedica.medico M ON C.id_medico = M.id_medico
JOIN
    consultamedica.horario_base HB ON C.id_medico = HB.id_medico AND C.dia_semana = HB.dia_semana
WHERE
    (C.hora_inicio < HB.hora_inicio OR C.hora_inicio > HB.hora_fim)
    OR (C.hora_fim < HB.hora_inicio OR C.hora_fim > HB.hora_fim);


--18
-- Criar a função para contar consultas por médico em um período de tempo
CREATE FUNCTION ContarConsultasPorMedico(
    @id_medico INT,
    @data_inicial DATE,
    @periodo_contagem INT
)
RETURNS INT
AS
BEGIN
    DECLARE @data_final DATE
    SET @data_final = DATEADD(DAY, @periodo_contagem, @data_inicial)

    RETURN (
        SELECT COUNT(*)
        FROM consultamedica.consulta
        WHERE id_medico = @id_medico
            AND dia BETWEEN @data_inicial AND @data_final
    )
END;

-- Contar consultas por médico nesta semana usando a função definida
SELECT
    id_medico,
    dbo.ContarConsultasPorMedico(id_medico, DATEADD(DAY, -DATEPART(WEEKDAY, GETDATE()) + 1, CAST(GETDATE() AS DATE)), 7) AS total_consultas
FROM
    consultamedica.consulta
GROUP BY
    id_medico
ORDER BY
    total_consultas DESC;

--19

-- Criar VIEW para consultas com médicos e utentes
CREATE VIEW consultamedica.ConsultasComUtentes AS
SELECT
    C.id_consulta,
    M.nome AS nome_medico,
    U.nome AS nome_utente,
    C.dia,
    C.hora_inicio,
    C.hora_fim
FROM
    consultamedica.consulta C
JOIN
    consultamedica.medico M ON C.id_medico = M.id_medico
LEFT JOIN
    consultamedica.utente U ON C.id_utente = U.id_utente;

SELECT * FROM consultamedica.ConsultasComUtentes;


-- Criar VIEW para dados dos médicos e seus horários base
CREATE VIEW consultamedica.DadosMedicosHorariosBase AS
SELECT
    M.id_medico,
    M.nome AS nome_medico,
    HB.dia_semana,
    HB.hora_inicio,
    HB.hora_fim,
    HB.duracao_consulta
FROM
    consultamedica.medico M
JOIN
    consultamedica.horario_base HB ON M.id_medico = HB.id_medico;

SELECT * FROM consultamedica.DadosMedicosHorariosBase;


--20.
-- Criar PROCEDIMENTO para inserir consultas considerando o horário base do médico
CREATE PROCEDURE consultamedica.InserirConsulta
    @id_medico INT,
    @id_paciente INT,
    @dia DATE
AS
BEGIN
    DECLARE @hora_inicio INT;
    DECLARE @hora_fim INT;

    -- Obter horário base do médico para o dia específico
    SELECT @hora_inicio = hora_inicio, @hora_fim = hora_fim
    FROM consultamedica.horario_base
    WHERE id_medico = @id_medico AND dia_semana = FORMAT(@dia, 'ddd');

    -- Verificar se o horário base foi encontrado
    IF @hora_inicio IS NOT NULL AND @hora_fim IS NOT NULL
    BEGIN
        -- Inserir consulta na primeira vaga do dia
        INSERT INTO consultamedica.consulta (id_medico, id_utente, dia, hora_inicio, hora_fim)
        VALUES (@id_medico, @id_paciente, @dia, @hora_inicio, @hora_inicio + (SELECT duracao_consulta FROM consultamedica.horario_base WHERE id_medico = @id_medico AND dia_semana = FORMAT(@dia, 'ddd')));
        
        PRINT 'Consulta inserida com sucesso.';
    END
    ELSE
    BEGIN
        PRINT 'Horário base não encontrado para o médico neste dia.';
    END
END;

-- Exemplo de chamada do procedimento
EXEC consultamedica.InserirConsulta @id_medico = 1, @id_paciente = 1, @dia = '2024-02-01';

--21.
-- Criar TRIGGER para validar a hora de início e a hora de fim
CREATE TRIGGER tr_ValidarHorario
ON consultamedica.consulta
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @id_consulta INT;
    DECLARE @hora_inicio INT;
    DECLARE @hora_fim INT;
    
    -- Cursor para percorrer as linhas afetadas pelo INSERT ou UPDATE
    DECLARE cursorConsultas CURSOR FOR
    SELECT id_consulta, hora_inicio, hora_fim
    FROM INSERTED;

    OPEN cursorConsultas;
    FETCH NEXT FROM cursorConsultas INTO @id_consulta, @hora_inicio, @hora_fim;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Validar hora de início
        IF @hora_inicio < 0 OR @hora_inicio > 2359 OR (@hora_inicio / 100) > 23 OR (@hora_inicio % 100) > 59
        BEGIN
             DECLARE @ErrorMessage NVARCHAR(255);
            SET @ErrorMessage ='Hora de início inválida.';
            THROW 50000, @ErrorMessage, 1;
            RETURN;
        END;

        -- Validar hora de fim
        IF @hora_fim < 0 OR @hora_fim > 2359 OR (@hora_fim / 100) > 23 OR (@hora_fim % 100) > 59
        BEGIN
            
            SET @ErrorMessage ='Hora de fim inválida.';
            THROW 50000, @ErrorMessage, 1;
            RETURN;
        END;

        FETCH NEXT FROM cursorConsultas INTO @id_consulta, @hora_inicio, @hora_fim;
    END

    CLOSE cursorConsultas;
END;
