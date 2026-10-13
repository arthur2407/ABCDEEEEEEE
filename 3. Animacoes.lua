
-- ANIMACOES PERSONALIZADAS
-- LocalScript: StarterPlayer > StarterCharacterScripts

local character = script.Parent
local humanoid = character:WaitForChild("Humanoid")

local animator = humanoid:FindFirstChildOfClass("Animator")

if not animator then
    animator = Instance.new("Animator")
    animator.Parent = humanoid
end

local function criarAnimacao(id, prioridade, looped)
    local animation = Instance.new("Animation")
    animation.AnimationId = id

    local track = animator:LoadAnimation(animation)
    track.Priority = prioridade
    track.Looped = looped

    return track
end

local corrida = criarAnimacao(
    "rbxassetid://130193757655135",
    Enum.AnimationPriority.Movement,
    true
)

local pulo = criarAnimacao(
    "rbxassetid://74116059836265",
    Enum.AnimationPriority.Action,
    false
)

local noAr = false

humanoid.Running:Connect(function(velocidade)
    if noAr then return end

    if velocidade > 1 then
        if not corrida.IsPlaying then
            corrida:Play(0.2)
        end
    elseif corrida.IsPlaying then
        corrida:Stop(0.2)
    end
end)

humanoid.StateChanged:Connect(function(_, novoEstado)
    if novoEstado == Enum.HumanoidStateType.Jumping then
        noAr = true

        if corrida.IsPlaying then
            corrida:Stop(0.1)
        end

        pulo:Play(0.1)

    elseif novoEstado == Enum.HumanoidStateType.Landed
        or novoEstado == Enum.HumanoidStateType.Running
        or novoEstado == Enum.HumanoidStateType.RunningNoPhysics then

        noAr = false

        if pulo.IsPlaying then
            pulo:Stop(0.1)
        end
    end
end)
