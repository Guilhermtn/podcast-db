-- Script 03: Povoamento das Tabelas (INSERT INTO)

-- 1. ENDERECO_CEP
INSERT INTO ENDERECO_CEP (cep, rua, bairro, cidade, estado, pais)
VALUES ('50670-901', 'Av. Jornalista Anibal Fernandes', 'Cidade Universitaria', 'Recife', 'PE', 'Brasil');

INSERT INTO ENDERECO_CEP (cep, rua, bairro, cidade, estado, pais)
VALUES ('01310-100', 'Av. Paulista', 'Bela Vista', 'Sao Paulo', 'SP', 'Brasil');

INSERT INTO ENDERECO_CEP (cep, rua, bairro, cidade, estado, pais)
VALUES ('20040-020', 'Rua da Quitanda', 'Centro', 'Rio de Janeiro', 'RJ', 'Brasil');

INSERT INTO ENDERECO_CEP (cep, rua, bairro, cidade, estado, pais)
VALUES ('30130-110', 'Av. do Contorno', 'Funcionarios', 'Belo Horizonte', 'MG', 'Brasil');

INSERT INTO ENDERECO_CEP (cep, rua, bairro, cidade, estado, pais)
VALUES ('58038-000', 'Av. General Edson Ramalho', 'Manaira', 'Joao Pessoa', 'PB', 'Brasil');


-- 2. PESSOA  (usando sequences)
-- tipo_pessoa: 'C'=Criador, 'A'=Administrador, 'AN'=Anunciante

-- Criadores
INSERT INTO PESSOA (id_pessoa, nome, email, data_cadastro, tipo_pessoa, telefone_principal, cep, numero)
VALUES (seq_pessoa.NEXTVAL, 'Lucas Matheus Feliciano', 'lucas.feliciano@email.com', DATE '2023-01-15', 'C', '81991110001', '50670-901', '100');

INSERT INTO PESSOA (id_pessoa, nome, email, data_cadastro, tipo_pessoa, telefone_principal, cep, numero)
VALUES (seq_pessoa.NEXTVAL, 'Jose Guilherme Nunes', 'jose.nunes@email.com', DATE '2023-02-20', 'C', '81991110002', '01310-100', '200');

INSERT INTO PESSOA (id_pessoa, nome, email, data_cadastro, tipo_pessoa, telefone_principal, cep, numero)
VALUES (seq_pessoa.NEXTVAL, 'Reilson Fonseca', 'reilson.fonseca@email.com', DATE '2023-03-10', 'C', '83991110003', '58038-000', '50');

INSERT INTO PESSOA (id_pessoa, nome, email, data_cadastro, tipo_pessoa, telefone_principal, cep, numero)
VALUES (seq_pessoa.NEXTVAL, 'Eduardo Buarque', 'eduardo.buarque@email.com', DATE '2023-04-05', 'C', '81991110004', '50670-901', '300');

INSERT INTO PESSOA (id_pessoa, nome, email, data_cadastro, tipo_pessoa, telefone_principal, cep, numero)
VALUES (seq_pessoa.NEXTVAL, 'Lucas Santiago Monterazo', 'lucas.monterazo@email.com', DATE '2023-05-12', 'C', '81991110005', '20040-020', '10');

-- Administradores
INSERT INTO PESSOA (id_pessoa, nome, email, data_cadastro, tipo_pessoa, telefone_principal, cep, numero)
VALUES (seq_pessoa.NEXTVAL, 'Abhner Adriel Silva', 'abhner.silva@podcastplat.com', DATE '2022-06-01', 'A', '81991110006', '01310-100', '1500');

INSERT INTO PESSOA (id_pessoa, nome, email, data_cadastro, tipo_pessoa, telefone_principal, cep, numero)
VALUES (seq_pessoa.NEXTVAL, 'Carla Administradora', 'carla.admin@podcastplat.com', DATE '2021-09-15', 'A', '31991110007', '30130-110', '500');

