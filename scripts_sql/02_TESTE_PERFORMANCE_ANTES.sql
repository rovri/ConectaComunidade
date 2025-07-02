-- ===================================================================
-- Teste de Performance ANTES das Otimizações
-- Para usar: Execute este script em um banco SEM os índices.
-- ===================================================================
USE ConectaComunidade;
GO

-- Para garantir o cenário SEM otimização, podemos remover os índices:
DROP INDEX IF EXISTS IX_EVENTO_Ativos ON EVENTO;
DROP INDEX IF EXISTS IX_INTERESSE_EVENTO_EventoID ON INTERESSE_EVENTO;
GO

-- Consulta 1: Listagem de próximos eventos (sem otimização)
-- Plano de execução esperado: Clustered Index Scan
SELECT E.Titulo, E.DataHoraInicio, C.NomeCategoria, L.NomeLocal
FROM EVENTO E
JOIN CATEGORIA C ON E.CategoriaID_FK = C.CategoriaID
JOIN LOCAL L ON E.LocalID_FK = L.LocalID
WHERE C.NomeCategoria = 'Música' AND E.DataHoraInicio > GETDATE()
ORDER BY E.DataHoraInicio;
GO

-- Consulta 2: Busca por palavra-chave (sem otimização)
-- Plano de execução esperado: Clustered Index Scan
SELECT Titulo, Descricao, DataHoraInicio
FROM EVENTO
WHERE Titulo LIKE '%local%' OR Descricao LIKE '%local%';
GO

-- Consulta 3: Contagem de interessados (sem otimização)
-- Plano de execução esperado: Scans múltiplos
SELECT E.Titulo, (SELECT COUNT(*) FROM INTERESSE_EVENTO I WHERE I.EventoID_FK = E.EventoID) AS QtdInteressados
FROM EVENTO E
ORDER BY QtdInteressados DESC;
GO