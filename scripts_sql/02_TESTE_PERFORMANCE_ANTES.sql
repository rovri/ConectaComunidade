-- ===================================================================
-- Script de Teste: 02_TESTE_PERFORMANCE_ANTES.sql
-- Autor: Daniel Del Roveri
-- Finalidade: Demonstra a performance do banco ANTES das otimizações.
--             Remove os índices e executa as consultas originais.
-- ===================================================================
USE ConectaComunidade;
GO

-- Garante o cenário SEM otimização, removendo os índices criados.
DROP INDEX IF EXISTS IX_EVENTO_Ativos_Coberto ON EVENTO;
DROP INDEX IF EXISTS IX_INTERESSE_EVENTO_EventoID ON INTERESSE_EVENTO;
GO

-- Consulta 1: Listagem de próximos eventos (sem otimização)
-- Plano de execução esperado: Clustered Index Scan na tabela EVENTO.
SELECT E.Titulo, E.DataHoraInicio, C.NomeCategoria, L.NomeLocal
FROM EVENTO E
JOIN CATEGORIA C ON E.CategoriaID_FK = C.CategoriaID
JOIN LOCAL L ON E.LocalID_FK = L.LocalID
WHERE C.NomeCategoria = 'Música' AND E.DataHoraInicio > GETDATE()
ORDER BY E.DataHoraInicio;
GO

-- Consulta 2: Busca por palavra-chave (sem otimização)
-- Plano de execução esperado: Clustered Index Scan.
SELECT Titulo, Descricao, DataHoraInicio
FROM EVENTO
WHERE Titulo LIKE '%local%' OR Descricao LIKE '%local%';
GO

-- Consulta 3: Contagem de interessados (com subquery ineficiente)
-- Plano de execução esperado: Scans múltiplos e plano complexo.
SELECT E.Titulo, (SELECT COUNT(*) FROM INTERESSE_EVENTO I WHERE I.EventoID_FK = E.EventoID) AS QtdInteressados
FROM EVENTO E
ORDER BY QtdInteressados DESC;
GO

-- Recria os índices para não deixar o banco em estado desotimizado.
CREATE NONCLUSTERED INDEX IX_EVENTO_Ativos_Coberto ON EVENTO (DataHoraInicio) INCLUDE (Titulo, Descricao, LocalID_FK, CategoriaID_FK, EventoID) WHERE (StatusEvento = 1);
CREATE NONCLUSTERED INDEX IX_INTERESSE_EVENTO_EventoID ON INTERESSE_EVENTO(EventoID_FK);
GO