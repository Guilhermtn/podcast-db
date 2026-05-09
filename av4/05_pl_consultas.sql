-- SCRIPT 05 - BLOCOS PL/SQL (AV4)
-- Plataforma de Gerenciamento de Podcast - Grupo 7


-- 1) Funcao: calcula receita gerada por um anuncio
-- Itens: 5 (FUNCTION), 6 (%TYPE), 13 (SELECT INTO), 15 (EXCEPTION), 16 (IN)
CREATE OR REPLACE FUNCTION fn_receita_anuncio (
    p_id_anuncio IN ANUNCIO.id_anuncio%TYPE
) RETURN NUMBER IS
    v_cpm        ANUNCIO.valor_cpm%TYPE;
    v_impressoes NUMBER;
BEGIN
    SELECT valor_cpm INTO v_cpm
    FROM ANUNCIO WHERE id_anuncio = p_id_anuncio;

    SELECT NVL(SUM(impressoes_realizadas), 0) INTO v_impressoes
    FROM VEICULA WHERE id_anuncio = p_id_anuncio;

    RETURN (v_impressoes * v_cpm) / 1000;
EXCEPTION
    WHEN NO_DATA_FOUND THEN RETURN 0;
    WHEN OTHERS THEN RETURN 0;
END fn_receita_anuncio;
/


-- 2) Funcao: retorna o nome do plano ativo de um criador
-- Itens: 5 (FUNCTION), 6 (%TYPE), 11 (WHILE LOOP), 15 (EXCEPTION)
CREATE OR REPLACE FUNCTION fn_plano_atual (
    p_id_criador IN CRIADOR.id_pessoa%TYPE
) RETURN VARCHAR2 IS
    v_nome  PLANO.nome%TYPE;
    v_preco PLANO.preco_mensal%TYPE;
    v_faixa VARCHAR2(20) := 'basico';
BEGIN
    SELECT pl.nome, pl.preco_mensal INTO v_nome, v_preco
    FROM ASSINATURA_PLANO ap
    JOIN PLANO pl ON pl.id_plano = ap.id_plano
    WHERE ap.id_criador = p_id_criador AND ap.status = 'ativa'
    FETCH FIRST 1 ROWS ONLY;

    -- WHILE LOOP para classificar a faixa de preco do plano
    WHILE v_preco > 0 LOOP
        IF v_preco >= 90 THEN
            v_faixa := 'premium';
        ELSIF v_preco >= 40 THEN
            v_faixa := 'intermediario';
        END IF;
        EXIT; -- sai apos a primeira avaliacao
    END LOOP;

    RETURN v_nome || ' (' || v_faixa || ')';
EXCEPTION
    WHEN NO_DATA_FOUND THEN RETURN 'Sem plano ativo';
    WHEN OTHERS THEN RETURN 'Erro: ' || SQLERRM;
END fn_plano_atual;
/


-- 3) Package: utilitarios da plataforma
-- Especificacao
-- Itens: 1 (RECORD), 2 (TABLE), 4 (PROCEDURE), 17 (PACKAGE)
CREATE OR REPLACE PACKAGE pkg_podcast AS

    -- RECORD: tipo para resumo de um episodio
    TYPE t_resumo_ep IS RECORD (
        numero_episodio  EPISODIO.numero_episodio%TYPE,
        titulo           EPISODIO.titulo%TYPE,
        total_downloads  NUMBER
    );

    -- TABLE: colecao de resumos
    TYPE t_lista_eps IS TABLE OF t_resumo_ep INDEX BY PLS_INTEGER;

    -- Relatorio de episodios publicados de um podcast
    PROCEDURE sp_relatorio_episodios (
        p_id_podcast IN  PODCAST.id_podcast%TYPE,
        p_total      OUT NUMBER
    );

    -- Publica um episodio agendado ou rascunho
    PROCEDURE sp_publicar_episodio (
        p_id_podcast      IN EPISODIO.id_podcast%TYPE,
        p_num_episodio    IN EPISODIO.numero_episodio%TYPE
    );

END pkg_podcast;
/


