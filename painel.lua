
--==================================================
-- PAINEL DE PODERES + EDITOR DE AVATAR
-- PC E MOBILE | R15
-- Local: StarterPlayer > StarterPlayerScripts
-- Troca de skin sem animação de transformação
--==================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local avatarRemote = ReplicatedStorage:WaitForChild(
    "AvatarManagerFunction"
)

--==================================================
-- CONFIGURAÇÕES DOS PODERES
--==================================================

local velocidadeAtiva = false
local puloAtivo = false

local VELOCIDADE_NORMAL = 16
local VELOCIDADE_PODER = 50

local PULO_NORMAL = 7.2
local PULO_PODER = 30

--==================================================
-- CRIAR INTERFACE
--==================================================

local gui = Instance.new("ScreenGui")
gui.Name = "PainelDePoderes"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = false
gui.DisplayOrder = 10
gui.Parent = playerGui

local function arredondar(objeto, raio)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, raio)
    corner.Parent = objeto
end

local function criarBorda(objeto, cor, espessura)
    local stroke = Instance.new("UIStroke")
    stroke.Color = cor
    stroke.Thickness = espessura
    stroke.Parent = objeto
end

--==================================================
-- BOTÕES LATERAIS
--==================================================

local abrir = Instance.new("TextButton")
abrir.Name = "AbrirPainel"
abrir.Size = UDim2.fromOffset(52, 52)
abrir.Position = UDim2.new(0, 12, 0.42, 0)
abrir.BackgroundColor3 = Color3.fromRGB(35, 100, 220)
abrir.Text = "⚡"
abrir.TextScaled = true
abrir.TextColor3 = Color3.new(1, 1, 1)
abrir.Font = Enum.Font.GothamBold
abrir.Parent = gui
arredondar(abrir, 14)

local abrirAvatar = Instance.new("TextButton")
abrirAvatar.Name = "AbrirEditorAvatar"
abrirAvatar.Size = UDim2.fromOffset(100, 42)
abrirAvatar.Position = UDim2.new(0, 12, 0.42, 60)
abrirAvatar.BackgroundColor3 = Color3.fromRGB(120, 75, 200)
abrirAvatar.Text = "SKINS"
abrirAvatar.TextColor3 = Color3.new(1, 1, 1)
abrirAvatar.TextSize = 15
abrirAvatar.Font = Enum.Font.GothamBold
abrirAvatar.Parent = gui
arredondar(abrirAvatar, 10)

--==================================================
-- PAINEL DE PODERES RESPONSIVO
--==================================================

local painel = Instance.new("Frame")
painel.Name = "PainelPrincipal"
painel.AnchorPoint = Vector2.new(0.5, 0.5)
painel.Size = UDim2.new(0.84, 0, 0, 245)
painel.Position = UDim2.new(0.5, 0, 0.5, 0)
painel.BackgroundColor3 = Color3.fromRGB(24, 27, 40)
painel.BorderSizePixel = 0
painel.Visible = false
painel.Parent = gui
arredondar(painel, 14)

local limitePainel = Instance.new("UISizeConstraint")
limitePainel.MinSize = Vector2.new(250, 245)
limitePainel.MaxSize = Vector2.new(310, 245)
limitePainel.Parent = painel

criarBorda(painel, Color3.fromRGB(70, 120, 255), 2)

local titulo = Instance.new("TextLabel")
titulo.Size = UDim2.new(1, -55, 0, 45)
titulo.Position = UDim2.fromOffset(12, 0)
titulo.BackgroundTransparency = 1
titulo.Text = "PAINEL DE PODERES"
titulo.TextColor3 = Color3.new(1, 1, 1)
titulo.Font = Enum.Font.GothamBold
titulo.TextSize = 16
titulo.TextScaled = false
titulo.Parent = painel

local fechar = Instance.new("TextButton")
fechar.Size = UDim2.fromOffset(35, 35)
fechar.Position = UDim2.new(1, -40, 0, 5)
fechar.BackgroundColor3 = Color3.fromRGB(180, 55, 65)
fechar.Text = "X"
fechar.TextColor3 = Color3.new(1, 1, 1)
fechar.TextScaled = true
fechar.Font = Enum.Font.GothamBold
fechar.Parent = painel
arredondar(fechar, 8)

