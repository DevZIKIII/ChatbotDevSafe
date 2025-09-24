# 🤖 DevBot - Seu Assistente de Código Pessoal

O **DevBot** é um chatbot inteligente projetado para ser o assistente definitivo para desenvolvedores. Construído com PHP e JavaScript puro, e potencializado pela API do Google Gemini, ele oferece uma interface limpa e eficiente para ajudar em tarefas de programação, desde a depuração de código até o aprendizado de novas tecnologias.

## ✨ Funcionalidades Principais

* **Interface de Chat Moderna:** Uma interface de usuário amigável e responsiva, inspirada em ambientes de desenvolvimento modernos.
* **Inteligência Artificial com Google Gemini:** Respostas rápidas e precisas para suas dúvidas de programação, utilizando os modelos mais recentes da Google AI.
* **Autenticação de Usuários:** Sistema seguro de cadastro e login para proteger suas conversas.
* **Histórico de Conversas:** Salve e revise suas conversas anteriores a qualquer momento, com tudo armazenado de forma segura no banco de dados.
* **Configuração Flexível:** Personalize o modelo de IA, a "temperatura" (criatividade) das respostas e outros parâmetros facilmente através de um arquivo de configuração.
* **Backend Robusto em PHP:** Um backend simples e eficiente que gerencia a lógica de usuários, sessões e mensagens.

## 🛠️ Tecnologias Utilizadas

* **Frontend:**
    * HTML5
    * CSS3 (Vanilla)
    * JavaScript (Vanilla JS)
* **Backend:**
    * PHP
* **Banco de Dados:**
    * MySQL
* **Inteligência Artificial:**
    * Google Gemini API

## 🚀 Como Executar o Projeto

Para colocar o DevBot em funcionamento na sua máquina local, siga os passos abaixo.

### Pré-requisitos

* Um ambiente de servidor local como [XAMPP](https://www.apachefriends.org/index.html) ou WAMP.
* [MySQL](https://www.mysql.com/) (geralmente incluído no XAMPP).
* Uma chave de API do [Google Gemini](https://aistudio.google.com/app/apikey).

### 1. Configuração do Backend e Banco de Dados

1.  **Clone o repositório:**
    ```bash
    git clone [https://github.com/seu-usuario/chatbotDev.git](https://github.com/seu-usuario/chatbotDev.git)
    ```

2.  **Mova os arquivos para o servidor local:**
    Copie todos os arquivos do projeto para a pasta `htdocs` do seu XAMPP. Exemplo: `C:\xampp\htdocs\devbot\`.

3.  **Crie o Banco de Dados:**
    * Abra o `phpMyAdmin` (geralmente acessível em `http://localhost/phpmyadmin`).
    * Crie um novo banco de dados chamado `devbot_db`.
    * Importe o script `database.sql` (você precisará criar este arquivo com a estrutura das suas tabelas `users`, `conversations`, `messages`, etc.) para criar as tabelas necessárias.

4.  **Configure a Conexão:**
    * Abra o arquivo `config.php`.
    * Verifique se as credenciais do banco de dados (`DB_HOST`, `DB_NAME`, `DB_USER`, `DB_PASS`) correspondem à sua configuração local do XAMPP. Por padrão, o usuário é `root` e a senha é vazia.

### 2. Configuração do Frontend

1.  **Acesse a Aplicação:**
    * Abra seu navegador e acesse `http://localhost/devbot/login.html`.

2.  **Crie uma Conta:**
    * Utilize a interface para criar uma nova conta de usuário.

3.  **Configure a API Key:**
    * Após o login, você será redirecionado para a página principal (`index.html`).
    * Um pop-up solicitará sua chave da API do Google Gemini. Insira sua chave para ativar o chatbot. Ela será salva localmente no seu navegador.

Pronto! Agora você pode começar a conversar com o DevBot.

## 📁 Estrutura do Projeto

/chatbotDev
├── .env                  # Arquivo de exemplo para configurações da API Gemini
├── api.php               # Endpoint principal da API backend
├── config.php            # Configurações do banco de dados e CORS
├── index.html            # Interface principal do chat
├── login.html            # Página de login e registro de usuários
└── README.md             # Este arquivo