-- Package Body
-- Itens: 7 (%ROWTYPE), 8 (IF ELSIF), 9 (CASE WHEN), 10 (LOOP EXIT WHEN),
--        12 (FOR IN LOOP), 14 (CURSOR), 16 (IN/OUT), 18 (PACKAGE BODY)
CREATE OR REPLACE PACKAGE BODY pkg_podcast AS

    PROCEDURE sp_relatorio_episodios (
        p_id_podcast IN  PODCAST.id_podcast%TYPE,
        p_total      OUT NUMBER
    ) IS
        -- %ROWTYPE para linha do podcast
        v_pod  PODCAST%ROWTYPE;

        -- Cursor para episodios publicados
        CURSOR cur_eps IS
            SELECT e.numero_episodio, e.titulo,
                   NVL(SUM(ee.total_downloads), 0) AS downloads
            FROM EPISODIO e
            LEFT JOIN ESTATISTICA_EPISODIO ee
                   ON ee.id_podcast = e.id_podcast
                  AND ee.numero_episodio = e.numero_episodio
            WHERE e.id_podcast = p_id_podcast AND e.status = 'publicado'
            GROUP BY e.numero_episodio, e.titulo
            ORDER BY e.numero_episodio;

        v_ep    cur_eps%ROWTYPE;
        v_count NUMBER := 0;
    BEGIN
        SELECT * INTO v_pod FROM PODCAST WHERE id_podcast = p_id_podcast;
        DBMS_OUTPUT.PUT_LINE('=== ' || v_pod.titulo || ' ===');

        -- CURSOR: OPEN, FETCH, CLOSE
        OPEN cur_eps;
        LOOP
            FETCH cur_eps INTO v_ep;
            EXIT WHEN cur_eps%NOTFOUND;   -- LOOP EXIT WHEN
            v_count := v_count + 1;
            DBMS_OUTPUT.PUT_LINE('Ep.' || v_ep.numero_episodio ||
                ' | ' || v_ep.titulo ||
                ' | Downloads: ' || v_ep.downloads);
        END LOOP;
        CLOSE cur_eps;

        p_total := v_count;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Podcast nao encontrado.');
            p_total := 0;
    END sp_relatorio_episodios;


    PROCEDURE sp_publicar_episodio (
        p_id_podcast   IN EPISODIO.id_podcast%TYPE,
        p_num_episodio IN EPISODIO.numero_episodio%TYPE
    ) IS
        v_status EPISODIO.status%TYPE;
        v_msg    VARCHAR2(100);
    BEGIN
        SELECT status INTO v_status
        FROM EPISODIO
        WHERE id_podcast = p_id_podcast AND numero_episodio = p_num_episodio;

        -- IF ELSIF
        IF v_status = 'publicado' THEN
            DBMS_OUTPUT.PUT_LINE('Episodio ja publicado.');
        ELSIF v_status IN ('agendado', 'rascunho') THEN
            UPDATE EPISODIO
            SET status = 'publicado', data_publicacao = SYSDATE
            WHERE id_podcast = p_id_podcast AND numero_episodio = p_num_episodio;
            COMMIT;

            -- CASE WHEN
            v_msg := CASE v_status
                         WHEN 'agendado' THEN 'Episodio agendado publicado.'
                         WHEN 'rascunho' THEN 'Rascunho publicado diretamente.'
                     END;
            DBMS_OUTPUT.PUT_LINE(v_msg);
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('Episodio nao encontrado.');
        WHEN OTHERS THEN ROLLBACK; DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM);
    END sp_publicar_episodio;

END pkg_podcast;
/


-- 4) Triggers
-- Trigger de LINHA: audita alteracao de preco_mensal nos planos
-- Itens: 20 (TRIGGER LINHA)
CREATE OR REPLACE TRIGGER trg_audita_preco_plano
    AFTER UPDATE OF preco_mensal ON PLANO
    FOR EACH ROW
BEGIN
    IF :OLD.preco_mensal != :NEW.preco_mensal THEN
        DBMS_OUTPUT.PUT_LINE('AUDITORIA: Plano "' || :NEW.nome ||
            '" alterado de R$' || :OLD.preco_mensal ||
            ' para R$' || :NEW.preco_mensal);
    END IF;
