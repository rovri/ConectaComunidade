-- Script de Inser��o de Dados de Teste (DML)
USE ConectaComunidade;
GO

-- Inserir Usu�rios
INSERT INTO USUARIO (Nome, Email, TipoUsuario) VALUES
('Ana Silva', 'ana.silva@email.com', 'Organizador'),
('Bruno Costa', 'bruno.costa@email.com', 'Organizador'),
('Carlos Dias', 'carlos.dias@email.com', 'Participante'),
('Diana Souza', 'diana.souza@email.com', 'Participante'),
('Eduardo Lima', 'eduardo.lima@email.com', 'Participante');

-- Inserir Categorias
INSERT INTO CATEGORIA (NomeCategoria) VALUES ('M�sica'), ('Esporte'), ('Arte e Cultura'), ('Tecnologia'), ('Gastronomia');

-- Inserir Locais
INSERT INTO LOCAL (NomeLocal, Endereco, Cidade, Estado) VALUES
('Parque Ibirapuera', 'Av. Pedro �lvares Cabral, s/n', 'S�o Paulo', 'SP'),
('Centro Cultural SP', 'Rua Vergueiro, 1000', 'S�o Paulo', 'SP'),
('Praia de Copacabana', 'Av. Atl�ntica, s/n', 'Rio de Janeiro', 'RJ');

-- Inserir Eventos
INSERT INTO EVENTO (Titulo, Descricao, DataHoraInicio, LocalID_FK, OrganizadorID_FK, CategoriaID_FK) VALUES
('Show de Rock no Parque', 'Festival com bandas locais de rock.', '2025-07-15 18:00:00', 1, 1, 1),
('Feira de Artesanato Local', 'Exposi��o e venda de produtos artesanais da comunidade.', '2025-07-20 10:00:00', 2, 2, 3),
('Maratona Tech', 'Hackathon de 24 horas para desenvolver solu��es c�vicas.', '2025-08-01 09:00:00', 2, 1, 4),
('Torneio de V�lei de Praia', 'Competi��o amadora na praia de Copacabana.', '2025-08-10 08:30:00', 3, 2, 2);

-- Registrar Interesse
INSERT INTO INTERESSE_EVENTO (UsuarioID_FK, EventoID_FK) VALUES
(3, 1), (4, 1), (5, 1), -- 3 interessados no show de rock
(3, 2), (4, 2),          -- 2 interessados na feira de artesanato
(5, 3);                  -- 1 interessado na maratona tech
GO
