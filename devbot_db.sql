-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
<<<<<<< HEAD
-- Tempo de geração: 21/09/2025 às 05:11
=======
-- Tempo de geração: 21/09/2025 às 03:29
>>>>>>> 909e0a58ea37757439a1a11ae6c5c062dc7c0a33
-- Versão do servidor: 10.4.32-MariaDB
-- Versão do PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `devbot_db`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `conversations`
--

CREATE TABLE `conversations` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `auto_title` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `is_archived` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `conversations`
--

INSERT INTO `conversations` (`id`, `user_id`, `title`, `auto_title`, `created_at`, `updated_at`, `is_archived`) VALUES
<<<<<<< HEAD
(1, 3, 'O que é JavaScript?', 'O que é JavaScript?', '2025-09-20 20:13:12', '2025-09-20 20:13:17', 0),
(2, 3, 'o Que É Java script?', 'o Que É Java script?', '2025-09-21 01:39:06', '2025-09-21 01:39:12', 0),
(3, 3, 'O que é mongo db?', 'O que é mongo db?', '2025-09-21 01:49:09', '2025-09-21 01:49:14', 0),
(4, 3, 'oi', 'oi', '2025-09-21 01:52:24', '2025-09-21 01:52:25', 0),
(5, 3, 'ola', 'ola', '2025-09-21 01:53:50', '2025-09-21 01:53:52', 0),
(6, 3, 'oi', 'oi', '2025-09-21 01:54:10', '2025-09-21 01:54:11', 0),
(7, 3, 'aaaa', 'aaaa', '2025-09-21 01:55:45', '2025-09-21 01:55:47', 0),
(11, 4, 'oi', 'oi', '2025-09-21 03:04:17', '2025-09-21 03:10:01', 0);
=======
(1, 3, 'O que é JavaScript?', 'O que é JavaScript?', '2025-09-20 20:13:12', '2025-09-20 20:13:17', 0);
>>>>>>> 909e0a58ea37757439a1a11ae6c5c062dc7c0a33

-- --------------------------------------------------------

--
-- Estrutura para tabela `messages`
--

