-- Consultas críticas DEPOIS da criação dos índices.
USE ConectaComunidade;
GO

-- Consulta 1: Listagem de próximos eventos (agora otimizada)
-- Ganho: Usará o índice IX_EVENTO_DataHoraInicio_Categoria para um Index Seek rápido.
SELECT E.Titulo, E.DataHoraInicio, C.NomeCategoria, L.NomeLocal
FROM EVENTO E
JOIN CATEGORIA C ON E.CategoriaID_FK = C.CategoriaID
JOIN LOCAL L ON E.LocalID_FK = L.LocalID
WHERE C.NomeCategoria = 'Música' AND E.DataHoraInicio > GETDATE()
ORDER BY E.DataHoraInicio;

-- Consulta 2: Busca por palavra-chave (sem alteração na query, a otimização seria via Full-Text Search)
-- A consulta permanece a mesma, mas a reflexão é que a solução ideal é outra tecnologia.
SELECT Titulo, Descricao, DataHoraInicio
FROM EVENTO
WHERE Titulo LIKE '%local%' OR Descricao LIKE '%local%';

-- Consulta 3: Contagem de interessados (agora otimizada com JOIN)
-- Ganho: O JOIN é mais eficiente que a subquery e usará o índice IX_INTERESSE_EVENTO_EventoID.
SELECT E.Titulo, COUNT(I.UsuarioID_FK) AS QtdInteressados
FROM EVENTO E
LEFT JOIN INTERESSE_EVENTO I ON E.EventoID = I.EventoID_FK
GROUP BY E.EventoID, E.Titulo
ORDER BY QtdInteressados DESC;