-- Anunciantes
INSERT INTO PESSOA (id_pessoa, nome, email, data_cadastro, tipo_pessoa, telefone_principal, cep, numero)
VALUES (seq_pessoa.NEXTVAL, 'Empresa TechBrasil Ltda', 'comercial@techbrasil.com.br', DATE '2023-07-01', 'AN', '1131110001', '01310-100', '900');

INSERT INTO PESSOA (id_pessoa, nome, email, data_cadastro, tipo_pessoa, telefone_principal, cep, numero)
VALUES (seq_pessoa.NEXTVAL, 'Loja AudioGear S.A.', 'ads@audiogear.com.br', DATE '2023-08-20', 'AN', '2131110002', '20040-020', '45');


-- 3. ANUNCIANTE  (id_pessoa = 8 e 9)
INSERT INTO ANUNCIANTE (id_pessoa, cnpj, razao_social, contato_comercial)
VALUES (8, '12.345.678/0001-90', 'TechBrasil Tecnologia Ltda', 'comercial@techbrasil.com.br');

INSERT INTO ANUNCIANTE (id_pessoa, cnpj, razao_social, contato_comercial)
VALUES (9, '98.765.432/0001-10', 'AudioGear Equipamentos S.A.', 'ads@audiogear.com.br');


-- 4. ADMINISTRADOR  (id_pessoa = 6 e 7)
-- nivel_acesso: 1=basico, 2=moderador, 3=super
INSERT INTO ADMINISTRADOR (id_pessoa, nivel_acesso, data_contratacao)
VALUES (6, 3, DATE '2022-06-01');

INSERT INTO ADMINISTRADOR (id_pessoa, nivel_acesso, data_contratacao)
VALUES (7, 2, DATE '2021-09-15');


-- 5. CRIADOR  (id_pessoa = 1 a 5)
INSERT INTO CRIADOR (id_pessoa, cpf_cnpj, bio, website, banco, agencia, conta, tipo_conta)
VALUES (1, '111.111.111-01', 'Apaixonado por tecnologia e podcasts. Host do DevCast.', 'https://devcast.com.br', 'Nubank', '0001', '1234567-8', 'corrente');

INSERT INTO CRIADOR (id_pessoa, cpf_cnpj, bio, website, banco, agencia, conta, tipo_conta)
VALUES (2, '222.222.222-02', 'Jornalista e podcaster. Co-host do DevCast e criador do PolicastBR.', 'https://jgtnpodcast.com.br', 'Itau', '0034', '9876543-2', 'corrente');

INSERT INTO CRIADOR (id_pessoa, cpf_cnpj, bio, website, banco, agencia, conta, tipo_conta)
VALUES (3, '333.333.333-03', 'Desenvolvedor full-stack e entusiasta de jogos.', NULL, 'Bradesco', '0012', '5554443-1', 'poupanca');

INSERT INTO CRIADOR (id_pessoa, cpf_cnpj, bio, website, banco, agencia, conta, tipo_conta)
VALUES (4, '444.444.444-04', 'Designer e criador de conteudo sobre cultura pop.', 'https://popcast.io', 'Inter', '0001', '7778889-0', 'pagamento');

INSERT INTO CRIADOR (id_pessoa, cpf_cnpj, bio, website, banco, agencia, conta, tipo_conta)
VALUES (5, '555.555.555-05', 'Especialista em ciencia de dados e IA.', 'https://datacast.ai', 'Santander', '0567', '3332221-9', 'corrente');


-- 6. PLANO
INSERT INTO PLANO (id_plano, nome, descricao, preco_mensal, inclui_estatisticas_avancadas, inclui_transcricoes, limite_armazenamento_gb)
VALUES (seq_plano.NEXTVAL, 'Basico', 'Plano gratuito com recursos essenciais para comecar.', 0, 'N', 'N', 5);

