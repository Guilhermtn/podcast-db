-- Script 02: Criacao das Tabelas
-- Ordem respeita dependencias de chave estrangeira


-- 1. ENDERECO_CEP
-- Tabela extraida na 3FN para eliminar dependencia transitiva
-- id_pessoa -> cep -> (rua, bairro, cidade, estado, pais)
CREATE TABLE ENDERECO_CEP (
    cep         VARCHAR2(9)     NOT NULL,
    rua         VARCHAR2(150)   NOT NULL,
    bairro      VARCHAR2(100)   NOT NULL,
    cidade      VARCHAR2(100)   NOT NULL,
    estado      CHAR(2)         NOT NULL,
    pais        VARCHAR2(60)    NOT NULL,

    CONSTRAINT pk_endereco_cep  PRIMARY KEY (cep),
    CONSTRAINT chk_cep_formato  CHECK (REGEXP_LIKE(cep, '^\d{5}-\d{3}$')),
    CONSTRAINT chk_estado_uf    CHECK (LENGTH(estado) = 2)
);


-- 2. PESSOA  (superclasse da hierarquia disjunta)
CREATE TABLE PESSOA (
    id_pessoa           NUMBER          NOT NULL,
    nome                VARCHAR2(150)   NOT NULL,
    email               VARCHAR2(200)   NOT NULL,
    data_cadastro       DATE            NOT NULL,
    tipo_pessoa         CHAR(2)         NOT NULL,
    telefone_principal  VARCHAR2(20),
    cep                 VARCHAR2(9),
    numero              VARCHAR2(10),

    CONSTRAINT pk_pessoa        PRIMARY KEY (id_pessoa),
    CONSTRAINT uq_pessoa_email  UNIQUE (email),
    CONSTRAINT fk_pessoa_cep    FOREIGN KEY (cep) REFERENCES ENDERECO_CEP (cep),
    CONSTRAINT chk_tipo_pessoa  CHECK (tipo_pessoa IN ('C', 'A', 'AN'))
);


-- 3. ANUNCIANTE  (subclasse de PESSOA)
CREATE TABLE ANUNCIANTE (
    id_pessoa           NUMBER          NOT NULL,
    cnpj                VARCHAR2(18)    NOT NULL,
    razao_social        VARCHAR2(200)   NOT NULL,
    contato_comercial   VARCHAR2(200),

    CONSTRAINT pk_anunciante        PRIMARY KEY (id_pessoa),
    CONSTRAINT fk_anunciante_pessoa FOREIGN KEY (id_pessoa) REFERENCES PESSOA (id_pessoa),
    CONSTRAINT uq_anunciante_cnpj   UNIQUE (cnpj),
    CONSTRAINT chk_cnpj_formato     CHECK (REGEXP_LIKE(cnpj, '^\d{2}\.\d{3}\.\d{3}/\d{4}-\d{2}$'))
);


-- 4. ADMINISTRADOR  (subclasse de PESSOA)
CREATE TABLE ADMINISTRADOR (
    id_pessoa           NUMBER          NOT NULL,
    nivel_acesso        NUMBER(1)       NOT NULL,
    data_contratacao    DATE            NOT NULL,

    CONSTRAINT pk_administrador         PRIMARY KEY (id_pessoa),
    CONSTRAINT fk_admin_pessoa          FOREIGN KEY (id_pessoa) REFERENCES PESSOA (id_pessoa),
    CONSTRAINT chk_nivel_acesso         CHECK (nivel_acesso IN (1, 2, 3))
);


-- 5. CRIADOR  (subclasse de PESSOA)
-- dados_bancarios decomposto em 1FN: banco, agencia, conta, tipo_conta
CREATE TABLE CRIADOR (
    id_pessoa   NUMBER          NOT NULL,
    cpf_cnpj    VARCHAR2(18)    NOT NULL,
    bio         VARCHAR2(1000),
    website     VARCHAR2(300),
    banco       VARCHAR2(100),
    agencia     VARCHAR2(10),
    conta       VARCHAR2(20),
    tipo_conta  VARCHAR2(15),

    CONSTRAINT pk_criador           PRIMARY KEY (id_pessoa),
    CONSTRAINT fk_criador_pessoa    FOREIGN KEY (id_pessoa) REFERENCES PESSOA (id_pessoa),
    CONSTRAINT uq_criador_cpf_cnpj  UNIQUE (cpf_cnpj),
    CONSTRAINT chk_tipo_conta       CHECK (tipo_conta IN ('corrente', 'poupanca', 'pagamento') OR tipo_conta IS NULL)
);


