// Configurações do sistema
let config = {
    apiKey: '',
    systemPrompt: `Você é o DevBot 🤖, um assistente de IA especializado em ensinar programação para estudantes do ensino médio (16 anos) em um curso técnico de Desenvolvimento de Sistemas.

                PERSONALIDADE & TOM:
                - Seja entusiasmado, amigável e encorajador
                - Use emojis e linguagem jovem (mas não exagerada)
                - Celebre pequenas vitórias e progressos
                - Torne conceitos complexos simples e divertidos
                - Use analogias do dia a dia (jogos, redes sociais, etc.)

                ABORDAGEM EDUCACIONAL:
                - Sempre explique "por que" algo funciona, não apenas "como"
                - Use exemplos práticos e relevantes para adolescentes
                - Divida conceitos complexos em passos pequenos
                - Incentive experimentação e curiosidade
                - Conecte programação com coisas que eles conhecem

                EXPERTISE TÉCNICA:
                - JavaScript, Python, HTML/CSS (foco em web)
                - Conceitos básicos: variáveis, funções, loops, condicionais
                - APIs e integração (explique de forma simples)
                - Projetos práticos e divertidos

                FORMATO DE RESPOSTA:
                - Use markdown com código bem formatado
                - Inclua comentários explicativos no código
                - Sugira "próximos passos" ou desafios
                - Termine com perguntas para manter o engajamento

                DICAS ESPECIAIS:
                - Se perguntarem sobre APIs, use analogias (garçom/restaurante, etc.)
                - Para conceitos abstratos, use metáforas visuais
                - Sempre mostre aplicações práticas e legais
                - Incentive a criatividade e projetos pessoais

                Lembre-se: você está criando futuros desenvolvedores! Seja inspirador! ✨`,
    temperature: 0.7,
    maxTokens: 2048,
    model: 'gemini-2.0-flash' // Modelo atualizado
};

const API_URL = './api.php?action=';
let authToken = localStorage.getItem('devbot_token');
let currentUser = JSON.parse(localStorage.getItem('devbot_user') || 'null');
let currentConversationID = null;
let conversationHistory = [];
let conversationToDelete = null;
let isFirstVisit = true;
let attachedFiles = [];
const MAX_FILES = 4;

const suggestionChips = [
    "Explique o que é uma API como se eu tivesse 5 anos 🍕",
    "Me mostre um código Python para 'Hello, World!' 👋",
    "Como criar um site simples com HTML? 🌐",
    "O que é JavaScript e para que serve? ⚡",
    "Crie um nome criativo para um app de jogos 🎮",
    "Como funciona um banco de dados? 🗄️"
];

document.addEventListener('keydown', (event) => {
    // Verifica se a tecla Ctrl (ou Command no Mac) está pressionada
    if (event.ctrlKey || event.metaKey) {
        switch (event.key.toLowerCase()) {
            // Atalho para Deletar Conversa (Ctrl + D)
            case 'd':
                event.preventDefault(); // Impede a ação padrão do navegador (ex: adicionar aos favoritos)
                if (currentConversationID) {
                    showDeleteConfirm(currentConversationID);
                } else {
                    showInfoAlert('Nenhuma conversa selecionada para excluir.');
                }
                break;

            // Atalho para Sair (Logout) (Ctrl + Q)
            case 'q':
                event.preventDefault(); // Impede a ação padrão do navegador (ex: fechar aba/janela)
                showLogoutConfirm();
                break;
        }
    }
});

document.addEventListener('DOMContentLoaded', () => {
    if (!authToken || !currentUser) {
        window.location.href = './login.html';
        return;
    }
    loadConfig();
    showUserInfo();
    if (!config.apiKey) {
        document.getElementById('apiModal').classList.add('active');
    } else {
        document.getElementById('messageInput').focus();
    }
    loadUserConversations();
    if (isFirstVisit) {
        showWelcomeScreen();
    }
    createNeuralBackground();
    addEasterEggListeners();
    document.getElementById('fileInput').addEventListener('change', handleFileSelection);
});

