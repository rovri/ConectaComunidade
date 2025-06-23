-- Script de Criação do Esquema (DDL) para o projeto ConectaComunidade
-- SGBD: Microsoft SQL Server

CREATE DATABASE ConectaComunidade;
GO

USE ConectaComunidade;
GO

-- Tabela de Usuários (Organizadores e Participantes)
CREATE TABLE USUARIO (
    UsuarioID INT PRIMARY KEY IDENTITY(1,1),
    Nome NVARCHAR(150) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    TipoUsuario NVARCHAR(20) NOT NULL CHECK (TipoUsuario IN ('Organizador', 'Participante')),
    DataCadastro DATETIME2 DEFAULT GETDATE()
);

-- Tabela de Categorias de Eventos
CREATE TABLE CATEGORIA (
    CategoriaID INT PRIMARY KEY IDENTITY(1,1),
    NomeCategoria NVARCHAR(100) NOT NULL UNIQUE
);

-- Tabela de Locais dos Eventos
CREATE TABLE LOCAL (
    LocalID INT PRIMARY KEY IDENTITY(1,1),
    NomeLocal NVARCHAR(200) NOT NULL,
    Endereco NVARCHAR(255) NOT NULL,
    Cidade NVARCHAR(100) NOT NULL,
    Estado CHAR(2) NOT NULL
);

-- Tabela Principal de Eventos
CREATE TABLE EVENTO (
    EventoID INT PRIMARY KEY IDENTITY(1,1),
    Titulo NVARCHAR(200) NOT NULL,
    Descricao NVARCHAR(MAX) NULL,
    DataHoraInicio DATETIME2 NOT NULL,
    DataHoraFim DATETIME2 NULL,
    LocalID_FK INT NOT NULL,
    OrganizadorID_FK INT NOT NULL,
    CategoriaID_FK INT NOT NULL,
    
    CONSTRAINT FK_EVENTO_LOCAL FOREIGN KEY (LocalID_FK) REFERENCES LOCAL(LocalID),
    CONSTRAINT FK_EVENTO_ORGANIZADOR FOREIGN KEY (OrganizadorID_FK) REFERENCES USUARIO(UsuarioID),
    CONSTRAINT FK_EVENTO_CATEGORIA FOREIGN KEY (CategoriaID_FK) REFERENCES CATEGORIA(CategoriaID)
);

-- Tabela de Associação para registrar o interesse dos participantes nos eventos (N:M)
CREATE TABLE INTERESSE_EVENTO (
    UsuarioID_FK INT NOT NULL,
    EventoID_FK INT NOT NULL,
    DataInteresse DATETIME2 DEFAULT GETDATE(),

    PRIMARY KEY (UsuarioID_FK, EventoID_FK), -- Chave primária composta
    CONSTRAINT FK_INTERESSE_USUARIO FOREIGN KEY (UsuarioID_FK) REFERENCES USUARIO(UsuarioID),
    CONSTRAINT FK_INTERESSE_EVENTO FOREIGN KEY (EventoID_FK) REFERENCES EVENTO(EventoID)
);
GO