INSERT INTO PLANO (id_plano, nome, descricao, preco_mensal, inclui_estatisticas_avancadas, inclui_transcricoes, limite_armazenamento_gb)
VALUES (seq_plano.NEXTVAL, 'Pro', 'Plano intermediario com estatisticas avancadas.', 49.90, 'S', 'N', 50);

INSERT INTO PLANO (id_plano, nome, descricao, preco_mensal, inclui_estatisticas_avancadas, inclui_transcricoes, limite_armazenamento_gb)
VALUES (seq_plano.NEXTVAL, 'Premium', 'Plano completo com todos os recursos, incluindo transcricoes por IA.', 99.90, 'S', 'S', 500);


-- 7. ASSINATURA_PLANO
INSERT INTO ASSINATURA_PLANO (id_assinatura, id_criador, id_plano, data_inicio, data_fim, status)
VALUES (seq_assinatura.NEXTVAL, 1, 3, DATE '2023-02-01', NULL, 'ativa');

INSERT INTO ASSINATURA_PLANO (id_assinatura, id_criador, id_plano, data_inicio, data_fim, status)
VALUES (seq_assinatura.NEXTVAL, 2, 2, DATE '2023-03-01', NULL, 'ativa');

INSERT INTO ASSINATURA_PLANO (id_assinatura, id_criador, id_plano, data_inicio, data_fim, status)
VALUES (seq_assinatura.NEXTVAL, 3, 1, DATE '2023-05-01', NULL, 'ativa');

INSERT INTO ASSINATURA_PLANO (id_assinatura, id_criador, id_plano, data_inicio, data_fim, status)
VALUES (seq_assinatura.NEXTVAL, 4, 2, DATE '2023-01-01', DATE '2023-12-31', 'expirada');

INSERT INTO ASSINATURA_PLANO (id_assinatura, id_criador, id_plano, data_inicio, data_fim, status)
VALUES (seq_assinatura.NEXTVAL, 5, 3, DATE '2024-01-01', NULL, 'ativa');


-- 8. SEGUE  (auto-relacionamento entre criadores)
INSERT INTO SEGUE (id_seguidor, id_seguido, data_inicio_seguimento)
VALUES (1, 2, DATE '2023-03-01');

INSERT INTO SEGUE (id_seguidor, id_seguido, data_inicio_seguimento)
VALUES (1, 5, DATE '2023-05-20');

INSERT INTO SEGUE (id_seguidor, id_seguido, data_inicio_seguimento)
VALUES (2, 1, DATE '2023-03-05');

INSERT INTO SEGUE (id_seguidor, id_seguido, data_inicio_seguimento)
VALUES (3, 1, DATE '2023-06-01');

INSERT INTO SEGUE (id_seguidor, id_seguido, data_inicio_seguimento)
VALUES (4, 2, DATE '2023-07-10');

INSERT INTO SEGUE (id_seguidor, id_seguido, data_inicio_seguimento)
VALUES (5, 1, DATE '2024-01-15');


-- 9. ANUNCIO
INSERT INTO ANUNCIO (id_anuncio, nome, conteudo_url, tipo, valor_cpm, data_inicio_vigencia, data_fim_vigencia, id_anunciante)
VALUES (seq_anuncio.NEXTVAL, 'TechBrasil - Lancamento Notebook Pro', 'https://cdn.techbrasil.com.br/ads/notebook-pro.mp3', 'preroll', 25.00, DATE '2024-01-01', DATE '2024-06-30', 8);

INSERT INTO ANUNCIO (id_anuncio, nome, conteudo_url, tipo, valor_cpm, data_inicio_vigencia, data_fim_vigencia, id_anunciante)
VALUES (seq_anuncio.NEXTVAL, 'AudioGear - Headset HG500', 'https://cdn.audiogear.com.br/ads/headset-hg500.mp3', 'midroll', 18.50, DATE '2024-02-01', DATE '2024-08-31', 9);

