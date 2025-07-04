-- ===================================================================
-- Script de Teste: 03_TESTE_PERFORMANCE_DEPOIS.sql
-- Autor: Daniel Del Roveri
-- Finalidade: Demonstra a performance do banco DEPOIS das otimizações.
--             Utiliza Stored Procedures e consultas otimizadas.
-- ===================================================================
USE ConectaComunidade;
GO

-- Consulta 1: Demonstra o uso da Stored Procedure e do índice coberto/filtrado.
-- Plano de execução esperado: Scan no pequeno índice IX_EVENTO_Ativos_Coberto.
EXEC sp_ListarProximosEventos;
GO

-- Consulta 2: Demonstra uma consulta não otimizável por índices B-Tree.
-- Plano de execução esperado: Clustered Index Scan.
SELECT Titulo, Descricao, DataHoraInicio
FROM EVENTO
WHERE Titulo LIKE '%local%' OR Descricao LIKE '%local%';
GO

-- Consulta 3: Demonstra o uso do índice na chave estrangeira para otimizar JOINs.
-- Plano de execução esperado: Plano eficiente com Index Seek ou Hash Match otimizado.
SELECT E.Titulo, COUNT(I.UsuarioID_FK) AS QtdInteressados
FROM EVENTO E
LEFT JOIN INTERESSE_EVENTO I ON E.EventoID = I.EventoID_FK
GROUP BY E.EventoID, E.Titulo
ORDER BY QtdInteressados DESC;
GO