-- 6. PLANO
CREATE TABLE PLANO (
    id_plano                        NUMBER          NOT NULL,
    nome                            VARCHAR2(60)    NOT NULL,
    descricao                       VARCHAR2(500),
    preco_mensal                    NUMBER(8,2)     NOT NULL,
    inclui_estatisticas_avancadas   CHAR(1)         DEFAULT 'N' NOT NULL,
    inclui_transcricoes             CHAR(1)         DEFAULT 'N' NOT NULL,
    limite_armazenamento_gb         NUMBER(6)       NOT NULL,

    CONSTRAINT pk_plano                         PRIMARY KEY (id_plano),
    CONSTRAINT uq_plano_nome                    UNIQUE (nome),
    CONSTRAINT chk_plano_preco                  CHECK (preco_mensal >= 0),
    CONSTRAINT chk_plano_armazenamento          CHECK (limite_armazenamento_gb > 0),
    CONSTRAINT chk_plano_estat_avancadas        CHECK (inclui_estatisticas_avancadas IN ('S', 'N')),
    CONSTRAINT chk_plano_transcricoes           CHECK (inclui_transcricoes IN ('S', 'N'))
);


-- 7. ASSINATURA_PLANO  (entidade associativa Criador x Plano)
CREATE TABLE ASSINATURA_PLANO (
    id_assinatura   NUMBER          NOT NULL,
    id_criador      NUMBER          NOT NULL,
    id_plano        NUMBER          NOT NULL,
    data_inicio     DATE            NOT NULL,
    data_fim        DATE,
    status          VARCHAR2(10)    NOT NULL,

    CONSTRAINT pk_assinatura            PRIMARY KEY (id_assinatura),
    CONSTRAINT fk_assinatura_criador    FOREIGN KEY (id_criador)    REFERENCES CRIADOR (id_pessoa),
    CONSTRAINT fk_assinatura_plano      FOREIGN KEY (id_plano)      REFERENCES PLANO (id_plano),
    CONSTRAINT chk_assinatura_status    CHECK (status IN ('ativa', 'cancelada', 'expirada')),
    CONSTRAINT chk_assinatura_datas     CHECK (data_fim IS NULL OR data_fim >= data_inicio)
);


-- 8. SEGUE  (auto-relacionamento N:M entre CRIADOR)
CREATE TABLE SEGUE (
    id_seguidor             NUMBER  NOT NULL,
    id_seguido              NUMBER  NOT NULL,
    data_inicio_seguimento  DATE    NOT NULL,

    CONSTRAINT pk_segue             PRIMARY KEY (id_seguidor, id_seguido),
    CONSTRAINT fk_segue_seguidor    FOREIGN KEY (id_seguidor) REFERENCES CRIADOR (id_pessoa),
    CONSTRAINT fk_segue_seguido     FOREIGN KEY (id_seguido)  REFERENCES CRIADOR (id_pessoa),
    CONSTRAINT chk_segue_diferente  CHECK (id_seguidor <> id_seguido)
);


-- 9. ANUNCIO
CREATE TABLE ANUNCIO (
    id_anuncio              NUMBER          NOT NULL,
    nome                    VARCHAR2(200)   NOT NULL,
    conteudo_url            VARCHAR2(500)   NOT NULL,
    tipo                    VARCHAR2(10)    NOT NULL,
    valor_cpm               NUMBER(10,4)    NOT NULL,
    data_inicio_vigencia    DATE            NOT NULL,
    data_fim_vigencia       DATE            NOT NULL,
    id_anunciante           NUMBER          NOT NULL,

    CONSTRAINT pk_anuncio               PRIMARY KEY (id_anuncio),
    CONSTRAINT fk_anuncio_anunciante    FOREIGN KEY (id_anunciante) REFERENCES ANUNCIANTE (id_pessoa),
    CONSTRAINT chk_anuncio_tipo         CHECK (tipo IN ('preroll', 'midroll', 'postroll')),
    CONSTRAINT chk_anuncio_cpm          CHECK (valor_cpm > 0),
    CONSTRAINT chk_anuncio_vigencia     CHECK (data_fim_vigencia >= data_inicio_vigencia)
);


-- 10. PODCAST
CREATE TABLE PODCAST (
    id_podcast      NUMBER          NOT NULL,
    titulo          VARCHAR2(300)   NOT NULL,
    descricao       VARCHAR2(2000),
    capa_url        VARCHAR2(500),
    data_criacao    DATE            NOT NULL,
    idioma          CHAR(5)         NOT NULL,
    explicito       CHAR(1)         DEFAULT 'N' NOT NULL,
    feed_rss_url    VARCHAR2(500),

    CONSTRAINT pk_podcast           PRIMARY KEY (id_podcast),
    CONSTRAINT uq_podcast_feed_rss  UNIQUE (feed_rss_url),
    CONSTRAINT chk_podcast_explic   CHECK (explicito IN ('S', 'N'))
);


