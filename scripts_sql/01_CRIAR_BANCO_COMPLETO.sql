-- ===================================================================
-- Script para Criação Completa do Banco de Dados ConectaComunidade
-- Autor: Daniel Del Roveri
-- Este script cria a estrutura, insere dados e aplica todas as otimizações.
-- ===================================================================

-- 1. CRIAÇÃO DO BANCO DE DADOS
CREATE DATABASE ConectaComunidade;
GO

USE ConectaComunidade;
GO

-- 2. CRIAÇÃO DAS TABELAS (DDL)
CREATE TABLE USUARIO (
    UsuarioID INT PRIMARY KEY IDENTITY(1,1),
    Nome NVARCHAR(150) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    TipoUsuario NVARCHAR(20) NOT NULL CHECK (TipoUsuario IN ('Organizador', 'Participante')),
    DataCadastro DATETIME2 DEFAULT GETDATE()
);

CREATE TABLE CATEGORIA (
    CategoriaID INT PRIMARY KEY IDENTITY(1,1),
    NomeCategoria NVARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE LOCAL (
    LocalID INT PRIMARY KEY IDENTITY(1,1),
    NomeLocal NVARCHAR(200) NOT NULL,
    Endereco NVARCHAR(255) NOT NULL,
    Cidade NVARCHAR(100) NOT NULL,
    Estado CHAR(2) NOT NULL
);

CREATE TABLE EVENTO (
    EventoID INT PRIMARY KEY IDENTITY(1,1),
    Titulo NVARCHAR(200) NOT NULL,
    Descricao NVARCHAR(MAX) NULL,
    DataHoraInicio DATETIME2 NOT NULL,
    DataHoraFim DATETIME2 NULL,
    LocalID_FK INT NOT NULL,
    OrganizadorID_FK INT NOT NULL,
    CategoriaID_FK INT NOT NULL,
    StatusEvento BIT NOT NULL DEFAULT 1, -- Flag para otimização
    CONSTRAINT FK_EVENTO_LOCAL FOREIGN KEY (LocalID_FK) REFERENCES LOCAL(LocalID),
    CONSTRAINT FK_EVENTO_ORGANIZADOR FOREIGN KEY (OrganizadorID_FK) REFERENCES USUARIO(UsuarioID),
    CONSTRAINT FK_EVENTO_CATEGORIA FOREIGN KEY (CategoriaID_FK) REFERENCES CATEGORIA(CategoriaID),
    CONSTRAINT CHK_DataHoraFim_Maior_Que_Inicio CHECK (DataHoraFim IS NULL OR DataHoraFim > DataHoraInicio)
);

CREATE TABLE INTERESSE_EVENTO (
    UsuarioID_FK INT NOT NULL,
    EventoID_FK INT NOT NULL,
    DataInteresse DATETIME2 DEFAULT GETDATE(),
    PRIMARY KEY (UsuarioID_FK, EventoID_FK),
    CONSTRAINT FK_INTERESSE_USUARIO FOREIGN KEY (UsuarioID_FK) REFERENCES USUARIO(UsuarioID),
    CONSTRAINT FK_INTERESSE_EVENTO FOREIGN KEY (EventoID_FK) REFERENCES EVENTO(EventoID)
);
GO

-- 3. CRIAÇÃO DOS ÍNDICES DE OTIMIZAÇÃO
-- Índice filtrado avançado para a consulta principal de eventos ativos
CREATE NONCLUSTERED INDEX IX_EVENTO_Ativos
ON EVENTO(DataHoraInicio)
INCLUDE (Titulo, LocalID_FK, CategoriaID_FK)
WHERE (StatusEvento = 1);
GO

-- Índice para otimizar a contagem de interessados
CREATE NONCLUSTERED INDEX IX_INTERESSE_EVENTO_EventoID
ON INTERESSE_EVENTO(EventoID_FK);
GO

-- 4. CRIAÇÃO DE OBJETOS AVANÇADOS (VIEWS E STORED PROCEDURES)
CREATE VIEW vw_ProximosEventos AS
SELECT 
    E.EventoID, E.Titulo, E.Descricao, E.DataHoraInicio,
    C.NomeCategoria, L.NomeLocal, L.Cidade
FROM EVENTO E
JOIN CATEGORIA C ON E.CategoriaID_FK = C.CategoriaID
JOIN LOCAL L ON E.LocalID_FK = L.LocalID
WHERE E.StatusEvento = 1;
GO

CREATE PROCEDURE sp_ListarProximosEventos
AS
BEGIN
    SET NOCOUNT ON;
    SELECT EventoID, Titulo, NomeCategoria, Cidade, DataHoraInicio 
    FROM vw_ProximosEventos
    ORDER BY DataHoraInicio;
END
GO

CREATE PROCEDURE sp_AtualizarStatusEventos
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE EVENTO
    SET StatusEvento = 0
    WHERE DataHoraInicio < GETDATE() AND StatusEvento = 1;
END
GO

-- 5. INSERÇÃO DE DADOS DE TESTE (DML)
INSERT INTO USUARIO (Nome, Email, TipoUsuario) VALUES
('Ana Silva', 'ana.silva@email.com', 'Organizador'), ('Bruno Costa', 'bruno.costa@email.com', 'Organizador'),
('Carlos Dias', 'carlos.dias@email.com', 'Participante'), ('Diana Souza', 'diana.souza@email.com', 'Participante'),
('Eduardo Lima', 'eduardo.lima@email.com', 'Participante');

INSERT INTO CATEGORIA (NomeCategoria) VALUES ('Música'), ('Esporte'), ('Arte e Cultura'), ('Tecnologia'), ('Gastronomia');

INSERT INTO LOCAL (NomeLocal, Endereco, Cidade, Estado) VALUES
('Parque Ibirapuera', 'Av. Pedro Álvares Cabral, s/n', 'São Paulo', 'SP'),
('Centro Cultural SP', 'Rua Vergueiro, 1000', 'São Paulo', 'SP'),
('Praia de Copacabana', 'Av. Atlântica, s/n', 'Rio de Janeiro', 'RJ');

INSERT INTO EVENTO (Titulo, Descricao, DataHoraInicio) VALUES
('Show de Rock no Parque', 'Festival com bandas locais de rock.', '2025-07-15 18:00:00', 1, 1, 1),
('Feira de Artesanato Local', 'Exposição e venda.', '2025-07-20 10:00:00', 2, 2, 3),
('Maratona Tech', 'Hackathon de 24 horas.', '2025-08-01 09:00:00', 2, 1, 4),
('Torneio de Vôlei de Praia', 'Competição amadora.', '2025-08-10 08:30:00', 3, 2, 2);

INSERT INTO INTERESSE_EVENTO (UsuarioID_FK, EventoID_FK) VALUES
(3, 1), (4, 1), (5, 1),
(3, 2), (4, 2),
(5, 3);
GO