INSERT INTO ANUNCIO (id_anuncio, nome, conteudo_url, tipo, valor_cpm, data_inicio_vigencia, data_fim_vigencia, id_anunciante)
VALUES (seq_anuncio.NEXTVAL, 'TechBrasil - Curso de Cloud', 'https://cdn.techbrasil.com.br/ads/curso-cloud.mp3', 'postroll', 12.75, DATE '2024-03-01', DATE '2024-09-30', 8);


-- 10. PODCAST
INSERT INTO PODCAST (id_podcast, titulo, descricao, capa_url, data_criacao, idioma, explicito, feed_rss_url)
VALUES (seq_podcast.NEXTVAL, 'DevCast', 'Podcast sobre desenvolvimento de software, carreira em tecnologia e as tendencias do mercado de TI.', 'https://devcast.com.br/capa.jpg', DATE '2023-02-01', 'pt-BR', 'N', 'https://devcast.com.br/feed.xml');

INSERT INTO PODCAST (id_podcast, titulo, descricao, capa_url, data_criacao, idioma, explicito, feed_rss_url)
VALUES (seq_podcast.NEXTVAL, 'PolicastBR', 'Analises e debates sobre politica e sociedade brasileira com linguagem acessivel.', 'https://policastbr.com.br/capa.jpg', DATE '2023-04-10', 'pt-BR', 'N', 'https://policastbr.com.br/feed.xml');

INSERT INTO PODCAST (id_podcast, titulo, descricao, capa_url, data_criacao, idioma, explicito, feed_rss_url)
VALUES (seq_podcast.NEXTVAL, 'DataCast AI', 'Inteligencia Artificial, Machine Learning e Ciencia de Dados para todos os niveis.', 'https://datacast.ai/capa.jpg', DATE '2024-01-05', 'pt-BR', 'N', 'https://datacast.ai/feed.xml');

INSERT INTO PODCAST (id_podcast, titulo, descricao, capa_url, data_criacao, idioma, explicito, feed_rss_url)
VALUES (seq_podcast.NEXTVAL, 'PopCast Nordeste', 'Cultura pop, filmes, series e games com um olhar nordestino.', 'https://popcastne.com.br/capa.jpg', DATE '2023-08-15', 'pt-BR', 'S', 'https://popcastne.com.br/feed.xml');


-- 11. PODCAST_GENERO  (multivalorado)
INSERT INTO PODCAST_GENERO (id_podcast, genero) VALUES (1, 'Tecnologia');
INSERT INTO PODCAST_GENERO (id_podcast, genero) VALUES (1, 'Carreira');
INSERT INTO PODCAST_GENERO (id_podcast, genero) VALUES (1, 'Programacao');

INSERT INTO PODCAST_GENERO (id_podcast, genero) VALUES (2, 'Politica');
INSERT INTO PODCAST_GENERO (id_podcast, genero) VALUES (2, 'Sociedade');
INSERT INTO PODCAST_GENERO (id_podcast, genero) VALUES (2, 'Jornalismo');

INSERT INTO PODCAST_GENERO (id_podcast, genero) VALUES (3, 'Tecnologia');
INSERT INTO PODCAST_GENERO (id_podcast, genero) VALUES (3, 'Ciencia');
INSERT INTO PODCAST_GENERO (id_podcast, genero) VALUES (3, 'Educacao');

INSERT INTO PODCAST_GENERO (id_podcast, genero) VALUES (4, 'Entretenimento');
INSERT INTO PODCAST_GENERO (id_podcast, genero) VALUES (4, 'Cultura Pop');


-- 12. PRODUZ  (N:M Criador x Podcast)
INSERT INTO PRODUZ (id_criador, id_podcast, data_entrada, papel)
VALUES (1, 1, DATE '2023-02-01', 'host');

INSERT INTO PRODUZ (id_criador, id_podcast, data_entrada, papel)
VALUES (2, 1, DATE '2023-02-01', 'co-host');

INSERT INTO PRODUZ (id_criador, id_podcast, data_entrada, papel)
VALUES (2, 2, DATE '2023-04-10', 'host');

