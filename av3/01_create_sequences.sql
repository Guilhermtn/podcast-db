-- Script 01: Criacao das Sequences

-- Sequence para PESSOA
CREATE SEQUENCE seq_pessoa
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- Sequence para PLANO
CREATE SEQUENCE seq_plano
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- Sequence para ASSINATURA_PLANO
CREATE SEQUENCE seq_assinatura
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- Sequence para ANUNCIO
CREATE SEQUENCE seq_anuncio
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- Sequence para PODCAST
CREATE SEQUENCE seq_podcast
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- Sequence para DIRETORIO
CREATE SEQUENCE seq_diretorio
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;