local function criarBotao(nome, texto, y, cor)
    local botao = Instance.new("TextButton")
    botao.Name = nome
    botao.Size = UDim2.new(1, -24, 0, 48)
    botao.Position = UDim2.fromOffset(12, y)
    botao.BackgroundColor3 = cor
    botao.Text = texto
    botao.TextColor3 = Color3.new(1, 1, 1)
    botao.TextSize = 14
    botao.TextWrapped = true
    botao.Font = Enum.Font.GothamBold
    botao.Parent = painel
    arredondar(botao, 9)
    return botao
end

local botaoPulo = criarBotao(
    "SuperPulo", "SUPERPULO: OFF", 55,
    Color3.fromRGB(115, 75, 200)
)

local botaoVelocidade = criarBotao(
    "SuperVelocidade", "SUPER VELOCIDADE: OFF", 112,
    Color3.fromRGB(35, 135, 180)
)

local botaoUniforme = criarBotao(
    "Uniforme", "VESTIR UNIFORME", 169,
    Color3.fromRGB(45, 145, 90)
)

abrir.Activated:Connect(function()
    painel.Visible = not painel.Visible
    if painel.Visible then
        editor.Visible = false
    end
end)

fechar.Activated:Connect(function()
    painel.Visible = false
end)

--==================================================
-- FUNCIONAMENTO DOS PODERES
--==================================================

local function atualizarPersonagem(character)
    local humanoid = character:WaitForChild("Humanoid")

    humanoid.UseJumpPower = true
    humanoid.WalkSpeed = velocidadeAtiva
        and VELOCIDADE_PODER or VELOCIDADE_NORMAL
    humanoid.JumpPower = puloAtivo
        and PULO_PODER or PULO_NORMAL
end

player.CharacterAdded:Connect(atualizarPersonagem)

if player.Character then
    task.spawn(atualizarPersonagem, player.Character)
end

botaoPulo.Activated:Connect(function()
    puloAtivo = not puloAtivo

    botaoPulo.Text = puloAtivo
        and "SUPERPULO: ON" or "SUPERPULO: OFF"

    if player.Character then
        local humanoid =
            player.Character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            humanoid.UseJumpPower = true
            humanoid.JumpPower = puloAtivo
                and PULO_PODER or PULO_NORMAL
        end
    end
end)

botaoVelocidade.Activated:Connect(function()
    velocidadeAtiva = not velocidadeAtiva

    botaoVelocidade.Text = velocidadeAtiva
        and "SUPER VELOCIDADE: ON"
        or "SUPER VELOCIDADE: OFF"

    if player.Character then
        local humanoid =
            player.Character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            humanoid.WalkSpeed = velocidadeAtiva
                and VELOCIDADE_PODER or VELOCIDADE_NORMAL
        end
    end
end)

botaoUniforme.Activated:Connect(function()
    botaoUniforme.Text = "FALTAM OS IDS!"
    task.delay(2, function()
        if botaoUniforme.Parent then
            botaoUniforme.Text = "VESTIR UNIFORME"
        end
    end)
end)

--==================================================
-- DADOS DO EDITOR DE AVATAR
--==================================================

local camposAvatar = {
    {"Shirt", "ID da camisa"},
    {"Pants", "ID da calça"},
    {"GraphicTShirt", "ID da camiseta estampada"},
    {"Face", "ID do rosto"},
    {"Head", "ID da cabeça"},
    {"Torso", "ID do torso"},
    {"LeftArm", "ID do braço esquerdo"},
    {"RightArm", "ID do braço direito"},
    {"LeftLeg", "ID da perna esquerda"},
    {"RightLeg", "ID da perna direita"},
    {"HairAccessory", "IDs dos cabelos, separados por vírgula"},
    {"HatAccessory", "IDs dos chapéus"},
    {"FaceAccessory", "IDs dos acessórios faciais"},
    {"NeckAccessory", "IDs dos acessórios do pescoço"},
    {"ShouldersAccessory", "IDs dos acessórios dos ombros"},
    {"FrontAccessory", "IDs dos acessórios frontais"},
    {"BackAccessory", "IDs dos acessórios das costas"},
    {"WaistAccessory", "IDs dos acessórios da cintura"},
    {"ShirtAccessory", "IDs das camisas em camadas"},
    {"JacketAccessory", "IDs das jaquetas"},
    {"SweaterAccessory", "IDs dos suéteres"},
    {"PantsAccessory", "IDs das calças em camadas"},
    {"ShortsAccessory", "IDs dos shorts"},
    {"LeftShoeAccessory", "ID do sapato esquerdo"},
    {"RightShoeAccessory", "ID do sapato direito"},
}

