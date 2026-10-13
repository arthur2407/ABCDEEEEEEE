
-- SERVIDOR DOS PODERES
-- Script: ServerScriptService

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local remote = ReplicatedStorage:FindFirstChild("PoderesEvent")

if not remote then
    remote = Instance.new("RemoteEvent")
    remote.Name = "PoderesEvent"
    remote.Parent = ReplicatedStorage
end

local VELOCIDADE_NORMAL = 16
local VELOCIDADE_MIN = 16
local VELOCIDADE_MAX = 400

local PULO_NORMAL = 50
local PULO_MIN = 50
local PULO_MAX = 200

local estados = {}

local function aplicar(player)
    local estado = estados[player]
    if not estado then return end

    local character = player.Character
    if not character then return end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    humanoid.UseJumpPower = true

    humanoid.WalkSpeed = estado.velocidadeAtiva
        and estado.velocidade
        or VELOCIDADE_NORMAL

    humanoid.JumpPower = estado.puloAtivo
        and estado.pulo
        or PULO_NORMAL
end

Players.PlayerAdded:Connect(function(player)
    estados[player] = {
        velocidadeAtiva = false,
        velocidade = VELOCIDADE_NORMAL,
        puloAtivo = false,
        pulo = PULO_NORMAL
    }

    player.CharacterAdded:Connect(function()
        task.wait(0.2)
        aplicar(player)
    end)
end)

for _, player in Players:GetPlayers() do
    estados[player] = {
        velocidadeAtiva = false,
        velocidade = VELOCIDADE_NORMAL,
        puloAtivo = false,
        pulo = PULO_NORMAL
    }
end

remote.OnServerEvent:Connect(function(
    player,
    velocidadeAtiva,
    velocidade,
    puloAtivo,
    pulo
)
    if typeof(velocidadeAtiva) ~= "boolean"
        or typeof(puloAtivo) ~= "boolean"
        or typeof(velocidade) ~= "number"
        or typeof(pulo) ~= "number" then
        return
    end

    local estado = estados[player]
    if not estado then return end

    estado.velocidadeAtiva = velocidadeAtiva
    estado.velocidade = math.clamp(
        velocidade,
        VELOCIDADE_MIN,
        VELOCIDADE_MAX
    )

    estado.puloAtivo = puloAtivo
    estado.pulo = math.clamp(
        pulo,
        PULO_MIN,
        PULO_MAX
    )

    aplicar(player)
end)

Players.PlayerRemoving:Connect(function(player)
    estados[player] = nil
end)
