-- Consultas críticas ANTES de qualquer otimização.
USE ConectaComunidade;
GO

-- Consulta 1: Listagem de próximos eventos (filtrando por categoria e ordenando por data)
-- Problema: Sem índices, fará um Clustered Index Scan na tabela EVENTO, que é lento em tabelas grandes.
SELECT E.Titulo, E.DataHoraInicio, C.NomeCategoria, L.NomeLocal
FROM EVENTO E
JOIN CATEGORIA C ON E.CategoriaID_FK = C.CategoriaID
JOIN LOCAL L ON E.LocalID_FK = L.LocalID
WHERE C.NomeCategoria = 'Música' AND E.DataHoraInicio > GETDATE()
ORDER BY E.DataHoraInicio;

-- Consulta 2: Busca por palavra-chave no título ou descrição
-- Problema: O uso de LIKE '%...' impede o uso de índices padrão, causando um Scan completo.
SELECT Titulo, Descricao, DataHoraInicio
FROM EVENTO
WHERE Titulo LIKE '%local%' OR Descricao LIKE '%local%';

-- Consulta 3: Contagem de interessados por evento
-- Problema: Fará um Scan na tabela INTERESSE_EVENTO para cada evento, sendo ineficiente.
SELECT E.Titulo, (SELECT COUNT(*) FROM INTERESSE_EVENTO I WHERE I.EventoID_FK = E.EventoID) AS QtdInteressados
FROM EVENTO E
ORDER BY QtdInteressados DESC;