// --- LÓGICA DE ANEXO DE ARQUIVOS ---
function handleFileSelection(event) {
    const files = event.target.files;
    if (!files.length) return;
    if (attachedFiles.length + files.length > MAX_FILES) {
        showErrorAlert(`Você pode anexar no máximo ${MAX_FILES} arquivos.`);
        event.target.value = '';
        return;
    }
    for (const file of files) {
        if (file.size > 2 * 1024 * 1024) {
            showErrorAlert(`O arquivo "${file.name}" é muito grande! (Máx 2MB)`);
            continue;
        }
        const allowedExtensions = ['.txt', '.js', '.py', '.html', '.css', '.json', '.md'];
        const fileExtension = '.' + file.name.split('.').pop().toLowerCase();
        if (!allowedExtensions.includes(fileExtension)) {
            showErrorAlert(`Tipo de arquivo não suportado para "${file.name}".`);
            continue;
        }
        if (attachedFiles.some(f => f.name === file.name)) {
            showWarningAlert(`O arquivo "${file.name}" já foi anexado.`);
            continue;
        }
        attachedFiles.push(file);
    }
    updateAttachedFilesUI();
    event.target.value = '';
    document.getElementById('messageInput').focus();
}

function updateAttachedFilesUI() {
    const listContainer = document.getElementById('attachedFilesList');
    listContainer.innerHTML = '';
    if (attachedFiles.length === 0) {
        listContainer.style.display = 'none';
        return;
    }
    listContainer.style.display = 'flex';
    attachedFiles.forEach(file => {
        const fileItem = document.createElement('div');
        fileItem.className = 'attached-file-item';
        fileItem.innerHTML = `
            <span class="attached-file-name">${file.name}</span>
            <button class="remove-file-btn" onclick="removeAttachedFile('${file.name}')">✖</button>
        `;
        listContainer.appendChild(fileItem);
    });
}

function removeAttachedFile(fileName) {
    attachedFiles = attachedFiles.filter(file => file.name !== fileName);
    updateAttachedFilesUI();
    document.getElementById('messageInput').focus();
}

// --- LÓGICA PRINCIPAL DO CHAT ---

async function sendMessage() {
    const input = document.getElementById('messageInput');
    const sendButton = document.getElementById('sendButton');
    let message = input.value.trim();
    if (!message && attachedFiles.length === 0) return;

    let userDisplayMessage = message;
    if (attachedFiles.length > 0) {
        const fileNames = attachedFiles.map(f => f.name).join(', ');
        userDisplayMessage += `\n\n*Arquivos Anexados: ${fileNames}*`;
    }
    if (!currentConversationID) {
        currentConversationID = await createConversation(userDisplayMessage);
        if (!currentConversationID) {
            showErrorAlert('Erro ao criar a conversa. Tente novamente.');
            return;
        }
    }

    addMessage(userDisplayMessage, true, false); // Mensagem do usuário é instantânea
    conversationHistory.push({ role: 'user', content: userDisplayMessage });
    await saveMessageToDatabase('user', userDisplayMessage);

    input.value = '';
    input.style.height = 'auto';
    sendButton.disabled = true;
    showTypingIndicator();

    try {
        const response = await callGeminiAPIWithFiles(message, attachedFiles);
        hideTypingIndicator();
        addMessage(response, false, true); // Resposta do bot usa o efeito de digitação
        conversationHistory.push({ role: 'model', content: response });
        await saveMessageToDatabase('assistant', response);
        await loadUserConversations();
    } catch (error) {
        hideTypingIndicator();
        showErrorAlert('❌ Oops! ' + error.message);
    } finally {
        sendButton.disabled = false;
        input.focus();
        attachedFiles = [];
        updateAttachedFilesUI();
    }
}

// CORRIGIDO: Função de digitação com rolagem suave e sem trepidação
function typeMessage(element, text) {
    let i = 0;
    element.innerHTML = "";
    element.classList.add('typewriter');
    const messagesContainer = document.getElementById('chatMessages');

    const interval = setInterval(() => {
        if (i < text.length) {
            element.innerHTML = processMessageContent(text.substring(0, i + 1));
            // A rolagem agora é direta, o que evita o "tremor"
            messagesContainer.scrollTop = messagesContainer.scrollHeight;
            i++;
        } else {
            clearInterval(interval);
            element.classList.remove('typewriter');
            // Garante que a rolagem final seja perfeita
            messagesContainer.scrollTop = messagesContainer.scrollHeight;
        }
    }, 20); // Velocidade da digitação (em milissegundos)
}


