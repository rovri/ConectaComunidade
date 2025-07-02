-- ===================================================================
-- Teste de Performance DEPOIS das Otimizações
-- Para usar: Execute este script no banco criado pelo script 01.
-- ===================================================================
USE ConectaComunidade;
GO

-- Consulta 1: Listagem de próximos eventos (agora usando a Stored Procedure)
-- Plano de execução esperado: Index Seek no índice filtrado IX_EVENTO_Ativos
EXEC sp_ListarProximosEventos;
GO

-- Consulta 2: Busca por palavra-chave (sem alteração, pois a solução ideal seria Full-Text Search)
SELECT Titulo, Descricao, DataHoraInicio
FROM EVENTO
WHERE Titulo LIKE '%local%' OR Descricao LIKE '%local%';
GO

-- Consulta 3: Contagem de interessados (usando a versão otimizada com JOIN)
-- Plano de execução esperado: Index Seek no índice IX_INTERESSE_EVENTO_EventoID
SELECT E.Titulo, COUNT(I.UsuarioID_FK) AS QtdInteressados
FROM EVENTO E
LEFT JOIN INTERESSE_EVENTO I ON E.EventoID = I.EventoID_FK
GROUP BY E.EventoID, E.Titulo
ORDER BY QtdInteressados DESC;
GO