CREATE TABLE `messages` (
  `id` int(11) NOT NULL,
  `conversation_id` int(11) NOT NULL,
  `role` enum('user','assistant','system') NOT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `tokens_used` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `messages`
--

INSERT INTO `messages` (`id`, `conversation_id`, `role`, `content`, `created_at`, `tokens_used`) VALUES
(1, 1, 'user', 'O que é JavaScript?', '2025-09-20 20:13:12', 0),
<<<<<<< HEAD
(2, 1, 'assistant', 'JavaScript é uma linguagem de programação de alto nível, interpretada e dinâmica, amplamente utilizada para adicionar interatividade a páginas web. Originalmente criada para rodar dentro de navegadores, hoje em dia é utilizada em diversos ambientes, como servidores (Node.js), aplicações mobile (React Native), e até mesmo em aplicações desktop (Electron).\n\nAqui está um resumo dos principais pontos sobre JavaScript:\n\n**Principais Características:**\n\n*   **Linguagem de Script:** JavaScript é uma linguagem de script, o que significa que o código é executado linha por linha pelo interpretador (o motor JavaScript no navegador ou outro ambiente de execução).\n*   **Orientada a Objetos:** JavaScript suporta paradigmas de programação orientada a objetos, permitindo a criação de objetos com propriedades e métodos.\n*   **Tipagem Dinâmica:** O tipo de uma variável é determinado em tempo de execução, o que significa que você não precisa declarar o tipo de uma variável explicitamente.\n*   **Interpretada:** O código JavaScript é interpretado diretamente pelo navegador (ou outro ambiente de execução) sem a necessidade de compilação prévia.\n*   **Multi-Paradigma:** Além de orientação a objetos, JavaScript também suporta programação funcional e imperativa.\n*   **Baseada em Protótipos:** A herança em JavaScript é baseada em protótipos, um modelo diferente da herança clássica baseada em classes.\n*   **Event-Driven (Orientada a Eventos):** JavaScript é frequentemente usada para responder a eventos, como cliques do mouse, pressionamentos de teclas e carregamento de páginas.\n\n**Usos Principais:**\n\n*   **Interatividade em Páginas Web:** O principal uso original do JavaScript é adicionar interatividade a páginas web. Isso inclui coisas como:\n    *   Animações\n    *   Validação de formulários\n    *   Atualização dinâmica de conteúdo\n    *   Manipulação do DOM (Document Object Model)\n    *   Criação de jogos no navegador\n*   **Desenvolvimento Front-End:** JavaScript é a linguagem principal para o desenvolvimento front-end, com frameworks e bibliotecas populares como React, Angular e Vue.js.\n*   **Desenvolvimento Back-End:** Com Node.js, JavaScript pode ser usado para criar aplicativos do lado do servidor, APIs e microsserviços.\n*   **Desenvolvimento Mobile:** Frameworks como React Native e NativeScript permitem o uso de JavaScript para criar aplicativos mobile para iOS e Android.\n*   **Aplicações Desktop:** Ferramentas como Electron permitem o uso de JavaScript para criar aplicativos desktop multiplataforma.\n\n**Exemplo Simples:**\n\n```javascript\n// Exibe um alerta na tela\nalert(\"Olá, mundo!\");\n\n// Modifica o conteúdo de um elemento HTML\ndocument.getElementById(\"meuElemento\").innerHTML = \"Novo conteúdo!\";\n\n// Adiciona um evento de clique a um botão\ndocument.getElementById(\"meuBotao\").addEventListener(\"click\", function() {\n  alert(\"Botão clicado!\");\n});\n```\n\n**Em resumo:** JavaScript é uma linguagem poderosa e versátil que se tornou essencial para o desenvolvimento web moderno e além. Sua capacidade de rodar tanto no cliente quanto no servidor, juntamente com a vasta quantidade de frameworks e bibliotecas disponíveis, a tornam uma ferramenta valiosa para desenvolvedores de todos os níveis.\n', '2025-09-20 20:13:17', 0),
(3, 2, 'user', 'o Que É Java script?', '2025-09-21 01:39:06', 0),
(4, 2, 'assistant', 'JavaScript é uma linguagem de programação de alto nível, interpretada e versátil, que é essencial para o desenvolvimento web moderno.  Aqui está um resumo do que ela é:\n\n**Em termos simples:**\n\n*   **Linguagem de programação para a web:** É a linguagem que dá vida e interatividade às páginas da web. Enquanto HTML estrutura o conteúdo e CSS define o estilo visual, JavaScript controla o comportamento e a dinâmica da página.\n\n**Em termos mais técnicos:**\n\n*   **Linguagem de script:**  Significa que o código JavaScript é executado linha por linha, sem a necessidade de compilação prévia (como acontece com linguagens como C++ ou Java).\n*   **Linguagem interpretada:** O código JavaScript é interpretado diretamente pelo navegador do usuário (ou por um ambiente de execução como o Node.js).\n*   **Linguagem de alto nível:** É mais fácil de ler e escrever do que linguagens de baixo nível (como Assembly), pois usa conceitos mais abstratos e próximos da linguagem humana.\n*   **Linguagem orientada a objetos (baseada em protótipos):**  JavaScript suporta programação orientada a objetos, embora utilize um modelo de herança baseado em protótipos, diferente do modelo clássico baseado em classes.\n\n**O que o JavaScript faz?**\n\n*   **Interatividade:** Permite criar botões que reagem ao clique, formulários que validam dados em tempo real, animações, jogos e muito mais.\n*   **Manipulação do DOM (Document Object Model):**  Pode modificar dinamicamente o conteúdo, a estrutura e o estilo de uma página web.\n*   **Requisições assíncronas (AJAX):**  Permite que uma página web se comunique com um servidor em segundo plano, sem precisar recarregar a página inteira.  Isso melhora a experiência do usuário, tornando as aplicações mais rápidas e responsivas.\n*   **Desenvolvimento Front-End:** É a principal linguagem para criar interfaces de usuário ricas e interativas em navegadores web.  Frameworks e bibliotecas populares como React, Angular e Vue.js são construídos em JavaScript.\n*   **Desenvolvimento Back-End (com Node.js):** Permite usar JavaScript para criar servidores e APIs (Interfaces de Programação de Aplicações).\n*   **Desenvolvimento Mobile (com frameworks como React Native e Ionic):** Permite criar aplicativos móveis que funcionam em iOS e Android usando JavaScript.\n*   **Desenvolvimento de jogos (com frameworks como Phaser e Three.js):** Permite criar jogos para web e outras plataformas.\n*   **Automação de tarefas:** Pode ser usado para automatizar tarefas repetitivas, como manipulação de arquivos ou testes automatizados.\n*   **Internet das Coisas (IoT):**  Pode ser usado em dispositivos IoT para controlar hardware e coletar dados.\n\n**Resumo:**\n\nJavaScript é uma ferramenta poderosa e versátil que é fundamental para o desenvolvimento web moderno e que se expandiu para outras áreas, como desenvolvimento mobile, back-end e jogos. Sua capacidade de adicionar interatividade e dinamismo às páginas web a torna indispensável para criar experiências de usuário ricas e envolventes.\n', '2025-09-21 01:39:12', 0),
(5, 3, 'user', 'O que é mongo db?', '2025-09-21 01:49:09', 0),
(6, 3, 'assistant', 'MongoDB é um sistema de gerenciamento de banco de dados **NoSQL** (Not Only SQL) orientado a documentos. Isso significa que, ao invés de armazenar dados em tabelas com linhas e colunas como em bancos de dados relacionais (SQL), ele armazena dados em documentos flexíveis, semelhantes a JSON (JavaScript Object Notation).\n\n**Principais características e benefícios do MongoDB:**\n\n*   **Orientado a Documentos:** Os dados são armazenados em documentos, que são coleções de campos e valores. Esses documentos podem ter estruturas diferentes dentro da mesma coleção, o que oferece grande flexibilidade.\n*   **Escalabilidade:** Projetado para lidar com grandes volumes de dados e alto tráfego, o MongoDB pode ser escalado horizontalmente, adicionando mais servidores para distribuir a carga.\n*   **Flexibilidade de Esquema:** Não exige um esquema predefinido. Isso permite que você adicione novos campos aos documentos sem precisar alterar a estrutura do banco de dados.\n*   **Alto Desempenho:** O MongoDB utiliza índices e outras otimizações para garantir um desempenho rápido em consultas.\n*   **Fácil de Usar:** A sintaxe de consulta é intuitiva e baseada em JSON, o que facilita o aprendizado e o desenvolvimento.\n*   **Replicação:** Suporta replicação de dados, o que garante alta disponibilidade e tolerância a falhas.\n*   **Suporte a Geolocalização:** Possui recursos avançados para armazenar e consultar dados geoespaciais.\n*   **Código Aberto:** O MongoDB é um projeto de código aberto com uma grande comunidade de desenvolvedores.\n\n**Em resumo, o MongoDB é uma boa escolha para:**\n\n*   Aplicações web e móveis que precisam de flexibilidade de esquema e escalabilidade.\n*   Aplicações que lidam com grandes volumes de dados não estruturados ou semiestruturados.\n*   Aplicações que precisam de alta disponibilidade e tolerância a falhas.\n*   Projetos que precisam de um desenvolvimento rápido e iterativo.\n\n**Comparado com bancos de dados relacionais (SQL), o MongoDB oferece:**\n\n*   **Mais flexibilidade:** Permite armazenar dados com estruturas diferentes na mesma coleção.\n*   **Melhor escalabilidade:** Facilidade para escalar horizontalmente para lidar com grandes volumes de dados.\n*   **Desenvolvimento mais rápido:** Não exige um esquema predefinido, o que agiliza o desenvolvimento.\n\n**Exemplos de uso do MongoDB:**\n\n*   **Catálogos de produtos:** Armazenar informações sobre produtos com diferentes atributos.\n*   **Sistemas de gerenciamento de conteúdo (CMS):** Armazenar artigos, páginas e outros conteúdos.\n*   **Redes sociais:** Armazenar informações sobre usuários, posts e conexões.\n*   **Análise de dados:** Armazenar e analisar grandes volumes de dados de diferentes fontes.\n\nSe você precisar de mais informações sobre um aspecto específico do MongoDB, como instalação, consultas ou casos de uso, pode me perguntar.\n', '2025-09-21 01:49:14', 0),
(7, 4, 'user', 'oi', '2025-09-21 01:52:24', 0),
(8, 4, 'assistant', 'Oi! Tudo bem? Como posso te ajudar hoje?\n', '2025-09-21 01:52:25', 0),
(9, 5, 'user', 'ola', '2025-09-21 01:53:50', 0),
(10, 5, 'assistant', 'Olá! Como posso te ajudar hoje?\n', '2025-09-21 01:53:52', 0),
(11, 6, 'user', 'oi', '2025-09-21 01:54:10', 0),
(12, 6, 'assistant', 'Oi! Tudo bem? Em que posso ajudar?\n', '2025-09-21 01:54:11', 0),
(13, 7, 'user', 'aaaa', '2025-09-21 01:55:45', 0),
(14, 7, 'assistant', 'Okay, I understand. Is there anything I can help you with? Do you have a question or need some information?\n', '2025-09-21 01:55:47', 0),
(23, 11, 'user', 'oi', '2025-09-21 03:04:17', 0),
(24, 11, 'assistant', 'Oi! Tudo bem? 👋\n', '2025-09-21 03:04:18', 0),
(25, 11, 'user', 'sim graças a Deus', '2025-09-21 03:04:24', 0),
(26, 11, 'assistant', 'Que bom! Fico feliz em saber que você está bem. 😊 Em que posso te ajudar hoje?\n', '2025-09-21 03:04:25', 0),
(27, 11, 'user', 'queria conversar', '2025-09-21 03:04:30', 0),
(28, 11, 'assistant', 'Ótimo! Sobre o que você gostaria de conversar? Pode ser sobre qualquer coisa que te interesse, desde notícias e hobbies até questões mais profundas. Me diga o que te vem à mente. 😊\n', '2025-09-21 03:04:30', 0),
(29, 11, 'user', 'eu estou feliz por 2 motivos', '2025-09-21 03:04:43', 0),
(30, 11, 'assistant', 'Que maravilha! Compartilhe comigo, adoraria saber quais são esses dois motivos que te deixaram feliz! 😊\n', '2025-09-21 03:04:44', 0),
(31, 11, 'user', '1 é que você está funcionando depois de muito tempo de programação e 2 amanhã/hoje domingo dia 21/09/2025, irei na casa da minha garota, a mulher q eu amo', '2025-09-21 03:05:27', 0),
(32, 11, 'assistant', 'Que legal! Fico muito feliz em ser útil depois desse tempo todo de programação. É ótimo saber que estou funcionando bem.\n\nE que notícia maravilhosa sobre o domingo! Ir na casa da pessoa que você ama é sempre especial. Desejo que o encontro seja incrível, cheio de alegria e momentos inesquecíveis. Aproveite cada segundo! 😊\n', '2025-09-21 03:05:29', 0),
(33, 11, 'user', 'Eu preciso de uma ajuda mais geral agora, normalmente eu sou uma pessoa muito quieta porque tenho dificuldade de puxar assunto quando o assunto está fluindo até vai, mas queria saber ganchos para começar uma conversa fluida', '2025-09-21 03:06:35', 0),
(34, 11, 'assistant', 'Entendo! Começar uma conversa pode ser desafiador, especialmente para quem é mais introvertido. Mas com algumas dicas e prática, você pode se sentir mais confiante para puxar assunto e manter a conversa fluindo. Aqui estão algumas ideias de \"ganchos\" e estratégias:\n\n**Ganchos para Iniciar a Conversa:**\n\n*   **Observações sobre o ambiente:**\n    *   \"Que lugar legal, né? Você já tinha vindo aqui antes?\" (Se estiverem em um lugar público)\n    *   \"Nossa, que dia quente/frio/chuvoso! Você gosta desse tipo de clima?\"\n    *   \"Adorei essa música que está tocando! Você conhece essa banda?\"\n*   **Comentários sobre eventos atuais (com cautela):**\n    *   \"Você viu a notícia sobre... [algo leve e interessante]? O que achou?\" (Evite temas polêmicos no início)\n    *   \"Estou super animado(a) para o lançamento do novo filme/jogo/livro de... Você também?\"\n*   **Perguntas sobre interesses em comum (se você souber de algum):**\n    *   \"Eu sei que você gosta de [hobby/atividade]. Tem alguma dica para quem está começando?\"\n    *   \"Ouvi dizer que você foi para [lugar]. Como foi a experiência?\"\n*   **Elogios sinceros:**\n    *   \"Adorei sua camisa/bolsa/acessório. Onde você comprou?\" (Use com moderação e seja genuíno)\n    *   \"Estava reparando como você é bom(a) em... Parabéns!\" (Se você observou alguma habilidade da pessoa)\n*   **Perguntas abertas:**\n    *   \"O que você tem feito de bom ultimamente?\"\n    *   \"Qual foi a coisa mais interessante que te aconteceu essa semana?\"\n\n**Dicas para Manter a Conversa Fluindo:**\n\n*   **Escute ativamente:** Preste atenção ao que a pessoa está dizendo, faça contato visual e mostre interesse genuíno.\n*   **Faça perguntas abertas:** Perguntas que não podem ser respondidas com \"sim\" ou \"não\" incentivam a pessoa a falar mais.\n*   **Compartilhe suas próprias experiências:** Depois de ouvir a pessoa, compartilhe algo relevante sobre você para criar uma conexão.\n*   **Use o método FORD:**\n    *   **F**amília: Pergunte sobre irmãos, pais, etc. (Com cuidado para não ser invasivo)\n    *   **O**cupação: Pergunte sobre o trabalho ou estudos da pessoa.\n    *   **R**ecreação: Pergunte sobre hobbies, esportes, atividades de lazer.\n    *   **D**inheiro: Evite falar sobre isso no início, a menos que seja relevante para o contexto.\n*   **Encontre pontos em comum:** Procure por interesses compartilhados e explore esses tópicos.\n*   **Seja você mesmo:** Não tente ser alguém que você não é. A autenticidade é atraente.\n*   **Não tenha medo do silêncio:** Pausas são normais em conversas. Não se sinta pressionado a preencher cada segundo com palavras.\n*   **Esteja preparado para mudar de assunto:** Se a conversa estiver perdendo o interesse, mude para um tópico diferente.\n*   **Saiba quando encerrar a conversa:** Não force a barra se a pessoa parecer desinteressada ou ocupada.\n\n**Lembre-se:**\n\n*   **A prática leva à perfeição:** Quanto mais você praticar, mais fácil ficará.\n*   **Não se preocupe em ser perfeito:** Todo mundo comete erros ao conversar. O importante é aprender com eles.\n*   **Seja paciente:** Nem todas as conversas serão um sucesso. Não desanime se algumas não forem tão fluidas quanto você gostaria.\n\nEspero que essas dicas te ajudem! Se tiver alguma dúvida ou quiser praticar comigo, é só me dizer. 😉\n', '2025-09-21 03:06:43', 0),
(35, 11, 'user', 'Gostei das dicas, muitissimo obrigado', '2025-09-21 03:10:00', 0),
(36, 11, 'assistant', 'De nada! Fico muito feliz em poder ajudar. 😊 Se precisar de mais alguma coisa, é só chamar!\n', '2025-09-21 03:10:01', 0);
=======
(2, 1, 'assistant', 'JavaScript é uma linguagem de programação de alto nível, interpretada e dinâmica, amplamente utilizada para adicionar interatividade a páginas web. Originalmente criada para rodar dentro de navegadores, hoje em dia é utilizada em diversos ambientes, como servidores (Node.js), aplicações mobile (React Native), e até mesmo em aplicações desktop (Electron).\n\nAqui está um resumo dos principais pontos sobre JavaScript:\n\n**Principais Características:**\n\n*   **Linguagem de Script:** JavaScript é uma linguagem de script, o que significa que o código é executado linha por linha pelo interpretador (o motor JavaScript no navegador ou outro ambiente de execução).\n*   **Orientada a Objetos:** JavaScript suporta paradigmas de programação orientada a objetos, permitindo a criação de objetos com propriedades e métodos.\n*   **Tipagem Dinâmica:** O tipo de uma variável é determinado em tempo de execução, o que significa que você não precisa declarar o tipo de uma variável explicitamente.\n*   **Interpretada:** O código JavaScript é interpretado diretamente pelo navegador (ou outro ambiente de execução) sem a necessidade de compilação prévia.\n*   **Multi-Paradigma:** Além de orientação a objetos, JavaScript também suporta programação funcional e imperativa.\n*   **Baseada em Protótipos:** A herança em JavaScript é baseada em protótipos, um modelo diferente da herança clássica baseada em classes.\n*   **Event-Driven (Orientada a Eventos):** JavaScript é frequentemente usada para responder a eventos, como cliques do mouse, pressionamentos de teclas e carregamento de páginas.\n\n**Usos Principais:**\n\n*   **Interatividade em Páginas Web:** O principal uso original do JavaScript é adicionar interatividade a páginas web. Isso inclui coisas como:\n    *   Animações\n    *   Validação de formulários\n    *   Atualização dinâmica de conteúdo\n    *   Manipulação do DOM (Document Object Model)\n    *   Criação de jogos no navegador\n*   **Desenvolvimento Front-End:** JavaScript é a linguagem principal para o desenvolvimento front-end, com frameworks e bibliotecas populares como React, Angular e Vue.js.\n*   **Desenvolvimento Back-End:** Com Node.js, JavaScript pode ser usado para criar aplicativos do lado do servidor, APIs e microsserviços.\n*   **Desenvolvimento Mobile:** Frameworks como React Native e NativeScript permitem o uso de JavaScript para criar aplicativos mobile para iOS e Android.\n*   **Aplicações Desktop:** Ferramentas como Electron permitem o uso de JavaScript para criar aplicativos desktop multiplataforma.\n\n**Exemplo Simples:**\n\n```javascript\n// Exibe um alerta na tela\nalert(\"Olá, mundo!\");\n\n// Modifica o conteúdo de um elemento HTML\ndocument.getElementById(\"meuElemento\").innerHTML = \"Novo conteúdo!\";\n\n// Adiciona um evento de clique a um botão\ndocument.getElementById(\"meuBotao\").addEventListener(\"click\", function() {\n  alert(\"Botão clicado!\");\n});\n```\n\n**Em resumo:** JavaScript é uma linguagem poderosa e versátil que se tornou essencial para o desenvolvimento web moderno e além. Sua capacidade de rodar tanto no cliente quanto no servidor, juntamente com a vasta quantidade de frameworks e bibliotecas disponíveis, a tornam uma ferramenta valiosa para desenvolvedores de todos os níveis.\n', '2025-09-20 20:13:17', 0);
>>>>>>> 909e0a58ea37757439a1a11ae6c5c062dc7c0a33

-- --------------------------------------------------------

--
-- Estrutura para tabela `sessions`
--

CREATE TABLE `sessions` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `session_token` varchar(64) NOT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `expires_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `session_token`, `ip_address`, `user_agent`, `created_at`, `expires_at`) VALUES
<<<<<<< HEAD
(6, 3, '4a83e854fa8574516bfcea8a8d34060693947b873022d4f7c17b617dfe842fc6', NULL, NULL, '2025-09-21 03:10:53', '2025-09-28 00:10:53');
=======
(4, 3, '099baa0e1934d151aaa96d544e28ff45b32be8f63c4de70564db4f2e56c35ed9', NULL, NULL, '2025-09-20 20:11:02', '2025-09-27 17:11:02');
>>>>>>> 909e0a58ea37757439a1a11ae6c5c062dc7c0a33

-- --------------------------------------------------------

--
-- Estrutura para tabela `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `api_key` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `last_login` timestamp NULL DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password_hash`, `api_key`, `created_at`, `last_login`, `is_active`) VALUES
<<<<<<< HEAD
(3, 'ZIKI', 'ziki@gmail.com', '$2y$10$g9UMknCszk0Nfyz9pxTsGuGA4tyLxSE2v5.8KKUrJP5V0b9cXywoO', NULL, '2025-09-20 20:11:02', '2025-09-21 03:10:53', 1),
(4, 'Manu', 'manu@gmail.com', '$2y$10$93HXId5DdR635T.VZ1W4rOZly106IICP.X/ulK6OBE0LnsTEp17my', NULL, '2025-09-21 02:54:57', NULL, 1);
=======
(3, 'ZIKI', 'ziki@gmail.com', '$2y$10$g9UMknCszk0Nfyz9pxTsGuGA4tyLxSE2v5.8KKUrJP5V0b9cXywoO', NULL, '2025-09-20 20:11:02', NULL, 1);
>>>>>>> 909e0a58ea37757439a1a11ae6c5c062dc7c0a33

-- --------------------------------------------------------

--
-- Estrutura para tabela `user_settings`
--

CREATE TABLE `user_settings` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `theme` enum('dark','light') DEFAULT 'dark',
  `temperature` decimal(2,1) DEFAULT 0.7,
  `max_tokens` int(11) DEFAULT 2048,
  `model` varchar(50) DEFAULT 'gemini-2.0-flash',
  `system_prompt` text DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `user_settings`
--

INSERT INTO `user_settings` (`id`, `user_id`, `theme`, `temperature`, `max_tokens`, `model`, `system_prompt`, `updated_at`) VALUES
<<<<<<< HEAD
(3, 3, 'dark', 0.7, 2048, 'gemini-2.0-flash', NULL, '2025-09-20 20:11:02'),
(4, 4, 'dark', 0.7, 2048, 'gemini-2.0-flash', NULL, '2025-09-21 02:54:57');
=======
(3, 3, 'dark', 0.7, 2048, 'gemini-2.0-flash', NULL, '2025-09-20 20:11:02');
>>>>>>> 909e0a58ea37757439a1a11ae6c5c062dc7c0a33

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `conversations`
--
ALTER TABLE `conversations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`);

--
-- Índices de tabela `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_conversation_id` (`conversation_id`);

--
-- Índices de tabela `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `session_token` (`session_token`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `idx_token` (`session_token`);

--
-- Índices de tabela `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Índices de tabela `user_settings`
--
ALTER TABLE `user_settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `conversations`
--
ALTER TABLE `conversations`
<<<<<<< HEAD
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;
=======
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
>>>>>>> 909e0a58ea37757439a1a11ae6c5c062dc7c0a33

--
-- AUTO_INCREMENT de tabela `messages`
--
ALTER TABLE `messages`
<<<<<<< HEAD
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;
=======
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
>>>>>>> 909e0a58ea37757439a1a11ae6c5c062dc7c0a33

--
-- AUTO_INCREMENT de tabela `sessions`
--
ALTER TABLE `sessions`
<<<<<<< HEAD
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
=======
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
>>>>>>> 909e0a58ea37757439a1a11ae6c5c062dc7c0a33

--
-- AUTO_INCREMENT de tabela `users`
--
ALTER TABLE `users`
<<<<<<< HEAD
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
=======
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
>>>>>>> 909e0a58ea37757439a1a11ae6c5c062dc7c0a33

--
-- AUTO_INCREMENT de tabela `user_settings`
--
ALTER TABLE `user_settings`
<<<<<<< HEAD
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
=======
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
>>>>>>> 909e0a58ea37757439a1a11ae6c5c062dc7c0a33

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `conversations`
--
ALTER TABLE `conversations`
  ADD CONSTRAINT `conversations_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `messages`
--
ALTER TABLE `messages`
  ADD CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`conversation_id`) REFERENCES `conversations` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `sessions`
--
ALTER TABLE `sessions`
  ADD CONSTRAINT `sessions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `user_settings`
--
ALTER TABLE `user_settings`
  ADD CONSTRAINT `user_settings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
