<?php

// Incluir configuração
require_once 'config.php';

// Definir headers CORS
setCORSHeaders();

// Pegar método e ação
$method = $_SERVER['REQUEST_METHOD'];
$action = $_GET['action'] ?? '';

// Pegar dados do POST
$input = json_decode(file_get_contents('php://input'), true);

// Conectar ao banco
$db = getConnection();

// Roteamento baseado na ação
switch($action) {
    
    case 'register':
        handleRegister($db, $input);
        break;
        
    case 'login':
        handleLogin($db, $input);
        break;
        
    case 'save_message':
        handleSaveMessage($db, $input);
        break;
        
    case 'get_conversations':
        handleGetConversations($db);
        break;
        
    case 'get_messages':
        handleGetMessages($db);
        break;
        
    case 'create_conversation':
        handleCreateConversation($db, $input);
        break;

    case 'delete_conversation':
        handleDeleteConversation($db);
        break;

    case 'logout':
        handleLogout($db);
        break;
    
    case 'check_session':
        handleCheckSession($db);
        break;
        
    default:
        echo json_encode(['error' => 'Ação não encontrada']);
}

// =============== FUNÇÕES DE MANIPULAÇÃO ===============

// Registrar novo usuário
function handleRegister($db, $data) {
    try {
        // Validar dados
        if (!isset($data['username']) || !isset($data['email']) || !isset($data['password'])) {
            echo json_encode(['success' => false, 'message' => 'Dados incompletos']);
            return;
        }
        
        $username = trim($data['username']);
        $email = trim($data['email']);
        $password = $data['password'];
        
        // Verificar se email já existe
        $stmt = $db->prepare("SELECT id FROM users WHERE email = ? OR username = ?");
        $stmt->execute([$email, $username]);
        
        if ($stmt->rowCount() > 0) {
            echo json_encode(['success' => false, 'message' => 'Email ou usuário já cadastrado']);
            return;
        }
        
        // Criar hash da senha
        $password_hash = password_hash($password, PASSWORD_DEFAULT);
        
        // Inserir usuário
        $stmt = $db->prepare("INSERT INTO users (username, email, password_hash) VALUES (?, ?, ?)");
        $stmt->execute([$username, $email, $password_hash]);
        
        $user_id = $db->lastInsertId();
        
        // Criar configurações padrão
        $stmt = $db->prepare("INSERT INTO user_settings (user_id) VALUES (?)");
        $stmt->execute([$user_id]);
        
        // Gerar token simples
        $token = generateToken($user_id);
        
        // Salvar sessão
        $expires = date('Y-m-d H:i:s', strtotime('+7 days'));
        $stmt = $db->prepare("INSERT INTO sessions (user_id, session_token, expires_at) VALUES (?, ?, ?)");
        $stmt->execute([$user_id, $token, $expires]);
        
        echo json_encode([
            'success' => true,
            'token' => $token,
            'user' => [
                'id' => $user_id,
                'username' => $username,
                'email' => $email
            ]
        ]);
        
    } catch(Exception $e) {
        echo json_encode(['success' => false, 'message' => 'Erro ao registrar: ' . $e->getMessage()]);
    }
}

// Fazer logout (invalidar sessão)
function handleLogout($db) {
    try {
        $token = getBearerToken();
        
        if ($token) {
            // Deletar a sessão do banco
            $stmt = $db->prepare("DELETE FROM sessions WHERE session_token = ?");
            $stmt->execute([$token]);
        }
        
        echo json_encode(['success' => true, 'message' => 'Logout realizado com sucesso']);
        
    } catch(Exception $e) {
        echo json_encode(['success' => false, 'message' => 'Erro ao fazer logout']);
    }
}

// Verificar se sessão ainda é válida
function handleCheckSession($db) {
    $token = getBearerToken();
    $user_id = getUserIdFromToken($db, $token);
    
    if ($user_id) {
        echo json_encode(['success' => true, 'valid' => true]);
    } else {
        http_response_code(401);
        echo json_encode(['success' => false, 'valid' => false]);
    }
}

