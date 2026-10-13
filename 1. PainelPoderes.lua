
-- PAINEL DE PODERES
-- LocalScript: StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local remote = ReplicatedStorage:WaitForChild("PoderesEvent")

local velocidade = 16
local pulo = 50
local velocidadeAtiva = false
local puloAtivo = false

local VELOCIDADE_MIN = 16
local VELOCIDADE_MAX = 400
local PASSO_VELOCIDADE = 16

local PULO_MIN = 50
local PULO_MAX = 200
local PASSO_PULO = 10

local gui = Instance.new("ScreenGui")
gui.Name = "PainelDePoderes"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Botão para abrir e fechar
local abrir = Instance.new("TextButton")
abrir.Name = "AbrirPainel"
abrir.Size = UDim2.fromOffset(48, 48)
abrir.Position = UDim2.new(0, 15, 0.5, -24)
abrir.BackgroundColor3 = Color3.fromRGB(45, 55, 90)
abrir.Text = "⚡"
abrir.TextSize = 25
abrir.TextColor3 = Color3.new(1, 1, 1)
abrir.Font = Enum.Font.GothamBold
abrir.Parent = gui

local cantoAbrir = Instance.new("UICorner")
cantoAbrir.CornerRadius = UDim.new(0, 12)
cantoAbrir.Parent = abrir

-- Painel principal
local painel = Instance.new("Frame")
painel.Name = "Painel"
painel.Size = UDim2.fromOffset(285, 245)
painel.Position = UDim2.new(0, 75, 0.5, -122)
painel.BackgroundColor3 = Color3.fromRGB(25, 29, 43)
painel.Visible = false
painel.Parent = gui

local cantoPainel = Instance.new("UICorner")
cantoPainel.CornerRadius = UDim.new(0, 14)
cantoPainel.Parent = painel

local titulo = Instance.new("TextLabel")
titulo.Size = UDim2.new(1, -20, 0, 40)
titulo.Position = UDim2.fromOffset(10, 5)
titulo.BackgroundTransparency = 1
titulo.Text = "⚡ PAINEL DE PODERES"
titulo.TextColor3 = Color3.new(1, 1, 1)
titulo.TextSize = 17
titulo.Font = Enum.Font.GothamBold
titulo.Parent = painel

local function criarBotao(nome, texto, y, largura, x)
    local botao = Instance.new("TextButton")
    botao.Name = nome
    botao.Size = UDim2.new(0, largura, 0, 42)
    botao.Position = UDim2.new(0, x, 0, y)
    botao.BackgroundColor3 = Color3.fromRGB(55, 65, 95)
    botao.Text = texto
    botao.TextColor3 = Color3.new(1, 1, 1)
    botao.TextSize = 12
    botao.Font = Enum.Font.GothamBold
    botao.Parent = painel

    local canto = Instance.new("UICorner")
    canto.CornerRadius = UDim.new(0, 8)
    canto.Parent = botao

    return botao
end

local botaoVelocidade = criarBotao(
    "SuperVelocidade", "", 55, 201, 10
)

local menosVelocidade = criarBotao(
    "DiminuirVelocidade", "−", 61, 28, 216
)

local maisVelocidade = criarBotao(
    "AumentarVelocidade", "+", 61, 28, 248
)

local botaoPulo = criarBotao(
    "SuperPulo", "", 112, 201, 10
)

local menosPulo = criarBotao(
    "DiminuirPulo", "−", 118, 28, 216
)

local maisPulo = criarBotao(
    "AumentarPulo", "+", 28, 248
)

local function atualizarTexto()
    botaoVelocidade.Text = "VELOCIDADE: "
        .. (velocidadeAtiva and "ON" or "OFF")
        .. " [" .. velocidade .. "]"

    botaoPulo.Text = "SUPERPULO: "
        .. (puloAtivo and "ON" or "OFF")
        .. " [" .. pulo .. "]"
end

local function enviarPoderes()
    remote:FireServer(
        velocidadeAtiva,
        velocidade,
        puloAtivo,
        pulo
    )
    atualizarTexto()
end

abrir.Activated:Connect(function()
    painel.Visible = not painel.Visible
end)

botaoVelocidade.Activated:Connect(function()
    velocidadeAtiva = not velocidadeAtiva
    enviarPoderes()
end)

botaoPulo.Activated:Connect(function()
    puloAtivo = not puloAtivo
    enviarPoderes()
end)

menosVelocidade.Activated:Connect(function()
    velocidade = math.max(
        VELOCIDADE_MIN,
        velocidade - PASSO_VELOCIDADE
    )
    enviarPoderes()
end)

maisVelocidade.Activated:Connect(function()
    velocidade = math.min(
        VELOCIDADE_MAX,
        velocidade + PASSO_VELOCIDADE
    )
    enviarPoderes()
end)

menosPulo.Activated:Connect(function()
    pulo = math.max(PULO_MIN, pulo - PASSO_PULO)
    enviarPoderes()
end)

maisPulo.Activated:Connect(function()
    pulo = math.min(PULO_MAX, pulo + PASSO_PULO)
    enviarPoderes()
end)

player.CharacterAdded:Connect(function()
    task.wait(0.5)
    enviarPoderes()
end)

atualizarTexto()
