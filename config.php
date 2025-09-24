<?php

// Configurações do banco de dados
define('DB_HOST', 'localhost');
define('DB_NAME', 'devbot_db');
define('DB_USER', 'root');       // Usuário padrão do XAMPP
define('DB_PASS', '');           // Senha vazia no XAMPP por padrão

// Chave secreta para criptografia (mude isso em produção!)
define('SECRET_KEY', ''); // coloque uma chave forte aqui após o 'SECRET_KEY'

// Configurar timezone
date_default_timezone_set('America/Sao_Paulo');

// Função para conectar ao banco
function getConnection() {
    try {
        $conn = new PDO(
            "mysql:host=" . DB_HOST . ";dbname=" . DB_NAME . ";charset=utf8mb4",
            DB_USER,
            DB_PASS,
            [
                PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC
            ]
        );
        return $conn;
    } catch(PDOException $e) {
        // Em desenvolvimento, mostrar erro
        die("Erro de conexão: " . $e->getMessage());
    }
}

// Headers CORS para permitir requisições do frontend
function setCORSHeaders() {
    // Permitir requisições do localhost
    header('Access-Control-Allow-Origin: *');
    header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
    header('Access-Control-Allow-Headers: Content-Type, Authorization');
    header('Content-Type: application/json; charset=UTF-8');
    
    // Se for uma requisição OPTIONS, retornar apenas os headers
    if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
        http_response_code(200);
        exit();
    }
}

// Função para verificar se as tabelas existem
function checkDatabase() {
    $conn = getConnection();
    
    // Verificar se a tabela users existe
    $stmt = $conn->prepare("SHOW TABLES LIKE 'users'");
    $stmt->execute();
    
    if ($stmt->rowCount() == 0) {
        return [
            'success' => false,
            'message' => 'Banco de dados não configurado. Execute o script SQL primeiro.'
        ];
    }
    
    return ['success' => true];
}
?>