function handleDeleteConversation($db) {
    try {
        // Log para debug
        error_log("Delete conversation called");
        
        $token = getBearerToken();
        error_log("Token: " . $token);
        
        $user_id = getUserIdFromToken($db, $token);
        error_log("User ID: " . $user_id);
        
        if (!$user_id) {
            echo json_encode(['success' => false, 'message' => 'Não autorizado - token inválido']);
            return;
        }
        
        $conversation_id = isset($_GET['conversation_id']) ? intval($_GET['conversation_id']) : 0;
        error_log("Conversation ID to delete: " . $conversation_id);
        
        if ($conversation_id <= 0) {
            echo json_encode(['success' => false, 'message' => 'ID de conversa inválido: ' . $conversation_id]);
            return;
        }
        
        // Verificar se existe
        $stmt = $db->prepare("SELECT id FROM conversations WHERE id = ? AND user_id = ?");
        $stmt->execute([$conversation_id, $user_id]);
        
        if ($stmt->rowCount() == 0) {
            echo json_encode(['success' => false, 'message' => 'Conversa não encontrada ou sem permissão']);
            return;
        }
        
        // Deletar
        $stmt = $db->prepare("DELETE FROM conversations WHERE id = ? AND user_id = ?");
        $result = $stmt->execute([$conversation_id, $user_id]);
        
        if ($result) {
            echo json_encode(['success' => true, 'message' => 'Conversa excluída com sucesso']);
        } else {
            echo json_encode(['success' => false, 'message' => 'Falha ao executar delete no banco']);
        }
        
    } catch(Exception $e) {
        error_log('Erro ao deletar: ' . $e->getMessage());
        echo json_encode(['success' => false, 'message' => 'Erro: ' . $e->getMessage()]);
    }
}

// Login
function handleLogin($db, $data) {
    try {
        if (!isset($data['email']) || !isset($data['password'])) {
            echo json_encode(['success' => false, 'message' => 'Dados incompletos']);
            return;
        }
        
        $email = trim($data['email']);
        $password = $data['password'];
        
        // Buscar usuário
        $stmt = $db->prepare("SELECT * FROM users WHERE email = ?");
        $stmt->execute([$email]);
        $user = $stmt->fetch();
        
        if (!$user || !password_verify($password, $user['password_hash'])) {
            echo json_encode(['success' => false, 'message' => 'Email ou senha incorretos']);
            return;
        }
        
        // Atualizar último login
        $stmt = $db->prepare("UPDATE users SET last_login = NOW() WHERE id = ?");
        $stmt->execute([$user['id']]);
        
        // Gerar token
        $token = generateToken($user['id']);
        
        // Salvar sessão
        $expires = date('Y-m-d H:i:s', strtotime('+7 days'));
        $stmt = $db->prepare("INSERT INTO sessions (user_id, session_token, expires_at) VALUES (?, ?, ?)");
        $stmt->execute([$user['id'], $token, $expires]);
        
        // Buscar configurações
        $stmt = $db->prepare("SELECT * FROM user_settings WHERE user_id = ?");
        $stmt->execute([$user['id']]);
        $settings = $stmt->fetch();
        
        echo json_encode([
            'success' => true,
            'token' => $token,
            'user' => [
                'id' => $user['id'],
                'username' => $user['username'],
                'email' => $user['email'],
                'api_key' => $user['api_key']
            ],
            'settings' => $settings
        ]);
        
    } catch(Exception $e) {
        echo json_encode(['success' => false, 'message' => 'Erro no login: ' . $e->getMessage()]);
    }
}

// Criar nova conversa
function handleCreateConversation($db, $data) {
    try {
        $token = getBearerToken();
        $user_id = getUserIdFromToken($db, $token);
        
        if (!$user_id) {
            echo json_encode(['success' => false, 'message' => 'Não autorizado']);
            return;
        }
        
        $first_message = $data['first_message'] ?? 'Nova conversa';
        $title = substr($first_message, 0, 50);
        
        // Inserir conversa
        $stmt = $db->prepare("INSERT INTO conversations (user_id, title) VALUES (?, ?)");
        $stmt->execute([$user_id, $title]);
        
        $conversation_id = $db->lastInsertId();
        
        $auto_title = generateSmartTitle($first_message, $data['api_key'] ?? null);
        if ($auto_title) {
            $stmt = $db->prepare("UPDATE conversations SET auto_title = ? WHERE id = ?");
            $stmt->execute([$auto_title, $conversation_id]);
        }
        
        echo json_encode([
            'success' => true,
            'conversation_id' => $conversation_id
        ]);
        
    } catch(Exception $e) {
        echo json_encode(['success' => false, 'message' => 'Erro: ' . $e->getMessage()]);
    }
}