END trg_audita_preco_plano;
/

-- Trigger de COMANDO: bloqueia alteracoes na tabela PLANO fora do horario comercial
-- Itens: 19 (TRIGGER COMANDO)
CREATE OR REPLACE TRIGGER trg_bloqueio_plano
    BEFORE INSERT OR UPDATE OR DELETE ON PLANO
DECLARE
    v_hora NUMBER := TO_NUMBER(TO_CHAR(SYSDATE, 'HH24'));
BEGIN
    CASE
        WHEN v_hora < 6 OR v_hora > 22 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Alteracoes em PLANO so permitidas entre 06h e 22h.');
        ELSE NULL;
    END CASE;

    IF INSERTING THEN
        DBMS_OUTPUT.PUT_LINE('INSERT em PLANO permitido.');
    ELSIF UPDATING THEN
        DBMS_OUTPUT.PUT_LINE('UPDATE em PLANO permitido.');
    ELSIF DELETING THEN
        DBMS_OUTPUT.PUT_LINE('DELETE em PLANO permitido.');
    END IF;
END trg_bloqueio_plano;
/


-- 5) Bloco Anonimo: testa todos os subprogramas criados
-- Itens: 3 (BLOCO ANONIMO), 1 (RECORD), 2 (TABLE), 6 (%TYPE),
--        7 (%ROWTYPE), 12 (FOR IN LOOP), 13 (SELECT INTO), 15 (EXCEPTION)
SET SERVEROUTPUT ON;

DECLARE
    -- %TYPE e %ROWTYPE
    v_id_podcast  PODCAST.id_podcast%TYPE := 1;
    v_pod_row     PODCAST%ROWTYPE;
    v_total       NUMBER;
    v_receita     NUMBER;

    -- RECORD e TABLE do package
    v_resumo      pkg_podcast.t_resumo_ep;
    v_lista       pkg_podcast.t_lista_eps;
    v_idx         PLS_INTEGER := 1;
BEGIN
    -- SELECT INTO com %ROWTYPE
    SELECT * INTO v_pod_row FROM PODCAST WHERE id_podcast = v_id_podcast;
    DBMS_OUTPUT.PUT_LINE('Podcast: ' || v_pod_row.titulo || ' | Idioma: ' || v_pod_row.idioma);

    -- Chama procedure do package (relatorio de episodios)
    pkg_podcast.sp_relatorio_episodios(v_id_podcast, v_total);
    DBMS_OUTPUT.PUT_LINE('Total de episodios publicados: ' || v_total);

    -- Publica episodio agendado
    pkg_podcast.sp_publicar_episodio(3, 2);

    -- FOR IN LOOP: calcula receita de cada anuncio
    DBMS_OUTPUT.PUT_LINE('--- Receita por Anuncio ---');
    FOR rec IN (SELECT id_anuncio, nome FROM ANUNCIO ORDER BY id_anuncio) LOOP
        v_receita := fn_receita_anuncio(rec.id_anuncio);
        DBMS_OUTPUT.PUT_LINE(rec.nome || ': R$ ' || TO_CHAR(v_receita, 'FM9990.00'));

        -- Preenche RECORD e armazena na TABLE
        v_resumo.numero_episodio := rec.id_anuncio;
        v_resumo.titulo          := rec.nome;
        v_resumo.total_downloads := v_receita;
        v_lista(v_idx)           := v_resumo;
        v_idx := v_idx + 1;
    END LOOP;

    -- Exibe plano atual de cada criador
    DBMS_OUTPUT.PUT_LINE('--- Plano por Criador ---');
    FOR c IN (SELECT id_pessoa, nome FROM PESSOA WHERE tipo_pessoa = 'C') LOOP
        DBMS_OUTPUT.PUT_LINE(c.nome || ' -> ' || fn_plano_atual(c.id_pessoa));
    END LOOP;

EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('Registro nao encontrado.');
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM);
END;

-- FIM DO SCRIPT PL/SQL - AV4 (20/20 itens cobertos)