INSERT INTO PRODUZ (id_criador, id_podcast, data_entrada, papel)
VALUES (5, 3, DATE '2024-01-05', 'host');

INSERT INTO PRODUZ (id_criador, id_podcast, data_entrada, papel)
VALUES (4, 4, DATE '2023-08-15', 'host');

INSERT INTO PRODUZ (id_criador, id_podcast, data_entrada, papel)
VALUES (3, 4, DATE '2023-09-01', 'editor');


-- 13. GERENCIA  (N:M Administrador x Podcast)
INSERT INTO GERENCIA (id_admin, id_podcast, data_atribuicao, motivo)
VALUES (6, 1, DATE '2023-02-05', 'Moderacao inicial do podcast apos cadastro na plataforma.');

INSERT INTO GERENCIA (id_admin, id_podcast, data_atribuicao, motivo)
VALUES (6, 2, DATE '2023-04-15', 'Verificacao de conformidade com politicas de conteudo.');

INSERT INTO GERENCIA (id_admin, id_podcast, data_atribuicao, motivo)
VALUES (7, 3, DATE '2024-01-10', 'Acompanhamento de novo podcast sobre IA.');

INSERT INTO GERENCIA (id_admin, id_podcast, data_atribuicao, motivo)
VALUES (7, 4, DATE '2023-08-20', 'Moderacao de conteudo explicito.');


-- 14. DIRETORIO
INSERT INTO DIRETORIO (id_diretorio, nome, url_base)
VALUES (seq_diretorio.NEXTVAL, 'Spotify', 'https://open.spotify.com');

INSERT INTO DIRETORIO (id_diretorio, nome, url_base)
VALUES (seq_diretorio.NEXTVAL, 'Apple Podcasts', 'https://podcasts.apple.com');

INSERT INTO DIRETORIO (id_diretorio, nome, url_base)
VALUES (seq_diretorio.NEXTVAL, 'Amazon Music', 'https://music.amazon.com');

INSERT INTO DIRETORIO (id_diretorio, nome, url_base)
VALUES (seq_diretorio.NEXTVAL, 'Deezer', 'https://www.deezer.com');


-- 15. DISTRIBUICAO  (N:M Podcast x Diretorio)
INSERT INTO DISTRIBUICAO (id_podcast, id_diretorio, link_distribuicao, data_inclusao)
VALUES (1, 1, 'https://open.spotify.com/show/devcast', DATE '2023-02-10');

INSERT INTO DISTRIBUICAO (id_podcast, id_diretorio, link_distribuicao, data_inclusao)
VALUES (1, 2, 'https://podcasts.apple.com/br/podcast/devcast', DATE '2023-02-12');

INSERT INTO DISTRIBUICAO (id_podcast, id_diretorio, link_distribuicao, data_inclusao)
VALUES (2, 1, 'https://open.spotify.com/show/policastbr', DATE '2023-04-20');

INSERT INTO DISTRIBUICAO (id_podcast, id_diretorio, link_distribuicao, data_inclusao)
VALUES (2, 2, 'https://podcasts.apple.com/br/podcast/policastbr', DATE '2023-04-22');

INSERT INTO DISTRIBUICAO (id_podcast, id_diretorio, link_distribuicao, data_inclusao)
VALUES (3, 1, 'https://open.spotify.com/show/datacastai', DATE '2024-01-15');

INSERT INTO DISTRIBUICAO (id_podcast, id_diretorio, link_distribuicao, data_inclusao)
VALUES (4, 3, 'https://music.amazon.com/podcasts/popcastne', DATE '2023-09-01');

INSERT INTO DISTRIBUICAO (id_podcast, id_diretorio, link_distribuicao, data_inclusao)
VALUES (4, 4, 'https://www.deezer.com/br/show/popcastne', DATE '2023-09-05');


