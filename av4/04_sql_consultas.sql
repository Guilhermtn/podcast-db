-- SCRIPT 04 - CONSULTAS SQL (AV4)


-- 1. ALTER TABLE
-- Adiciona coluna de duracao (em segundos) aos episodios
ALTER TABLE EPISODIO ADD duracao_segundos NUMBER(8,2);

-- 2. CREATE INDEX
-- Indice para buscas frequentes de episodios por status
CREATE INDEX idx_episodio_status ON EPISODIO (id_podcast, status);

-- 3. INSERT INTO
-- Insere novo diretorio de distribuicao
INSERT INTO DIRETORIO (id_diretorio, nome, url_base)
VALUES (seq_diretorio.NEXTVAL, 'YouTube Music', 'https://music.youtube.com');

-- 4. UPDATE
-- Atualiza status de episodio rascunho para agendado
UPDATE EPISODIO
SET status = 'agendado', data_publicacao = SYSDATE + 7
WHERE id_podcast = 1 AND numero_episodio = 4;

-- 5. DELETE
-- Remove o diretorio inserido no item 3
DELETE FROM DIRETORIO WHERE nome = 'YouTube Music';

-- 6. SELECT-FROM-WHERE
-- Lista podcasts em portugues nao explicitos
SELECT id_podcast, titulo, data_criacao
FROM PODCAST
WHERE idioma = 'pt-BR' AND explicito = 'N';

-- 7. BETWEEN
-- Episodios publicados em 2023
SELECT id_podcast, numero_episodio, titulo, data_publicacao
FROM EPISODIO
WHERE data_publicacao BETWEEN DATE '2023-01-01' AND DATE '2023-12-31'
ORDER BY data_publicacao;

-- 8. IN
-- Criadores com plano Pro ou Premium
SELECT DISTINCT p.nome, pl.nome AS plano
FROM PESSOA p
JOIN ASSINATURA_PLANO a ON a.id_criador = p.id_pessoa
JOIN PLANO pl ON pl.id_plano = a.id_plano
WHERE pl.nome IN ('Pro', 'Premium');

-- 9. LIKE
-- Podcasts com "Cast" no titulo
SELECT id_podcast, titulo FROM PODCAST
WHERE UPPER(titulo) LIKE '%CAST%';

-- 10. IS NULL / IS NOT NULL
-- Episodios sem data de publicacao
SELECT id_podcast, numero_episodio, titulo, status
FROM EPISODIO WHERE data_publicacao IS NULL;

-- Episodios com video disponivel
SELECT id_podcast, numero_episodio, titulo
FROM EPISODIO WHERE arquivo_video_url IS NOT NULL;

-- 11. INNER JOIN
-- Criadores e seus podcasts com papel
SELECT p.nome AS criador, pod.titulo AS podcast, prod.papel
FROM PESSOA p
INNER JOIN PRODUZ prod ON prod.id_criador = p.id_pessoa
INNER JOIN PODCAST pod ON pod.id_podcast = prod.id_podcast
ORDER BY p.nome;

-- 12. MAX
-- Maior total de downloads registrado
SELECT MAX(total_downloads) AS max_downloads FROM ESTATISTICA_EPISODIO;

-- 13. MIN
-- Menor preco mensal entre os planos pagos
SELECT MIN(preco_mensal) AS menor_preco FROM PLANO WHERE preco_mensal > 0;

-- 14. AVG
-- Media de downloads por podcast
SELECT p.titulo, ROUND(AVG(ee.total_downloads), 2) AS media_downloads
FROM PODCAST p
JOIN EPISODIO e ON e.id_podcast = p.id_podcast
JOIN ESTATISTICA_EPISODIO ee ON ee.id_podcast = e.id_podcast
                             AND ee.numero_episodio = e.numero_episodio
GROUP BY p.titulo;

-- 15. COUNT
-- Total de episodios por status
SELECT status, COUNT(*) AS total
FROM EPISODIO
GROUP BY status
ORDER BY total DESC;

-- 16. LEFT OUTER JOIN
-- Todos os podcasts e seus diretorios (inclusive sem distribuicao)
SELECT pod.titulo, dir.nome AS diretorio, dist.data_inclusao
FROM PODCAST pod
LEFT JOIN DISTRIBUICAO dist ON dist.id_podcast = pod.id_podcast
LEFT JOIN DIRETORIO dir ON dir.id_diretorio = dist.id_diretorio
ORDER BY pod.titulo;

-- 17. SUBCONSULTA COM OPERADOR RELACIONAL
-- Podcasts criados apos o mais antigo
SELECT id_podcast, titulo, data_criacao
FROM PODCAST
WHERE data_criacao > (SELECT MIN(data_criacao) FROM PODCAST);

