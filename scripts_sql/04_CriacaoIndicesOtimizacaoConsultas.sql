-- Script de criação de índices para otimização das consultas.
USE ConectaComunidade;
GO

-- Índice para a Consulta 1: Otimiza a busca por DataHoraInicio e inclui colunas-chave para
-- criar um "índice coberto" (covering index), evitando acessos à tabela principal (Key Lookup).
CREATE NONCLUSTERED INDEX IX_EVENTO_DataHoraInicio_Categoria
ON EVENTO(DataHoraInicio, CategoriaID_FK)
INCLUDE (Titulo, LocalID_FK);

-- Índice para a Consulta 3: Otimiza a contagem por EventoID_FK na tabela de interesse.
CREATE NONCLUSTERED INDEX IX_INTERESSE_EVENTO_EventoID
ON INTERESSE_EVENTO(EventoID_FK)
INCLUDE (UsuarioID_FK);