-- 16. EPISODIO  (entidade fraca de PODCAST)
-- DevCast episodios
INSERT INTO EPISODIO (id_podcast, numero_episodio, titulo, status, descricao, data_publicacao, arquivo_audio_url, arquivo_video_url)
VALUES (1, 1, 'Bem-vindo ao DevCast!', 'publicado', 'Episodio piloto: quem somos e o que voce pode esperar.', DATE '2023-02-15', 'https://devcast.com.br/ep001.mp3', NULL);

INSERT INTO EPISODIO (id_podcast, numero_episodio, titulo, status, descricao, data_publicacao, arquivo_audio_url, arquivo_video_url)
VALUES (1, 2, 'O Futuro do Back-end em 2024', 'publicado', 'Discutimos as principais tendencias para developers back-end.', DATE '2023-03-01', 'https://devcast.com.br/ep002.mp3', 'https://devcast.com.br/ep002.mp4');

INSERT INTO EPISODIO (id_podcast, numero_episodio, titulo, status, descricao, data_publicacao, arquivo_audio_url, arquivo_video_url)
VALUES (1, 3, 'Inteligencia Artificial no dia a dia do Dev', 'publicado', 'Como usar IA para aumentar sua produtividade como desenvolvedor.', DATE '2023-03-15', 'https://devcast.com.br/ep003.mp3', NULL);

INSERT INTO EPISODIO (id_podcast, numero_episodio, titulo, status, descricao, data_publicacao, arquivo_audio_url, arquivo_video_url)
VALUES (1, 4, 'Carreira em TI: vale o hype?', 'rascunho', 'Analisamos mercado de trabalho atual para devs juniores.', NULL, NULL, NULL);

-- PolicastBR episodios
INSERT INTO EPISODIO (id_podcast, numero_episodio, titulo, status, descricao, data_publicacao, arquivo_audio_url, arquivo_video_url)
VALUES (2, 1, 'O sistema eleitoral brasileiro explicado', 'publicado', 'Entenda como funciona o sistema de votacao no Brasil.', DATE '2023-05-01', 'https://policastbr.com.br/ep001.mp3', NULL);

INSERT INTO EPISODIO (id_podcast, numero_episodio, titulo, status, descricao, data_publicacao, arquivo_audio_url, arquivo_video_url)
VALUES (2, 2, 'Reforma Tributaria: o que muda?', 'publicado', 'Debate sobre os impactos da reforma tributaria para o cidadao comum.', DATE '2023-06-10', 'https://policastbr.com.br/ep002.mp3', NULL);

-- DataCast AI episodios
INSERT INTO EPISODIO (id_podcast, numero_episodio, titulo, status, descricao, data_publicacao, arquivo_audio_url, arquivo_video_url)
VALUES (3, 1, 'O que e Machine Learning de verdade?', 'publicado', 'Desmistificando Machine Learning para iniciantes.', DATE '2024-01-20', 'https://datacast.ai/ep001.mp3', 'https://datacast.ai/ep001.mp4');

INSERT INTO EPISODIO (id_podcast, numero_episodio, titulo, status, descricao, data_publicacao, arquivo_audio_url, arquivo_video_url)
VALUES (3, 2, 'LLMs e o impacto nos sistemas modernos', 'agendado', 'Como os Large Language Models estao mudando o desenvolvimento de software.', NULL, 'https://datacast.ai/ep002.mp3', NULL);

-- PopCast Nordeste episodios
INSERT INTO EPISODIO (id_podcast, numero_episodio, titulo, status, descricao, data_publicacao, arquivo_audio_url, arquivo_video_url)
VALUES (4, 1, 'Os melhores filmes nordestinos de todos os tempos', 'publicado', 'Nosso top 10 de producoes cinematograficas do Nordeste.', DATE '2023-09-10', 'https://popcastne.com.br/ep001.mp3', NULL);

INSERT INTO EPISODIO (id_podcast, numero_episodio, titulo, status, descricao, data_publicacao, arquivo_audio_url, arquivo_video_url)
VALUES (4, 2, 'Games brasileiros: a cena indie nacional', 'publicado', 'Conversamos sobre o crescimento dos jogos indie feitos no Brasil.', DATE '2023-10-05', 'https://popcastne.com.br/ep002.mp3', 'https://popcastne.com.br/ep002.mp4');