// ATUALIZADO: addMessage agora suporta 'isTyping'
function addMessage(content, isUser = false, isTyping = false) {
    const welcomeScreen = document.querySelector('.welcome-screen');
    if (welcomeScreen) welcomeScreen.remove();
    isFirstVisit = false;

    const messagesContainer = document.getElementById('chatMessages');
    const messageDiv = document.createElement('div');
    messageDiv.className = `message ${isUser ? 'user' : 'bot'}`;
    const author = isUser ? (currentUser.username || 'Você') : 'DevBot';
    const avatarSrc = isUser ? 'assets/avatar_user.png' : 'assets/avatar_bot.png';
    const avatarAlt = isUser ? 'Avatar do Usuário' : 'Avatar do DevBot';

    messageDiv.innerHTML = `
        <div class="message-avatar"><img src="${avatarSrc}" alt="${avatarAlt}"></div>
        <div class="message-content">
            <div class="message-header">
                <span>${author}</span><span>•</span><span>${getCurrentTime()}</span>
            </div>
            <div class="message-text"></div>
        </div>
    `;
    const messageTextElement = messageDiv.querySelector('.message-text');

    if (isTyping && !isUser) {
        typeMessage(messageTextElement, content);
    } else {
        messageTextElement.innerHTML = processMessageContent(content);
    }

    messagesContainer.appendChild(messageDiv);
    messagesContainer.scrollTop = messagesContainer.scrollHeight;
}


// ATUALIZADO: loadConversationFromDB agora carrega mensagens sem o efeito de digitação
async function loadConversationFromDB(conversationId) {
    try {
        const response = await fetch(`${API_URL}get_messages&conversation_id=${conversationId}`, { headers: { 'Authorization': `Bearer ${authToken}` } });
        const data = await response.json();
        if (data.success && data.messages) {
            currentConversationID = conversationId;
            conversationHistory = [];
            document.getElementById('chatMessages').innerHTML = '';
            data.messages.forEach(msg => {
                if (msg.role !== 'system') {
                    // Carrega mensagens antigas sem o efeito (isTyping = false)
                    addMessage(msg.content, msg.role === 'user', false);
                    conversationHistory.push({ role: msg.role === 'assistant' ? 'model' : msg.role, content: msg.content });
                }
            });
        }
    } catch (error) {
        console.error('Erro ao carregar conversa:', error);
    }
}


// --- Restante do código (sem alterações) ---

async function callGeminiAPIWithFiles(message, files) {
    if (!config.apiKey) {
        throw new Error('API Key não configurada. Clique em Configurações para adicionar sua chave.');
    }
    const url = `https://generativelanguage.googleapis.com/v1beta/models/${config.model}:generateContent?key=${config.apiKey}`;
    const contents = [];
    if (conversationHistory.length === 1 && config.systemPrompt) { // Apenas na primeira mensagem
        contents.push({ role: "user", parts: [{ text: config.systemPrompt }] });
        contents.push({ role: "model", parts: [{ text: "Entendido. Estou pronto para ajudar com desenvolvimento e programação." }] });
    }
    const historyForAPI = conversationHistory.slice(0, -1).map(msg => {
        let cleanContent = msg.content.replace(/\n\n\*Arquivos Anexados:.*\*$/s, '').trim();
        return { role: msg.role, parts: [{ text: cleanContent }] };
    });
    contents.push(...historyForAPI);
    const userParts = [];
    if (message) {
        userParts.push({ text: message });
    }
    if (files && files.length > 0) {
        for (const file of files) {
            const fileContent = await readFileContent(file);
            userParts.push({ text: `O usuário enviou um arquivo chamado "${file.name}" com o seguinte conteúdo:\n\`\`\`${file.name.split('.').pop()}\n${fileContent}\n\`\`\`` });
        }
    }
    contents.push({ role: 'user', parts: userParts });
    const requestBody = { contents, generationConfig: { temperature: config.temperature, maxOutputTokens: config.maxTokens } };
    try {
        const response = await fetch(url, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(requestBody) });
        const data = await response.json();
        if (!response.ok) {
            throw new Error(data.error?.message || 'Erro ao chamar a API do Gemini');
        }
        return data.candidates[0].content.parts[0].text;
    } catch (error) {
        throw error;
    }
}

function readFileContent(file) {
    return new Promise((resolve, reject) => {
        const reader = new FileReader();
        reader.onload = (event) => resolve(event.target.result);
        reader.onerror = (error) => reject(error);
        reader.readAsText(file);
    });
}