--==================================================
-- EDITOR RESPONSIVO
--==================================================

local editor = Instance.new("Frame")
editor.Name = "EditorAvatar"
editor.AnchorPoint = Vector2.new(0.5, 0.5)
editor.Size = UDim2.new(0.92, 0, 0.82, 0)
editor.Position = UDim2.new(0.5, 0, 0.5, 0)
editor.BackgroundColor3 = Color3.fromRGB(24, 27, 40)
editor.BorderSizePixel = 0
editor.Visible = false
editor.Parent = gui
arredondar(editor, 12)
criarBorda(editor, Color3.fromRGB(120, 75, 200), 2)

local limiteEditor = Instance.new("UISizeConstraint")
limiteEditor.MinSize = Vector2.new(280, 400)
limiteEditor.MaxSize = Vector2.new(440, 650)
limiteEditor.Parent = editor

local tituloAvatar = Instance.new("TextLabel")
tituloAvatar.Size = UDim2.new(1, -55, 0, 40)
tituloAvatar.Position = UDim2.fromOffset(10, 0)
tituloAvatar.BackgroundTransparency = 1
tituloAvatar.Text = "PERSONALIZADOR DE AVATAR"
tituloAvatar.TextColor3 = Color3.new(1, 1, 1)
tituloAvatar.TextSize = 14
tituloAvatar.Font = Enum.Font.GothamBold
tituloAvatar.Parent = editor

local fecharAvatar = Instance.new("TextButton")
fecharAvatar.Size = UDim2.fromOffset(35, 32)
fecharAvatar.Position = UDim2.new(1, -40, 0, 4)
fecharAvatar.Text = "X"
fecharAvatar.TextColor3 = Color3.new(1, 1, 1)
fecharAvatar.TextSize = 16
fecharAvatar.Font = Enum.Font.GothamBold
fecharAvatar.BackgroundColor3 = Color3.fromRGB(180, 55, 65)
fecharAvatar.Parent = editor
arredondar(fecharAvatar, 8)

abrirAvatar.Activated:Connect(function()
    editor.Visible = not editor.Visible
    if editor.Visible then
        painel.Visible = false
    end
end)

fecharAvatar.Activated:Connect(function()
    editor.Visible = false
end)

-- Lista rolável para caber na tela do celular
local lista = Instance.new("ScrollingFrame")
lista.Name = "ListaDeIDs"
lista.Position = UDim2.new(0, 10, 0, 45)
lista.Size = UDim2.new(1, -20, 0.47, 0)
lista.BackgroundColor3 = Color3.fromRGB(34, 37, 52)
lista.BorderSizePixel = 0
lista.ScrollBarThickness = 5
lista.AutomaticCanvasSize = Enum.AutomaticSize.Y
lista.CanvasSize = UDim2.new(0, 0, 0, 0)
lista.ScrollingDirection = Enum.ScrollingDirection.Y
lista.Parent = editor
arredondar(lista, 8)

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 5)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = lista

local paddingLista = Instance.new("UIPadding")
paddingLista.PaddingTop = UDim.new(0, 5)
paddingLista.PaddingBottom = UDim.new(0, 5)
paddingLista.PaddingLeft = UDim.new(0, 5)
paddingLista.PaddingRight = UDim.new(0, 5)
paddingLista.Parent = lista

local preenchimentos = {}

for i, info in ipairs(camposAvatar) do
    local nome, dica = info[1], info[2]

    local caixa = Instance.new("TextBox")
    caixa.Name = nome
    caixa.Size = UDim2.new(1, -5, 0, 38)
    caixa.BackgroundColor3 = Color3.fromRGB(48, 52, 70)
    caixa.TextColor3 = Color3.new(1, 1, 1)
    caixa.PlaceholderColor3 = Color3.fromRGB(180, 185, 200)
    caixa.PlaceholderText = dica
    caixa.Text = ""
    caixa.ClearTextOnFocus = false
    caixa.TextSize = 14
    caixa.Font = Enum.Font.Gotham
    caixa.LayoutOrder = i
    caixa.Parent = lista
    arredondar(caixa, 7)

    preenchimentos[nome] = caixa