-- 17. PARTICIPA  (ternario: Criador participa de Episodio de Podcast)
-- Lucas Santiago (criador 5, do DataCast) participa do DevCast ep 3 (sobre IA)
INSERT INTO PARTICIPA (id_criador, id_podcast, numero_episodio) VALUES (5, 1, 3);

-- Reilson (criador 3, editor do PopCast) participa do DevCast ep 2
INSERT INTO PARTICIPA (id_criador, id_podcast, numero_episodio) VALUES (3, 1, 2);

-- Jose Guilherme (criador 2, host do PolicastBR) participa do DataCast ep 1
INSERT INTO PARTICIPA (id_criador, id_podcast, numero_episodio) VALUES (2, 3, 1);

-- Eduardo (criador 4, host PopCast) participa do PopCast ep 2 como convidado especial
INSERT INTO PARTICIPA (id_criador, id_podcast, numero_episodio) VALUES (1, 4, 2);


-- 18. VEICULA  (Anuncio veiculado em Episodio)
INSERT INTO VEICULA (id_anuncio, id_podcast, numero_episodio, data_hora_insercao, posicao_segundo, impressoes_contratadas, impressoes_realizadas)
VALUES (1, 1, 1, TIMESTAMP '2023-02-15 08:00:00', 0, 5000, 4850);

INSERT INTO VEICULA (id_anuncio, id_podcast, numero_episodio, data_hora_insercao, posicao_segundo, impressoes_contratadas, impressoes_realizadas)
VALUES (2, 1, 2, TIMESTAMP '2023-03-01 09:30:00', 600, 3000, 3000);

INSERT INTO VEICULA (id_anuncio, id_podcast, numero_episodio, data_hora_insercao, posicao_segundo, impressoes_contratadas, impressoes_realizadas)
VALUES (1, 1, 3, TIMESTAMP '2023-03-15 10:00:00', 0, 4000, 3900);

INSERT INTO VEICULA (id_anuncio, id_podcast, numero_episodio, data_hora_insercao, posicao_segundo, impressoes_contratadas, impressoes_realizadas)
VALUES (3, 2, 1, TIMESTAMP '2023-05-01 08:00:00', 1800, 2000, 1750);

INSERT INTO VEICULA (id_anuncio, id_podcast, numero_episodio, data_hora_insercao, posicao_segundo, impressoes_contratadas, impressoes_realizadas)
VALUES (2, 3, 1, TIMESTAMP '2024-01-20 07:00:00', 900, 6000, 5500);


-- 19. ESTATISTICA_EPISODIO
INSERT INTO ESTATISTICA_EPISODIO (id_podcast, numero_episodio, data_referencia, total_downloads, total_reproducoes, media_tempo_ouvir)
VALUES (1, 1, DATE '2023-02-15', 1200, 980, 2520);

INSERT INTO ESTATISTICA_EPISODIO (id_podcast, numero_episodio, data_referencia, total_downloads, total_reproducoes, media_tempo_ouvir)
VALUES (1, 1, DATE '2023-02-16', 350, 290, 2600);

INSERT INTO ESTATISTICA_EPISODIO (id_podcast, numero_episodio, data_referencia, total_downloads, total_reproducoes, media_tempo_ouvir)
VALUES (1, 2, DATE '2023-03-01', 1500, 1200, 3100);

INSERT INTO ESTATISTICA_EPISODIO (id_podcast, numero_episodio, data_referencia, total_downloads, total_reproducoes, media_tempo_ouvir)
VALUES (1, 3, DATE '2023-03-15', 2000, 1750, 2800);

INSERT INTO ESTATISTICA_EPISODIO (id_podcast, numero_episodio, data_referencia, total_downloads, total_reproducoes, media_tempo_ouvir)
VALUES (2, 1, DATE '2023-05-01', 800, 650, 1800);

