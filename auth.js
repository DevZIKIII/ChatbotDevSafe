// URL da API
const API_URL = './api.php?action=';

// Alternar entre tabs
function switchTab(tab) {
    // Atualizar botões
    document.querySelectorAll('.tab-btn').forEach(btn => {
        btn.classList.remove('active');
    });
    
    event.target.classList.add('active');
    
    // Atualizar conteúdo
    document.querySelectorAll('.tab-content').forEach(content => {
        content.classList.remove('active');
    });
    document.getElementById(`${tab}Tab`).classList.add('active');
    
    // Limpar formulários
    document.querySelectorAll('form').forEach(form => form.reset());
    document.querySelectorAll('.error-message').forEach(err => {
        err.classList.remove('active');
        err.textContent = '';
    });
}

// Mostrar/esconder senha
function togglePassword(inputId) {
    const input = document.getElementById(inputId);
    const button = input.nextElementSibling;
    
    if (input.type === 'password') {
        input.type = 'text';
        button.textContent = '🙈';
    } else {
        input.type = 'password';
        button.textContent = '👁️';
    }
}

// Função de Alerta com SweetAlert2
function showAlert(message, type = 'error') {
    const icon = type === 'success' ? 'success' : 'error';
    const title = type === 'success' ? 'Sucesso!' : 'Erro!';

    Swal.fire({
        icon: icon,
        title: title,
        text: message,
        customClass: {
            popup: 'swal-custom-style' // Usando a classe do main.css
        },
        timer: type === 'success' ? 2000 : 3000,
        timerProgressBar: true,
        showConfirmButton: false
    });
}

// Validar email
function validateEmail(email) {
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}

// Validar força da senha
function validatePasswordStrength(password) {
    if (password.length < 8) {
        return 'A senha deve ter pelo menos 8 caracteres';
    }
    // Outras validações podem ser adicionadas aqui se desejar
    return null;
}

// Mostrar erro em campo específico
function showError(fieldId, message) {
    const errorElement = document.getElementById(fieldId);
    if (errorElement) {
        errorElement.textContent = message;
        errorElement.classList.add('active');
    }
}

// Lidar com login
async function handleLogin(event) {
    event.preventDefault();
    
    const email = document.getElementById('loginEmail').value;
    const password = document.getElementById('loginPassword').value;
    const button = document.getElementById('loginBtn');
    
    // Validações
    if (!validateEmail(email)) {
        showError('loginEmailError', 'Email inválido');
        return;
    }
    
    button.disabled = true;
    button.classList.add('loading');
    button.textContent = '';
    
    try {
        const response = await fetch(`${API_URL}login`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ email, password })
        });
        
        const data = await response.json();
        
        if (data.success) {
            localStorage.setItem('devbot_token', data.token);
            localStorage.setItem('devbot_user', JSON.stringify(data.user));
            if (data.settings) {
                localStorage.setItem('devbotConfig', JSON.stringify(data.settings));
            }
            showAlert('Login bem-sucedido!', 'success');
            setTimeout(() => { window.location.href = './index.html'; }, 1500);
        } else {
            showAlert(data.message || 'Erro ao fazer login');
        }
    } catch (error) {
        showAlert('Erro de conexão. Tente novamente.');
    } finally {
        button.disabled = false;
        button.classList.remove('loading');
        button.textContent = 'Entrar na conta';
    }
}

// Lidar com registro
async function handleRegister(event) {
    event.preventDefault();
    
    const username = document.getElementById('registerUsername').value;
    const email = document.getElementById('registerEmail').value;
    const password = document.getElementById('registerPassword').value;
    const confirmPassword = document.getElementById('confirmPassword').value;
    const button = document.getElementById('registerBtn');
    
    document.querySelectorAll('.error-message').forEach(err => {
        err.textContent = '';
        err.classList.remove('active');
    });
    
    if (!validateEmail(email)) {
        showError('registerEmailError', 'Email inválido');
        return;
    }
    
    const passwordError = validatePasswordStrength(password);
    if (passwordError) {
        showError('registerPasswordError', passwordError);
        return;
    }
    
    if (password !== confirmPassword) {
        showError('confirmPasswordError', 'As senhas não coincidem');
        return;
    }
    
    button.disabled = true;
    button.classList.add('loading');
    button.textContent = '';
    
    try {
        const response = await fetch(`${API_URL}register`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ username, email, password })
        });
        
        const data = await response.json();
        
        if (data.success) {
            localStorage.setItem('devbot_token', data.token);
            localStorage.setItem('devbot_user', JSON.stringify(data.user));
            showAlert('Conta criada com sucesso!', 'success');
            setTimeout(() => { window.location.href = './index.html'; }, 1500);
        } else {
            showAlert(data.message || 'Erro ao criar conta');
        }
    } catch (error) {
        showAlert('Erro de conexão. Tente novamente.');
    } finally {
        button.disabled = false;
        button.classList.remove('loading');
        button.textContent = 'Criar conta gratuita';
    }
}

// Verificar se já está logado ao carregar a página
window.addEventListener('DOMContentLoaded', () => {
    const token = localStorage.getItem('devbot_token');
    if (token) {
        window.location.href = './index.html';
    }
});