end

--==================================================
-- BACKUP E STATUS
--==================================================

local codigo = Instance.new("TextBox")
codigo.Name = "CodigoBackup"
codigo.Position = UDim2.new(0, 10, 0.54, 0)
codigo.Size = UDim2.new(1, -20, 0, 58)
codigo.BackgroundColor3 = Color3.fromRGB(38, 41, 56)
codigo.TextColor3 = Color3.new(1, 1, 1)
codigo.PlaceholderText = "Cole ou gere seu código de backup aqui"
codigo.PlaceholderColor3 = Color3.fromRGB(180, 185, 200)
codigo.Text = ""
codigo.TextSize = 12
codigo.Font = Enum.Font.Code
codigo.TextWrapped = true
codigo.MultiLine = true
codigo.ClearTextOnFocus = false
codigo.TextXAlignment = Enum.TextXAlignment.Left
codigo.TextYAlignment = Enum.TextYAlignment.Top
codigo.Parent = editor
arredondar(codigo, 7)

local statusAvatar = Instance.new("TextLabel")
statusAvatar.Position = UDim2.new(0, 10, 0.54, 60)
statusAvatar.Size = UDim2.new(1, -20, 0, 34)
statusAvatar.BackgroundTransparency = 1
statusAvatar.Text = "Preencha os IDs desejados."
statusAvatar.TextColor3 = Color3.fromRGB(170, 200, 255)
statusAvatar.TextSize = 12
statusAvatar.TextWrapped = true
statusAvatar.Parent = editor

local function botaoAvatar(nome, texto, x, y, largura, cor)
    local b = Instance.new("TextButton")
    b.Name = nome
    b.Position = UDim2.new(x, 0, y, 0)
    b.Size = UDim2.new(largura, -5, 0, 35)
    b.BackgroundColor3 = cor
    b.Text = texto
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextSize = 11
    b.TextWrapped = true
    b.Font = Enum.Font.GothamBold
    b.Parent = editor
    arredondar(b, 7)
    return b
end

local aplicar = botaoAvatar(
    "AplicarSkin", "APLICAR IDs", 0.03, 0.78, 0.48,
    Color3.fromRGB(40, 135, 90)
)

local gerar = botaoAvatar(
    "GerarBackup", "GERAR CÓDIGO", 0.52, 0.78, 0.45,
    Color3.fromRGB(50, 100, 200)
)

local carregarCodigo = botaoAvatar(
    "CarregarCodigo", "CARREGAR CÓDIGO", 0.03, 0.88, 0.48,
    Color3.fromRGB(120, 75, 200)
)

local carregarSalva = botaoAvatar(
    "CarregarSalva", "MINHA SKIN SALVA", 0.52, 0.88, 0.45,
    Color3.fromRGB(65, 95, 120)
)

--==================================================
-- APLICAR E CARREGAR APARÊNCIA
--==================================================

local function obterDados()
    local dados = {}

    for nome, caixa in pairs(preenchimentos) do
        dados[nome] = caixa.Text:gsub("%s+", "")
    end

    return dados
end

local function preencherDados(dados)
    for nome, caixa in pairs(preenchimentos) do
        caixa.Text = tostring(dados[nome] or "")
    end
end

local function aplicarDados(dados)
    statusAvatar.Text = "Aplicando skin..."

    local ok, sucesso, mensagem = pcall(function()
        return avatarRemote:InvokeServer("Aplicar", dados)
    end)

    if ok and sucesso then
        statusAvatar.Text = mensagem or "Skin aplicada!"
    else
        statusAvatar.Text = ok
            and (mensagem or "Não foi possível aplicar.")
            or "Erro de conexão com o servidor."
    end
end

gerar.Activated:Connect(function()
    local dados = obterDados()
    local algumID = false

    for _, valor in pairs(dados) do
        if valor ~= "" then
            algumID = true
            break
        end
    end

    if not algumID then
        statusAvatar.Text = "Preencha pelo menos um ID."
        return
    end

    codigo.Text = HttpService:JSONEncode({
        versao = 1,
        avatar = dados
    })

    statusAvatar.Text = "Código gerado! Guarde o texto."
end)