// Salvar mensagem
function handleSaveMessage($db, $data) {
    try {
        $token = getBearerToken();
        $user_id = getUserIdFromToken($db, $token);
        
        if (!$user_id) {
            echo json_encode(['success' => false, 'message' => 'Não autorizado']);
            return;
        }
        
        $conversation_id = $data['conversation_id'];
        $role = $data['role'];
        $content = $data['content'];
        
        // Verificar se a conversa pertence ao usuário
        $stmt = $db->prepare("SELECT id FROM conversations WHERE id = ? AND user_id = ?");
        $stmt->execute([$conversation_id, $user_id]);
        
        if ($stmt->rowCount() == 0) {
            echo json_encode(['success' => false, 'message' => 'Conversa não encontrada']);
            return;
        }
        
        // Inserir mensagem
        $stmt = $db->prepare("INSERT INTO messages (conversation_id, role, content) VALUES (?, ?, ?)");
        $stmt->execute([$conversation_id, $role, $content]);
        
        // Atualizar timestamp da conversa
        $stmt = $db->prepare("UPDATE conversations SET updated_at = NOW() WHERE id = ?");
        $stmt->execute([$conversation_id]);
        
        echo json_encode(['success' => true, 'message_id' => $db->lastInsertId()]);
        
    } catch(Exception $e) {
        echo json_encode(['success' => false, 'message' => 'Erro: ' . $e->getMessage()]);
    }
}

// Buscar conversas do usuário
function handleGetConversations($db) {
    try {
        $token = getBearerToken();
        $user_id = getUserIdFromToken($db, $token);
        
        if (!$user_id) {
            echo json_encode(['success' => false, 'message' => 'Não autorizado']);
            return;
        }
        
        $stmt = $db->prepare("
            SELECT id, COALESCE(auto_title, title) as title, created_at, updated_at 
            FROM conversations 
            WHERE user_id = ? 
            ORDER BY updated_at DESC 
            LIMIT 20
        ");
        $stmt->execute([$user_id]);
        
        $conversations = $stmt->fetchAll();
        
        echo json_encode(['success' => true, 'conversations' => $conversations]);
        
    } catch(Exception $e) {
        echo json_encode(['success' => false, 'message' => 'Erro: ' . $e->getMessage()]);
    }
}

// Buscar mensagens de uma conversa
function handleGetMessages($db) {
    try {
        $token = getBearerToken();
        $user_id = getUserIdFromToken($db, $token);
        
        if (!$user_id) {
            echo json_encode(['success' => false, 'message' => 'Não autorizado']);
            return;
        }
        
        $conversation_id = $_GET['conversation_id'] ?? 0;
        
        // Verificar se a conversa pertence ao usuário
        $stmt = $db->prepare("SELECT id FROM conversations WHERE id = ? AND user_id = ?");
        $stmt->execute([$conversation_id, $user_id]);
        
        if ($stmt->rowCount() == 0) {
            echo json_encode(['success' => false, 'message' => 'Conversa não encontrada']);
            return;
        }
        
        // Buscar mensagens
        $stmt = $db->prepare("SELECT * FROM messages WHERE conversation_id = ? ORDER BY created_at ASC");
        $stmt->execute([$conversation_id]);
        
        $messages = $stmt->fetchAll();
        
        echo json_encode(['success' => true, 'messages' => $messages]);
        
    } catch(Exception $e) {
        echo json_encode(['success' => false, 'message' => 'Erro: ' . $e->getMessage()]);
    }
}

// =============== FUNÇÕES AUXILIARES ===============

// Gerar token simples
function generateToken($user_id) {
    return bin2hex(random_bytes(32));
}

// Pegar token do header
function getBearerToken() {
    $headers = getallheaders();
    if (isset($headers['Authorization'])) {
        $matches = [];
        if (preg_match('/Bearer\s+(.*)$/i', $headers['Authorization'], $matches)) {
            return $matches[1];
        }
    }
    return null;
}

// Verificar token e retornar user_id
function getUserIdFromToken($db, $token) {
    if (!$token) return null;
    
    $stmt = $db->prepare("
        SELECT user_id 
        FROM sessions 
        WHERE session_token = ? AND expires_at > NOW()
    ");
    $stmt->execute([$token]);
    
    $result = $stmt->fetch();
    return $result ? $result['user_id'] : null;
}

// Gerar título inteligente (simplificado)
function generateSmartTitle($message, $api_key = null) {
    // Por enquanto, apenas retorna os primeiros 50 caracteres
    // Você pode implementar a chamada para o Gemini aqui depois
    return substr($message, 0, 50) . (strlen($message) > 50 ? '...' : '');
}
?>