function createNeuralBackground() {
    const neuralBg = document.createElement('div');
    neuralBg.className = 'neural-bg';
    document.body.appendChild(neuralBg);
    for (let i = 0; i < 20; i++) {
        const node = document.createElement('div');
        node.className = 'neural-node';
        node.style.left = Math.random() * 100 + '%';
        node.style.top = Math.random() * 100 + '%';
        node.style.animationDelay = Math.random() * 6 + 's';
        neuralBg.appendChild(node);
    }
}

function showWelcomeScreen() {
    const messagesContainer = document.getElementById('chatMessages');
    messagesContainer.innerHTML = `<div class="welcome-screen">
            <h1 class="welcome-title">Bem-vindo ao DevBot! 🚀</h1>
            <p class="welcome-subtitle">
                Seu assistente pessoal para aprender programação de forma divertida e descomplicada! 
                Clique em uma das sugestões abaixo ou digite sua própria pergunta.
            </p>
            <div class="suggestion-chips">
                ${suggestionChips.map(chip => `
                    <div class="suggestion-chip" onclick="selectSuggestion('${chip.replace(/'/g, "\\'")}')">
                        ${chip}
                    </div>
                `).join('')}
            </div>
        </div>`;
}

function selectSuggestion(suggestion) {
    document.getElementById('messageInput').value = suggestion;
    setTimeout(() => sendMessage(), 300);
}

function addEasterEggListeners() { /* ... */ }
function activateSecretMode() { /* ... */ }
function createCelebrationParticles() { /* ... */ }
function toggleDeveloperMode() { /* ... */ }
function showLogoutConfirm() { document.getElementById('logoutModal').classList.add('active'); }
function cancelLogout() { document.getElementById('logoutModal').classList.remove('active'); }
async function confirmLogout() {
    localStorage.clear();
    window.location.href = './login.html';
}
async function createConversation(firstMessage) {
    try {
        const response = await fetch(`${API_URL}create_conversation`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json', 'Authorization': `Bearer ${authToken}` },
            body: JSON.stringify({ first_message: firstMessage, api_key: config.apiKey })
        });
        const data = await response.json();
        return data.success ? data.conversation_id : null;
    } catch (error) { console.error(error); return null; }
}
async function saveMessageToDatabase(role, content) {
    if (!currentConversationID) return;
    try {
        await fetch(`${API_URL}save_message`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json', 'Authorization': `Bearer ${authToken}` },
            body: JSON.stringify({ conversation_id: currentConversationID, role, content })
        });
    } catch (error) { console.error(error); }
}
async function loadUserConversations() {
    try {
        const response = await fetch(`${API_URL}get_conversations`, { headers: { 'Authorization': `Bearer ${authToken}` } });
        const data = await response.json();
        if (data.success) updateHistoryUIFromDatabase(data.conversations);
    } catch (error) { console.error(error); }
}

function updateHistoryUIFromDatabase(conversations) {
    const historyContainer = document.getElementById('chatHistory');
    if (!conversations || conversations.length === 0) {
        historyContainer.innerHTML = '<div class="history-item">Nenhuma conversa</div>';
        return;
    }
    historyContainer.innerHTML = conversations.map(conv => `
        <div class="history-item" onclick="loadConversationFromDB(${conv.id})" title="${conv.title}">
            <img src="assets/icon_chat.png" alt="Icone da Conversa" class="history-item-icon">
            <span>${conv.title}</span>
            <button class="delete-btn" onclick="event.stopPropagation(); showDeleteConfirm(${conv.id})">🗑️</button>
        </div>
    `).join('');
}