carregarCodigo.Activated:Connect(function()
    local ok, resultado = pcall(function()
        return HttpService:JSONDecode(codigo.Text)
    end)

    if not ok or typeof(resultado) ~= "table"
        or resultado.versao ~= 1
        or typeof(resultado.avatar) ~= "table" then
        statusAvatar.Text = "Código inválido."
        return
    end

    local dados = resultado.avatar
    local permitidos = {}

    for _, info in ipairs(camposAvatar) do
        permitidos[info[1]] = true
    end

    for nome, valor in pairs(dados) do
        if not permitidos[nome] or typeof(valor) ~= "string" then
            statusAvatar.Text = "Código contém dados inválidos."
            return
        end
    end

    preencherDados(dados)
    aplicarDados(obterDados())
end)

aplicar.Activated:Connect(function()
    aplicarDados(obterDados())
end)

carregarSalva.Activated:Connect(function()
    statusAvatar.Text = "Buscando skin salva..."

    local ok, sucesso, dados, mensagem = pcall(function()
        return avatarRemote:InvokeServer("CarregarSalva")
    end)

    if not ok then
        statusAvatar.Text = "Erro ao consultar o servidor."
        return
    end

    if not sucesso or typeof(dados) ~= "table" then
        statusAvatar.Text = mensagem or "Nenhuma skin salva."
        return
    end

    preencherDados(dados)
    aplicarDados(obterDados())
end)

--==================================================
-- AJUSTE PARA TELAS PEQUENAS
--==================================================

local function ajustarTela()
    local camera = workspace.CurrentCamera
    if not camera then
        return
    end

    local tamanho = camera.ViewportSize
    local largura = tamanho.X
    local altura = tamanho.Y

    -- Em telas muito baixas, diminui a altura dos painéis.
    if altura < 500 then
        painel.Size = UDim2.new(0.84, 0, 0, 220)
        botaoPulo.Position = UDim2.fromOffset(12, 48)
        botaoVelocidade.Position = UDim2.fromOffset(12, 103)
        botaoUniforme.Position = UDim2.fromOffset(12, 158)
        botaoPulo.Size = UDim2.new(1, -24, 0, 45)
        botaoVelocidade.Size = UDim2.new(1, -24, 0, 45)
        botaoUniforme.Size = UDim2.new(1, -24, 0, 45)
    else
        painel.Size = UDim2.new(0.84, 0, 0, 245)
        botaoPulo.Position = UDim2.fromOffset(12, 55)
        botaoVelocidade.Position = UDim2.fromOffset(12, 112)
        botaoUniforme.Position = UDim2.fromOffset(12, 169)
        botaoPulo.Size = UDim2.new(1, -24, 0, 48)
        botaoVelocidade.Size = UDim2.new(1, -24, 0, 48)
        botaoUniforme.Size = UDim2.new(1, -24, 0, 48)
    end

    -- Evita painéis excessivamente largos em monitores grandes.
    if largura < 350 then
        abrir.Size = UDim2.fromOffset(46, 46)
        abrirAvatar.Size = UDim2.fromOffset(90, 38)
    else
        abrir.Size = UDim2.fromOffset(52, 52)
        abrirAvatar.Size = UDim2.fromOffset(100, 42)
    end
end

ajustarTela()

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(ajustarTela)

if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal(
        "ViewportSize"
    ):Connect(ajustarTela)
end



--==================================================
-- AVATAR SERVER - PERSONALIZADOR R15
-- Local: ServerScriptService > AvatarServer
-- Sem animação de transformação
--==================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")

local skinsStore = DataStoreService:GetDataStore("AvatarBackups_v2")

-- Criar ou reutilizar a comunicação com o painel
local remote = ReplicatedStorage:FindFirstChild("AvatarManagerFunction")

if not remote then
    remote = Instance.new("RemoteFunction")
    remote.Name = "AvatarManagerFunction"
    remote.Parent = ReplicatedStorage
end

-- Propriedades numéricas
local camposNumericos = {
    Shirt = true,
    Pants = true,
    GraphicTShirt = true,
    Face = true,
    Head = true,
    Torso = true,
    LeftArm = true,
    RightArm = true,
    LeftLeg = true,
    RightLeg = true,
}