INSERT INTO ESTATISTICA_EPISODIO (id_podcast, numero_episodio, data_referencia, total_downloads, total_reproducoes, media_tempo_ouvir)
VALUES (3, 1, DATE '2024-01-20', 3500, 3100, 2200);

INSERT INTO ESTATISTICA_EPISODIO (id_podcast, numero_episodio, data_referencia, total_downloads, total_reproducoes, media_tempo_ouvir)
VALUES (4, 1, DATE '2023-09-10', 600, 500, 2700);

INSERT INTO ESTATISTICA_EPISODIO (id_podcast, numero_episodio, data_referencia, total_downloads, total_reproducoes, media_tempo_ouvir)
VALUES (4, 2, DATE '2023-10-05', 750, 620, 3200);


-- 20. ESTATISTICA_TOP_PAISES  (multivalorado)
INSERT INTO ESTATISTICA_TOP_PAISES (id_podcast, numero_episodio, data_referencia, pais) VALUES (1, 1, DATE '2023-02-15', 'Brasil');
INSERT INTO ESTATISTICA_TOP_PAISES (id_podcast, numero_episodio, data_referencia, pais) VALUES (1, 1, DATE '2023-02-15', 'Portugal');
INSERT INTO ESTATISTICA_TOP_PAISES (id_podcast, numero_episodio, data_referencia, pais) VALUES (1, 1, DATE '2023-02-15', 'Angola');

INSERT INTO ESTATISTICA_TOP_PAISES (id_podcast, numero_episodio, data_referencia, pais) VALUES (1, 2, DATE '2023-03-01', 'Brasil');
INSERT INTO ESTATISTICA_TOP_PAISES (id_podcast, numero_episodio, data_referencia, pais) VALUES (1, 2, DATE '2023-03-01', 'Portugal');

INSERT INTO ESTATISTICA_TOP_PAISES (id_podcast, numero_episodio, data_referencia, pais) VALUES (3, 1, DATE '2024-01-20', 'Brasil');
INSERT INTO ESTATISTICA_TOP_PAISES (id_podcast, numero_episodio, data_referencia, pais) VALUES (3, 1, DATE '2024-01-20', 'Estados Unidos');
INSERT INTO ESTATISTICA_TOP_PAISES (id_podcast, numero_episodio, data_referencia, pais) VALUES (3, 1, DATE '2024-01-20', 'Portugal');


-- 21. ESTATISTICA_DISPOSITIVOS  (multivalorado)
INSERT INTO ESTATISTICA_DISPOSITIVOS (id_podcast, numero_episodio, data_referencia, dispositivo) VALUES (1, 1, DATE '2023-02-15', 'smartphone');
INSERT INTO ESTATISTICA_DISPOSITIVOS (id_podcast, numero_episodio, data_referencia, dispositivo) VALUES (1, 1, DATE '2023-02-15', 'desktop');
INSERT INTO ESTATISTICA_DISPOSITIVOS (id_podcast, numero_episodio, data_referencia, dispositivo) VALUES (1, 1, DATE '2023-02-15', 'tablet');

INSERT INTO ESTATISTICA_DISPOSITIVOS (id_podcast, numero_episodio, data_referencia, dispositivo) VALUES (1, 2, DATE '2023-03-01', 'smartphone');
INSERT INTO ESTATISTICA_DISPOSITIVOS (id_podcast, numero_episodio, data_referencia, dispositivo) VALUES (1, 2, DATE '2023-03-01', 'desktop');

INSERT INTO ESTATISTICA_DISPOSITIVOS (id_podcast, numero_episodio, data_referencia, dispositivo) VALUES (3, 1, DATE '2024-01-20', 'smartphone');
INSERT INTO ESTATISTICA_DISPOSITIVOS (id_podcast, numero_episodio, data_referencia, dispositivo) VALUES (3, 1, DATE '2024-01-20', 'smart-tv');

COMMIT;