-- 18. SUBCONSULTA COM IN
-- Criadores que possuem assinatura ativa
SELECT nome FROM PESSOA
WHERE id_pessoa IN (
    SELECT id_criador FROM ASSINATURA_PLANO WHERE status = 'ativa'
);

-- 19. SUBCONSULTA COM ANY
-- Episodios com mais downloads que qualquer episodio do PolicastBR (id=2)
SELECT ee.id_podcast, ee.numero_episodio, ee.total_downloads
FROM ESTATISTICA_EPISODIO ee
WHERE ee.total_downloads > ANY (
    SELECT total_downloads FROM ESTATISTICA_EPISODIO WHERE id_podcast = 2
)
ORDER BY ee.total_downloads DESC;

-- 20. SUBCONSULTA COM ALL
-- Episodios com downloads acima de todos os do PopCast Nordeste (id=4)
SELECT ee.id_podcast, ee.numero_episodio, ee.total_downloads
FROM ESTATISTICA_EPISODIO ee
WHERE ee.total_downloads > ALL (
    SELECT total_downloads FROM ESTATISTICA_EPISODIO WHERE id_podcast = 4
)
ORDER BY ee.total_downloads DESC;

-- 21. ORDER BY
-- Ranking de criadores por numero de seguidores
SELECT p.nome, COUNT(s.id_seguidor) AS total_seguidores
FROM PESSOA p
LEFT JOIN SEGUE s ON s.id_seguido = p.id_pessoa
WHERE p.tipo_pessoa = 'C'
GROUP BY p.id_pessoa, p.nome
ORDER BY total_seguidores DESC;

-- 22. GROUP BY
-- Total de impressoes realizadas por anunciante
SELECT an.razao_social,
       SUM(v.impressoes_realizadas) AS total_impressoes
FROM ANUNCIANTE an
JOIN ANUNCIO adc ON adc.id_anunciante = an.id_pessoa
JOIN VEICULA v ON v.id_anuncio = adc.id_anuncio
GROUP BY an.razao_social;

-- 23. HAVING
-- Podcasts com media de downloads acima de 1000
SELECT p.titulo, ROUND(AVG(ee.total_downloads), 2) AS media_downloads
FROM PODCAST p
JOIN EPISODIO e ON e.id_podcast = p.id_podcast
JOIN ESTATISTICA_EPISODIO ee ON ee.id_podcast = e.id_podcast
                             AND ee.numero_episodio = e.numero_episodio
GROUP BY p.id_podcast, p.titulo
HAVING AVG(ee.total_downloads) > 1000;

-- 24. UNION / INTERSECT / MINUS

-- UNION: lista unificada de emails de criadores e anunciantes
SELECT p.email, 'Criador' AS tipo FROM PESSOA p JOIN CRIADOR c ON c.id_pessoa = p.id_pessoa
UNION
SELECT p.email, 'Anunciante' AS tipo FROM PESSOA p JOIN ANUNCIANTE a ON a.id_pessoa = p.id_pessoa;

-- INTERSECT: podcasts distribuidos no Spotify (id=1) E no Apple Podcasts (id=2)
SELECT id_podcast FROM DISTRIBUICAO WHERE id_diretorio = 1
INTERSECT
SELECT id_podcast FROM DISTRIBUICAO WHERE id_diretorio = 2;

-- MINUS: criadores sem nenhuma assinatura ativa
SELECT id_pessoa FROM CRIADOR
MINUS
SELECT id_criador FROM ASSINATURA_PLANO WHERE status = 'ativa';

-- 25. CREATE VIEW
-- View de desempenho consolidado dos podcasts
CREATE OR REPLACE VIEW vw_desempenho_podcast AS
SELECT pod.id_podcast, pod.titulo,
       COUNT(DISTINCT e.numero_episodio)       AS total_episodios,
       NVL(SUM(ee.total_downloads), 0)         AS downloads_totais,
       ROUND(AVG(ee.media_tempo_ouvir)/60, 2)  AS media_min_ouvidos
FROM PODCAST pod
LEFT JOIN EPISODIO e ON e.id_podcast = pod.id_podcast
LEFT JOIN ESTATISTICA_EPISODIO ee ON ee.id_podcast = e.id_podcast
                                  AND ee.numero_episodio = e.numero_episodio
GROUP BY pod.id_podcast, pod.titulo;

SELECT * FROM vw_desempenho_podcast ORDER BY downloads_totais DESC;

-- 26. GRANT / REVOKE
-- Abaixo a demonstracao do uso correto dos comandos:

GRANT SELECT ON vw_desempenho_podcast TO usr_criador;
REVOKE SELECT ON vw_desempenho_podcast FROM usr_criador;