-- Acessórios
local camposAcessorios = {
    "HairAccessory",
    "HatAccessory",
    "FaceAccessory",
    "NeckAccessory",
    "ShouldersAccessory",
    "FrontAccessory",
    "BackAccessory",
    "WaistAccessory",
    "ShirtAccessory",
    "JacketAccessory",
    "SweaterAccessory",
    "PantsAccessory",
    "ShortsAccessory",
    "LeftShoeAccessory",
    "RightShoeAccessory",
}

local camposPermitidos = {}

for campo in pairs(camposNumericos) do
    camposPermitidos[campo] = true
end

for _, campo in ipairs(camposAcessorios) do
    camposPermitidos[campo] = true
end

--==================================================
-- VALIDAR DADOS
--==================================================

local function validarDados(dados)
    if typeof(dados) ~= "table" then
        return false
    end

    for campo, valor in pairs(dados) do
        if not camposPermitidos[campo] then
            return false
        end

        if typeof(valor) ~= "string" or #valor > 2000 then
            return false
        end

        if valor ~= "" then
            if camposNumericos[campo] then
                if not valor:match("^%d+$") or #valor > 15 then
                    return false
                end
            else
                for id in valor:gmatch("[^,]+") do
                    id = id:match("^%s*(.-)%s*$")

                    if not id:match("^%d+$") or #id > 15 then
                        return false
                    end
                end
            end
        end
    end

    return true
end

--==================================================
-- APLICAR SKIN IMEDIATAMENTE
--==================================================

local function aplicarAparencia(player, dados)
    if not validarDados(dados) then
        return false, "IDs inválidos."
    end

    local character = player.Character
    if not character then
        return false, "Personagem não encontrado."
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then
        return false, "Personagem não está pronto."
    end

    local descricao
    local ok, erro = pcall(function()
        descricao = humanoid:GetAppliedDescription()

        for campo, valor in pairs(dados) do
            if valor ~= "" then
                if camposNumericos[campo] then
                    descricao[campo] = tonumber(valor)
                else
                    descricao[campo] = valor
                end
            end
        end

        humanoid:ApplyDescriptionAsync(descricao)
    end)

    if descricao then
        descricao:Destroy()
    end

    if not ok then
        warn("Erro ao aplicar skin:", erro)
        return false, "Falha ao aplicar a skin. Confira os IDs."
    end

    -- Salvar skin para próximas sessões
    local salvou, erroSave = pcall(function()
        skinsStore:SetAsync(tostring(player.UserId), dados)
    end)

    if not salvou then
        warn("Erro ao salvar skin:", erroSave)
        return true, "Skin aplicada, mas não foi possível salvá-la."
    end

    return true, "Skin aplicada e salva!"
end

--==================================================
-- CARREGAR SKIN SALVA
--==================================================

local function carregarSkinSalva(player)
    local ok, dados = pcall(function()
        return skinsStore:GetAsync(tostring(player.UserId))
    end)

    if not ok or not validarDados(dados) then
        return
    end

    local character = player.Character
    if not character then
        return
    end

    local humanoid = character:WaitForChild("Humanoid", 10)

    if not humanoid or player.Character ~= character then
        return
    end

    -- Não salvar novamente durante o carregamento automático
    local descricao
    local sucesso, erro = pcall(function()
        descricao = humanoid:GetAppliedDescription()

        for campo, valor in pairs(dados) do
            if valor ~= "" then
                if camposNumericos[campo] then
                    descricao[campo] = tonumber(valor)
                else
                    descricao[campo] = valor
                end
            end
        end

        humanoid:ApplyDescriptionAsync(descricao)
    end)

    if descricao then
        descricao:Destroy()
    end

    if not sucesso then
        warn("Erro ao carregar skin salva:", erro)
    end
end

--==================================================
-- CONFIGURAR JOGADORES
--==================================================

local function configurarJogador(player)
    player.CharacterAdded:Connect(function()
        task.wait(1)
        carregarSkinSalva(player)
    end)

    if player.Character then
        task.spawn(carregarSkinSalva, player)
    end
end

Players.PlayerAdded:Connect(configurarJogador)