function showDeleteConfirm(conversationId) {
    conversationToDelete = conversationId;
    document.getElementById('confirmModal').classList.add('active');
}
function cancelDelete() {
    conversationToDelete = null;
    document.getElementById('confirmModal').classList.remove('active');
}
async function confirmDelete() {
    if (!conversationToDelete) return;

    try {
        const response = await fetch(`${API_URL}delete_conversation&conversation_id=${conversationToDelete}`, {
            method: 'DELETE', // Usar o método DELETE é uma boa prática para exclusão
            headers: {
                'Authorization': `Bearer ${authToken}`
            }
        });

        const data = await response.json();

        if (data.success) {
            Swal.fire({
                icon: 'success',
                title: 'Excluído!',
                text: 'A conversa foi removida.',
                customClass: { popup: 'swal-custom-style' },
                timer: 1500,
                showConfirmButton: false
            });

            // Se a conversa excluída era a que estava aberta, limpa a tela
            if (currentConversationID === conversationToDelete) {
                newChat();
            }
            
            await loadUserConversations(); // Recarrega a lista de conversas

        } else {
            showErrorAlert(data.message || 'Não foi possível excluir a conversa.');
        }

    } catch (error) {
        console.error('Erro ao deletar conversa:', error);
        showErrorAlert('Ocorreu um erro de conexão ao tentar excluir.');
    } finally {
        // Independentemente do resultado, fecha o modal e reseta a variável
        cancelDelete();
    }
}
function showUserInfo() {
    const userInfoElement = document.getElementById('userInfo');
    if (currentUser && userInfoElement) {
        userInfoElement.innerHTML = `<img src="assets/avatar_user.png" alt="User Avatar" class="user-avatar"><span class="username">${currentUser.username}</span>`;
    }
}
function loadConfig() {
    const saved = localStorage.getItem('devbotConfig');
    if (saved) config = { ...config, ...JSON.parse(saved) };
}
function saveApiKey() {
    config.apiKey = document.getElementById('apiKeyInput').value.trim();
    if (!config.apiKey) {
        showErrorAlert('Por favor, insira uma API Key válida.');
        return;
    }
    localStorage.setItem('devbotConfig', JSON.stringify(config));
    document.getElementById('apiModal').classList.remove('active');
    document.getElementById('messageInput').focus();
}
function skipApiKey() { document.getElementById('apiModal').classList.remove('active'); }
function openSettings() {
    document.getElementById('apiModal').classList.add('active');
    document.getElementById('apiKeyInput').value = config.apiKey;
}
function newChat() {
    currentConversationID = null;
    isFirstVisit = false;
    conversationHistory = [];
    showWelcomeScreen();
    loadUserConversations();
}
function adjustTextareaHeight(textarea) {
    textarea.style.height = 'auto';
    textarea.style.height = Math.min(textarea.scrollHeight, 120) + 'px';
}
function handleKeyPress(event) {
    if (event.key === 'Enter' && !event.shiftKey) {
        event.preventDefault();
        sendMessage();
    }
}
function getCurrentTime() {
    return new Date().toLocaleTimeString('pt-BR', { hour: '2-digit', minute: '2-digit' });
}
function processMessageContent(content) {
    let processed = content.replace(/</g, '&lt;').replace(/>/g, '&gt;');
    processed = processed.replace(/```(\w+)?\n([\s\S]*?)```/g, (match, lang, code) => `<pre><button class="copy-btn" onclick="copyCode(this)">Copiar</button><code class="language-${lang || 'plaintext'}">${code.replace(/</g, '&lt;').replace(/>/g, '&gt;')}</code></pre>`);
    processed = processed.replace(/`([^`]+)`/g, '<code>$1</code>');
    processed = processed.replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>');
    processed = processed.replace(/\*(.*?)\*/g, '<em>$1</em>');
    return processed.replace(/\n/g, '<br>');
}
function copyCode(button) {
    const code = button.nextElementSibling.innerText;
    navigator.clipboard.writeText(code).then(() => {
        button.innerHTML = '✅ Copiado!';
        setTimeout(() => { button.innerHTML = 'Copiar'; }, 2000);
    });
}
function showTypingIndicator() {
    const thinkingDiv = document.getElementById('thinkingIndicator');
    if (thinkingDiv) {
        thinkingDiv.classList.add('active');
    }
}

function hideTypingIndicator() {
    const thinkingDiv = document.getElementById('thinkingIndicator');
    if (thinkingDiv) {
        thinkingDiv.classList.remove('active');
    }
}
function showErrorAlert(message) { Swal.fire({ icon: 'error', title: 'Oops...', text: message, customClass: { popup: 'swal-custom-style' } }); }
function showWarningAlert(message) { Swal.fire({ icon: 'warning', title: 'Atenção', text: message, customClass: { popup: 'swal-custom-style' } }); }
function showInfoAlert(message) { Swal.fire({ icon: 'info', title: 'Informação', text: message, customClass: { popup: 'swal-custom-style' } }); }
function closeApiModal() { document.getElementById('apiModal').classList.remove('active'); }