-- 11. PODCAST_GENERO  (atributo multivalorado de PODCAST - 4FN)
CREATE TABLE PODCAST_GENERO (
    id_podcast  NUMBER          NOT NULL,
    genero      VARCHAR2(60)    NOT NULL,

    CONSTRAINT pk_podcast_genero    PRIMARY KEY (id_podcast, genero),
    CONSTRAINT fk_pg_podcast        FOREIGN KEY (id_podcast) REFERENCES PODCAST (id_podcast)
);


-- 12. PRODUZ  (N:M Criador x Podcast)
CREATE TABLE PRODUZ (
    id_criador      NUMBER          NOT NULL,
    id_podcast      NUMBER          NOT NULL,
    data_entrada    DATE            NOT NULL,
    papel           VARCHAR2(30)    NOT NULL,

    CONSTRAINT pk_produz            PRIMARY KEY (id_criador, id_podcast),
    CONSTRAINT fk_produz_criador    FOREIGN KEY (id_criador)    REFERENCES CRIADOR (id_pessoa),
    CONSTRAINT fk_produz_podcast    FOREIGN KEY (id_podcast)    REFERENCES PODCAST (id_podcast),
    CONSTRAINT chk_produz_papel     CHECK (papel IN ('host', 'co-host', 'editor', 'produtor', 'roteirista'))
);


-- 13. GERENCIA  (N:M Administrador x Podcast)
CREATE TABLE GERENCIA (
    id_admin            NUMBER          NOT NULL,
    id_podcast          NUMBER          NOT NULL,
    data_atribuicao     DATE            NOT NULL,
    motivo              VARCHAR2(500),

    CONSTRAINT pk_gerencia          PRIMARY KEY (id_admin, id_podcast),
    CONSTRAINT fk_gerencia_admin    FOREIGN KEY (id_admin)      REFERENCES ADMINISTRADOR (id_pessoa),
    CONSTRAINT fk_gerencia_podcast  FOREIGN KEY (id_podcast)    REFERENCES PODCAST (id_podcast)
);


-- 14. DIRETORIO
CREATE TABLE DIRETORIO (
    id_diretorio    NUMBER          NOT NULL,
    nome            VARCHAR2(100)   NOT NULL,
    url_base        VARCHAR2(300),

    CONSTRAINT pk_diretorio     PRIMARY KEY (id_diretorio),
    CONSTRAINT uq_dir_nome      UNIQUE (nome)
);


-- 15. DISTRIBUICAO  (N:M Podcast x Diretorio)
CREATE TABLE DISTRIBUICAO (
    id_podcast          NUMBER          NOT NULL,
    id_diretorio        NUMBER          NOT NULL,
    link_distribuicao   VARCHAR2(500),
    data_inclusao       DATE            NOT NULL,

    CONSTRAINT pk_distribuicao          PRIMARY KEY (id_podcast, id_diretorio),
    CONSTRAINT fk_distrib_podcast       FOREIGN KEY (id_podcast)    REFERENCES PODCAST (id_podcast),
    CONSTRAINT fk_distrib_diretorio     FOREIGN KEY (id_diretorio)  REFERENCES DIRETORIO (id_diretorio)
);


-- 16. EPISODIO  (entidade fraca de PODCAST)
-- Chave primaria composta: (id_podcast, numero_episodio)
CREATE TABLE EPISODIO (
    id_podcast          NUMBER          NOT NULL,
    numero_episodio     NUMBER          NOT NULL,
    titulo              VARCHAR2(300)   NOT NULL,
    status              VARCHAR2(10)    NOT NULL,
    descricao           VARCHAR2(2000),
    data_publicacao     DATE,
    arquivo_audio_url   VARCHAR2(500),
    arquivo_video_url   VARCHAR2(500),

    CONSTRAINT pk_episodio          PRIMARY KEY (id_podcast, numero_episodio),
    CONSTRAINT fk_episodio_podcast  FOREIGN KEY (id_podcast) REFERENCES PODCAST (id_podcast),
    CONSTRAINT chk_episodio_status  CHECK (status IN ('rascunho', 'publicado', 'agendado')),
    CONSTRAINT chk_ep_num_positivo  CHECK (numero_episodio > 0)
);