for _, player in ipairs(Players:GetPlayers()) do
    configurarJogador(player)
end

--==================================================
-- COMUNICAÇÃO COM O PAINEL
--==================================================

remote.OnServerInvoke = function(player, acao, dados)
    if acao == "Aplicar" then
        -- Aplicação imediata, sem animação ou espera
        return aplicarAparencia(player, dados)

    elseif acao == "CarregarSalva" then
        local ok, salvo = pcall(function()
            return skinsStore:GetAsync(tostring(player.UserId))
        end)

        if ok and validarDados(salvo) then
            return true, salvo, "Skin salva encontrada."
        end

        return false, nil, "Nenhuma skin salva encontrada."
    end

    return false, "Ação desconhecida."
end

 
--==================================================
-- ANIMACOES PERSONALIZADAS R15
-- LocalScript em StarterPlayer > StarterCharacterScripts
--==================================================

local character = script.Parent
local humanoid = character:WaitForChild("Humanoid")
local animator = humanoid:WaitForChild("Animator")

-- IDs DAS ANIMACOES
local ID_PULO = "rbxassetid://74116059836265"
local ID_CORRIDA = "rbxassetid://130193757655135"

-- CONFIGURACOES
local FADE = 0.15
local VELOCIDADE_MINIMA = 0.5

-- CARREGAR ANIMACOES
local function carregarAnimacao(id, prioridade, loop)
    local animacao = Instance.new("Animation")
    animacao.AnimationId = id

    local sucesso, track = pcall(function()
        return animator:LoadAnimation(animacao)
    end)

    animacao:Destroy()

    if not sucesso then
        warn("Não foi possível carregar a animação:", id, track)
        return nil
    end

    track.Priority = prioridade
    track.Looped = loop

    return track
end

local pulo = carregarAnimacao(
    ID_PULO,
    Enum.AnimationPriority.Action,
    false
)

local corrida = carregarAnimacao(
    ID_CORRIDA,
    Enum.AnimationPriority.Movement,
    true
)

-- ESTADO DO PERSONAGEM
local estaNoAr = false
local personagemVivo = true

-- PARAR CORRIDA
local function pararCorrida()
    if corrida and corrida.IsPlaying then
        corrida:Stop(FADE)
    end
end

-- ATUALIZAR CORRIDA
local function atualizarCorrida()
    if not personagemVivo or estaNoAr
        or humanoid.Health <= 0 then
        pararCorrida()
        return
    end

    local estaMovendo =
        humanoid.MoveDirection.Magnitude > 0.05

    local velocidade =
        humanoid.MoveDirection.Magnitude * humanoid.WalkSpeed

    if estaMovendo and velocidade >= VELOCIDADE_MINIMA then
        if corrida and not corrida.IsPlaying then
            corrida:Play(FADE)
        end
    else
        pararCorrida()
    end
end

-- DETECTAR MOVIMENTO
humanoid.Running:Connect(function()
    atualizarCorrida()
end)

humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
    atualizarCorrida()
end)

-- DETECTAR PULO, QUEDA E ATERRISSAGEM
humanoid.StateChanged:Connect(function(_, novoEstado)
    if novoEstado == Enum.HumanoidStateType.Jumping then
        estaNoAr = true
        pararCorrida()

        if pulo then
            pulo:Play(FADE)
        end

    elseif novoEstado == Enum.HumanoidStateType.Freefall then
        estaNoAr = true
        pararCorrida()

    elseif novoEstado == Enum.HumanoidStateType.Landed
        or novoEstado == Enum.HumanoidStateType.Running
        or novoEstado == Enum.HumanoidStateType.RunningNoPhysics then

        estaNoAr = false

        if pulo and pulo.IsPlaying then
            pulo:Stop(FADE)
        end

        atualizarCorrida()

    elseif novoEstado == Enum.HumanoidStateType.Dead then
        personagemVivo = false
        pararCorrida()

        if pulo and pulo.IsPlaying then
            pulo:Stop(FADE)
        end
    end
end)

-- ENCERRAR AO MORRER
humanoid.Died:Connect(function()
    personagemVivo = false
    pararCorrida()

    if pulo and pulo.IsPlaying then
        pulo:Stop(FADE)
    end
end)

print("Animações personalizadas carregadas!")