-- 17. PARTICIPA  (ternario N:N:N  Criador x Podcast x Episodio)
CREATE TABLE PARTICIPA (
    id_criador          NUMBER  NOT NULL,
    id_podcast          NUMBER  NOT NULL,
    numero_episodio     NUMBER  NOT NULL,

    CONSTRAINT pk_participa             PRIMARY KEY (id_criador, id_podcast, numero_episodio),
    CONSTRAINT fk_participa_criador     FOREIGN KEY (id_criador)                    REFERENCES CRIADOR (id_pessoa),
    CONSTRAINT fk_participa_episodio    FOREIGN KEY (id_podcast, numero_episodio)   REFERENCES EPISODIO (id_podcast, numero_episodio)
);


-- 18. VEICULA  (N:M Anuncio x Episodio)
CREATE TABLE VEICULA (
    id_anuncio              NUMBER          NOT NULL,
    id_podcast              NUMBER          NOT NULL,
    numero_episodio         NUMBER          NOT NULL,
    data_hora_insercao      TIMESTAMP       NOT NULL,
    posicao_segundo         NUMBER(8,2),
    impressoes_contratadas  NUMBER          NOT NULL,
    impressoes_realizadas   NUMBER          DEFAULT 0 NOT NULL,

    CONSTRAINT pk_veicula               PRIMARY KEY (id_anuncio, id_podcast, numero_episodio),
    CONSTRAINT fk_veicula_anuncio       FOREIGN KEY (id_anuncio)                    REFERENCES ANUNCIO (id_anuncio),
    CONSTRAINT fk_veicula_episodio      FOREIGN KEY (id_podcast, numero_episodio)   REFERENCES EPISODIO (id_podcast, numero_episodio),
    CONSTRAINT chk_veicula_posicao      CHECK (posicao_segundo IS NULL OR posicao_segundo >= 0),
    CONSTRAINT chk_veicula_impressoes   CHECK (impressoes_contratadas > 0),
    CONSTRAINT chk_veicula_realizadas   CHECK (impressoes_realizadas >= 0)
);


-- 19. ESTATISTICA_EPISODIO  (entidade fraca de EPISODIO)
-- Chave primaria composta: (id_podcast, numero_episodio, data_referencia)
CREATE TABLE ESTATISTICA_EPISODIO (
    id_podcast          NUMBER  NOT NULL,
    numero_episodio     NUMBER  NOT NULL,
    data_referencia     DATE    NOT NULL,
    total_downloads     NUMBER  DEFAULT 0 NOT NULL,
    total_reproducoes   NUMBER  DEFAULT 0 NOT NULL,
    media_tempo_ouvir   NUMBER(10,2),

    CONSTRAINT pk_estat_episodio        PRIMARY KEY (id_podcast, numero_episodio, data_referencia),
    CONSTRAINT fk_estat_episodio        FOREIGN KEY (id_podcast, numero_episodio) REFERENCES EPISODIO (id_podcast, numero_episodio),
    CONSTRAINT chk_estat_downloads      CHECK (total_downloads >= 0),
    CONSTRAINT chk_estat_reproducoes    CHECK (total_reproducoes >= 0),
    CONSTRAINT chk_estat_tempo          CHECK (media_tempo_ouvir IS NULL OR media_tempo_ouvir >= 0)
);


-- 20. ESTATISTICA_TOP_PAISES  (multivalorado de ESTAT_EPISODIO - 4FN)
CREATE TABLE ESTATISTICA_TOP_PAISES (
    id_podcast          NUMBER          NOT NULL,
    numero_episodio     NUMBER          NOT NULL,
    data_referencia     DATE            NOT NULL,
    pais                VARCHAR2(100)   NOT NULL,

    CONSTRAINT pk_estat_top_paises  PRIMARY KEY (id_podcast, numero_episodio, data_referencia, pais),
    CONSTRAINT fk_etp_estatistica   FOREIGN KEY (id_podcast, numero_episodio, data_referencia)
                                    REFERENCES ESTATISTICA_EPISODIO (id_podcast, numero_episodio, data_referencia)
);


-- 21. ESTATISTICA_DISPOSITIVOS  (multivalorado de ESTAT_EPISODIO - 4FN)
CREATE TABLE ESTATISTICA_DISPOSITIVOS (
    id_podcast          NUMBER          NOT NULL,
    numero_episodio     NUMBER          NOT NULL,
    data_referencia     DATE            NOT NULL,
    dispositivo         VARCHAR2(100)   NOT NULL,

    CONSTRAINT pk_estat_dispositivos    PRIMARY KEY (id_podcast, numero_episodio, data_referencia, dispositivo),
    CONSTRAINT fk_ed_estatistica        FOREIGN KEY (id_podcast, numero_episodio, data_referencia)
                                        REFERENCES ESTATISTICA_EPISODIO (id_podcast, numero_episodio, data_referencia)
);