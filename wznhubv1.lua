local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomUI_Cyan"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 60, 0, 60)
toggleButton.Position = UDim2.new(0, 20, 0.5, -30)
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 229)
toggleButton.BackgroundTransparency = 0
toggleButton.Text = "Wzn"
toggleButton.Font = Enum.Font.Arcade
toggleButton.TextSize = 16
toggleButton.TextColor3 = Color3.fromRGB(0, 10, 10)
toggleButton.Active = true
toggleButton.Draggable = true
toggleButton.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(1, 0)
uiCorner.Parent = toggleButton

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 320)
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -160)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 30, 40)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = false
mainFrame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 12)
frameCorner.Parent = mainFrame

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 30)
topBar.Position = UDim2.new(0, 0, 0, 0)
topBar.BackgroundTransparency = 1
topBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Wzn Hub Tools"
titleLabel.Font = Enum.Font.Arcade
titleLabel.TextSize = 16
titleLabel.TextColor3 = Color3.fromRGB(180, 255, 255)
titleLabel.Parent = topBar

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 6)
layout.FillDirection = Enum.FillDirection.Vertical
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Top
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = mainFrame

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
local sizeY = layout.AbsoluteContentSize.Y + 24
mainFrame.Size = UDim2.new(0, mainFrame.Size.X.Offset, 0, math.clamp(sizeY, 120, 1000))
end)

local TweenService = game:GetService("TweenService")

local function createToggle(button, callback)
local state = false  -- começa OFF

-- cores
local colorOn = Color3.fromRGB(0, 40, 120)   -- azul escuro
local colorOff = Color3.fromRGB(0, 255, 255) -- cyan

-- texto inicial
button.Text = button.Name .. " (OFF)"
button.BackgroundColor3 = colorOff

button.MouseButton1Click:Connect(function()
state = not state

button.Text = button.Name .. (state and " (ON)" or " (OFF)")
button.BackgroundColor3 = state and colorOn or colorOff

-- animação suave de clique
local tween1 = TweenService:Create(button, TweenInfo.new(0.08), {
Size = UDim2.new(button.Size.X.Scale, button.Size.X.Offset - 3, button.Size.Y.Scale, button.Size.Y.Offset - 3)
})

local tween2 = TweenService:Create(button, TweenInfo.new(0.08), {
Size = UDim2.new(button.Size.X.Scale, button.Size.X.Offset, button.Size.Y.Scale, button.Size.Y.Offset)
})

tween1:Play()
tween1.Completed:Connect(function()
tween2:Play()
end)

callback(state)

end)

end

local function createButton(name)
local button = Instance.new("TextButton")
button.Name = name
button.Size = UDim2.new(0, 200, 0, 32)
button.Text = name
button.Font = Enum.Font.Arcade
button.TextSize = 16
button.TextColor3 = Color3.fromRGB(220, 255, 255)
button.BackgroundColor3 = Color3.fromRGB(0, 180, 200)
button.AutoButtonColor = false
button.BorderSizePixel = 0
button.Parent = mainFrame

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = button

return button

end

local uiVisible = false

-- ========== Substitute these functions for a stable fade-in / fade-out ==========
-- Guarda propriedades originais do GUI (faz uma vez por GUI)
local originalGuiProps = {}
originalGuiProps[mainFrame] = {
Size = mainFrame.Size,
Position = mainFrame.Position,
AnchorPoint = mainFrame.AnchorPoint or Vector2.new(0, 0),
BackgroundTransparency = mainFrame.BackgroundTransparency
}

local function playEntryAnimation(guiFrame)
-- pega (ou inicializa) propriedades originais
local orig = originalGuiProps[guiFrame]
if not orig then
orig = {
Size = guiFrame.Size,
Position = guiFrame.Position,
AnchorPoint = guiFrame.AnchorPoint or Vector2.new(0,0),
BackgroundTransparency = guiFrame.BackgroundTransparency
}
originalGuiProps[guiFrame] = orig
end

-- define ponto de âncora para centralizar corretamente  
guiFrame.AnchorPoint = Vector2.new(0.5, 0.5)  

-- posiciona no centro baseado nas offsets originais (mantendo a mesma referência)  
guiFrame.Position = UDim2.new(0.5, orig.Position.X.Offset, 0.5, orig.Position.Y.Offset)  

-- começa menor e transparente  
local smallSize = UDim2.new(0, orig.Size.X.Offset * 0.85, 0, orig.Size.Y.Offset * 0.85)  
guiFrame.Size = smallSize  
guiFrame.BackgroundTransparency = 1  
guiFrame.Visible = true  

-- tween para voltar ao tamanho/trasparency/posição originais (suave)  
local tweenInfo = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)  
local props = {  
    Size = orig.Size,  
    BackgroundTransparency = orig.BackgroundTransparency or 0.05,  
    Position = orig.Position  
}  
local ok, tween = pcall(function()  
    return TweenService:Create(guiFrame, tweenInfo, props)  
end)  
if ok and tween then tween:Play() end

end

local function playExitAnimation(guiFrame)
local orig = originalGuiProps[guiFrame]
if not orig then
orig = { Size = guiFrame.Size, Position = guiFrame.Position, BackgroundTransparency = guiFrame.BackgroundTransparency }
originalGuiProps[guiFrame] = orig
end

local smallSize = UDim2.new(0, orig.Size.X.Offset * 0.85, 0, orig.Size.Y.Offset * 0.85)  
local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In)  
local props = { Size = smallSize, BackgroundTransparency = 1 }  

local ok, tween = pcall(function()  
    return TweenService:Create(guiFrame, tweenInfo, props)  
end)  
if ok and tween then  
    tween:Play()  
    tween.Completed:Connect(function()  
        -- ao finalizar, esconde e restaura valores originais (evita reduzir cumulativamente)  
        guiFrame.Visible = false  
        guiFrame.Size = orig.Size  
        guiFrame.Position = orig.Position  
        guiFrame.AnchorPoint = orig.AnchorPoint or Vector2.new(0,0)  
        guiFrame.BackgroundTransparency = orig.BackgroundTransparency or 0.05  
    end)  
else  
    -- fallback: se algo falhar, só esconde e restaura  
    guiFrame.Visible = false  
    guiFrame.Size = orig.Size  
    guiFrame.Position = orig.Position  
    guiFrame.AnchorPoint = orig.AnchorPoint or Vector2.new(0,0)  
    guiFrame.BackgroundTransparency = orig.BackgroundTransparency or 0.05  
end

end
-- ======================================================================

-- conecta o botão Wzn para abrir/fechar a interface
toggleButton.MouseButton1Click:Connect(function()
uiVisible = not uiVisible
if uiVisible then
playEntryAnimation(mainFrame)
else
playExitAnimation(mainFrame)
end
end)

local espBaseButton = createButton("ESP Base")
local espPlayerButton = createButton("ESP Player")

-- botão no painel principal
local mainMenuButton = createButton("Menu Principal")

-- cria janela extra
local menuGui = Instance.new("ScreenGui")
menuGui.Name = "WZN_MenuPrincipal_Cyan"
menuGui.ResetOnSpawn = false
menuGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 180, 0, 220)
frame.Position = UDim2.new(0.5, -90, 0.5, -110)
frame.BackgroundColor3 = Color3.fromRGB(0, 30, 40)
frame.BackgroundTransparency = 0.05
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Visible = false
frame.Parent = menuGui

local frameCorner2 = Instance.new("UICorner")
frameCorner2.CornerRadius = UDim.new(0, 12)
frameCorner2.Parent = frame

local titleLabel2 = Instance.new("TextLabel")
titleLabel2.Size = UDim2.new(1, 0, 0, 26)
titleLabel2.BackgroundTransparency = 1
titleLabel2.Text = "Menu Principal"
titleLabel2.Font = Enum.Font.Arcade
titleLabel2.TextSize = 16
titleLabel2.TextColor3 = Color3.fromRGB(180, 255, 255)
titleLabel2.Parent = frame

local layout2 = Instance.new("UIListLayout")
layout2.Padding = UDim.new(0, 6)
layout2.FillDirection = Enum.FillDirection.Vertical
layout2.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout2.VerticalAlignment = Enum.VerticalAlignment.Top
layout2.SortOrder = Enum.SortOrder.LayoutOrder
layout2.Parent = frame

-- cria botão interno
local function createMenuButton(name)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(0, 160, 0, 30)
    button.Text = name
    button.Font = Enum.Font.Arcade
    button.TextSize = 16
    button.TextColor3 = Color3.fromRGB(220, 255, 255)
    button.BackgroundColor3 = Color3.fromRGB(0, 180, 200)
    button.AutoButtonColor = false
    button.BorderSizePixel = 0
    button.Parent = frame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button

    return button
end

-- 🔵 AGORA O SISTEMA ON/OFF DO MENU PRINCIPAL
createToggle(mainMenuButton, function(state)
    if state then
        playEntryAnimation(frame)
    else
        playExitAnimation(frame)
    end
end)

local fpsButton = createMenuButton("Teleguiado")

mainMenuButton.MouseButton1Click:Connect(function()
frame.Visible = not frame.Visible
if frame.Visible then
playEntryAnimation(frame)
mainMenuButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
else
mainMenuButton.BackgroundColor3 = Color3.fromRGB(0, 180, 200)
end
end)

local lp = Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local hrp = char:FindFirstChild("HumanoidRootPart")
local active = false
local originalTransparency = {}
local originalFogEnd = Lighting.FogEnd

local function makePlotsTransparent()
local plotsFolder = Workspace:FindFirstChild("Plots") or Workspace:FindFirstChild("plots")
if not plotsFolder then return end
for _, obj in pairs(plotsFolder:GetDescendants()) do
if obj:IsA("BasePart") and obj.Transparency < 1 then
if originalTransparency[obj] == nil then
originalTransparency[obj] = obj.Transparency
end
obj.Transparency = 0.8
end
end
end

local function restoreTransparency()
for obj, oldValue in pairs(originalTransparency) do
if obj and obj.Parent then
obj.Transparency = oldValue
end
end
originalTransparency = {}
end

local function startFloatUP()
RunService:BindToRenderStep("FloatUP_Cyan", Enum.RenderPriority.Character.Value + 1, function()
local ch = lp.Character or lp.CharacterAdded:Wait()
local p = ch:FindFirstChild("HumanoidRootPart")
local hum = ch:FindFirstChildOfClass("Humanoid")
if p and hum then
p.Velocity = Vector3.new(0, 25, 0)
end
end)
end

local function stopFloatUP()
pcall(function() RunService:UnbindFromRenderStep("FloatUP_Cyan") end)
end

-- 🔵 TOGGLE: 3D Floor
local function toggle3DFloor(state)
active = state

if state then
makePlotsTransparent()
Lighting.FogEnd = 999999
startFloatUP()
else
restoreTransparency()
Lighting.FogEnd = originalFogEnd
stopFloatUP()
end

end

local floorButtonUI = createMenuButton("3D Floor")

createToggle(floorButtonUI, toggle3DFloor)

lp.CharacterAdded:Connect(function(newChar)
char = newChar
hrp = newChar:WaitForChild("HumanoidRootPart")
end)

local guidedOn = false
local guidedConn = nil

createToggle(fpsButton, function(state)
    guidedOn = state
    
    local ch = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hum = ch:FindFirstChildOfClass("Humanoid")
    local p = ch:FindFirstChild("HumanoidRootPart")

    if state then
        -- Ativado
        if p then
            guidedConn = RunService.RenderStepped:Connect(function()
                if guidedOn and p then
                    p.Velocity = workspace.CurrentCamera.CFrame.LookVector * 30
                end
            end)
        end
    else
        -- Desativado
        if guidedConn then
            guidedConn:Disconnect()
            guidedConn = nil
        end
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end
end)

local function AntiHit()
local function DesyncV2()
local flags = {
{"GameNetPVHeaderRotationalVelocityZeroCutoffExponent", "-5000"},
{"LargeReplicatorWrite5", "true"},
{"LargeReplicatorEnabled9", "true"},
{"AngularVelociryLimit", "360"},
{"TimestepArbiterVelocityCriteriaThresholdTwoDt", "2147483646"},
{"S2PhysicsSenderRate", "15000"},
{"DisableDPIScale", "true"},
{"MaxDataPacketPerSend", "2147483647"},
{"ServerMaxBandwith", "52"},
{"PhysicsSenderMaxBandwidthBps", "20000"},
{"MaxTimestepMultiplierBuoyancy", "2147483647"},
{"SimOwnedNOUCountThresholdMillionth", "2147483647"},
{"MaxMissedWorldStepsRemembered", "-2147483648"},
{"CheckPVDifferencesForInterpolationMinVelThresholdStudsPerSecHundredth", "1"},
{"StreamJobNOUVolumeLengthCap", "2147483647"},
{"DebugSendDistInSteps", "-2147483648"},
{"MaxTimestepMultiplierAcceleration", "2147483647"},
{"LargeReplicatorRead5", "true"},
{"SimExplicitlyCappedTimestepMultiplier", "2147483646"},
{"GameNetDontSendRedundantNumTimes", "1"},
{"CheckPVLinearVelocityIntegrateVsDeltaPositionThresholdPercent", "1"},
{"CheckPVCachedRotVelThresholdPercent", "10"},
{"LargeReplicatorSerializeRead3", "true"},
{"ReplicationFocusNouExtentsSizeCutoffForPauseStuds", "2147483647"},
{"NextGenReplicatorEnabledWrite4", "true"},
{"CheckPVDifferencesForInterpolationMinRotVelThresholdRadsPerSecHundredth", "1"},
{"GameNetDontSendRedundantDeltaPositionMillionth", "1"},
{"InterpolationFrameVelocityThresholdMillionth", "5"},
{"StreamJobNOUVolumeCap", "2147483647"},
{"InterpolationFrameRotVelocityThresholdMillionth", "5"},
{"WorldStepMax", "30"},
{"TimestepArbiterHumanoidLinearVelThreshold", "1"},
{"InterpolationFramePositionThresholdMillionth", "5"},
{"TimestepArbiterHumanoidTurningVelThreshold", "1"},
{"MaxTimestepMultiplierContstraint", "2147483647"},
{"GameNetPVHeaderLinearVelocityZeroCutoffExponent", "-5000"},
{"CheckPVCachedVelThresholdPercent", "10"},
{"TimestepArbiterOmegaThou", "1073741823"},
{"MaxAcceptableUpdateDelay", "1"},
{"LargeReplicatorSerializeWrite4", "true"},
}

for _, data in ipairs(flags) do
pcall(function()
if setfflag then
setfflag(data[1], data[2])
end
end)
end

local char = LocalPlayer.Character
if not char then return end

local humanoid = char:FindFirstChildWhichIsA("Humanoid")
if humanoid then
humanoid:ChangeState(Enum.HumanoidStateType.Dead)
end

char:ClearAllChildren()

local fakeModel = Instance.new("Model", workspace)
LocalPlayer.Character = fakeModel
task.wait()
LocalPlayer.Character = char
fakeModel:Destroy()

end

DesyncV2()

end

local desyncMenuButton = createMenuButton("Desync (respawn)")

createToggle(desyncMenuButton, function(state)
if state then
AntiHit()
else
-- OFF não faz nada (Anti-Hit é efeito único)
end
end)

local activeLockTimeEsp = false
local lteInstances = {}

local function updateLockESP()
    if not activeLockTimeEsp then
        for _, instance in pairs(lteInstances) do
            if instance then instance:Destroy() end
        end
        lteInstances = {}
        return
    end

    local plotsFolder = Workspace:FindFirstChild("Plots") or Workspace:FindFirstChild("plots")
    if not plotsFolder then return end

    for _, plot in pairs(plotsFolder:GetChildren()) do
        local timeLabel = plot:FindFirstChild("Purchases", true)
            and plot.Purchases:FindFirstChild("PlotBlock", true)
            and plot.Purchases.PlotBlock.Main:FindFirstChild("BillboardGui", true)
            and plot.Purchases.PlotBlock.Main.BillboardGui:FindFirstChild("RemainingTime", true)

        if timeLabel and timeLabel:IsA("TextLabel") then
            local espName = "LockTimeESP" .. plot.Name
            local existingBillboard = plot:FindFirstChild(espName)
            local isUnlocked = timeLabel.Text == "0s"

            local displayText = isUnlocked and "Unlocked" or ("Locked: " .. timeLabel.Text)
            local textColor = isUnlocked and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(180, 255, 255)

            if not existingBillboard then
                local billboard = Instance.new("BillboardGui")
                billboard.Name = espName
                billboard.Size = UDim2.new(0, 150, 0, 30)
                billboard.StudsOffset = Vector3.new(0, 5, 0)
                billboard.AlwaysOnTop = true

                local label = Instance.new("TextLabel")
                label.Text = displayText
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 0.4
                label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                label.TextScaled = true
                label.TextColor3 = textColor
                label.TextStrokeColor3 = Color3.new(0, 0, 0)
                label.TextStrokeTransparency = 0
                label.Font = Enum.Font.Arcade
                label.Parent = billboard

                billboard.Parent = plot
                lteInstances[plot.Name] = billboard
            else
                if existingBillboard:FindFirstChildOfClass("TextLabel") then
                    existingBillboard.TextLabel.Text = displayText
                    existingBillboard.TextLabel.TextColor3 = textColor
                end
            end
        end
    end
end

-- LOOP
task.spawn(function()
    while true do
        task.wait(0.25)
        if activeLockTimeEsp then
            updateLockESP()
        end
    end
end)

-- BOTÃO COM SISTEMA ON/OFF
espBaseButton.MouseButton1Click:Connect(function()
    activeLockTimeEsp = not activeLockTimeEsp

    -- muda cor
    espBaseButton.BackgroundColor3 =
        activeLockTimeEsp and Color3.fromRGB(0, 40, 120) or Color3.fromRGB(0, 255, 255)

    -- adiciona texto ON/OFF
    espBaseButton.Text =
        activeLockTimeEsp and "ESP Base (ON)" or "ESP Base (OFF)"

    -- desativa e limpa
    if not activeLockTimeEsp then
        for _, instance in pairs(lteInstances) do
            if instance then instance:Destroy() end
        end
        lteInstances = {}
    end
end)

-- texto inicial do botão
espBaseButton.Text = "ESP Base (OFF)"
espBaseButton.BackgroundColor3 = Color3.fromRGB(0, 255, 255)

--== PLAYER ESP ON/OFF SYSTEM ==--

local activeESPPlayer = false
local playerESPInstances = {}

local function createPlayerESP(plr)
    if plr == LocalPlayer then return end
    local char = plr.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 120, 0, 30)
    billboard.Adornee = hrp
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 0.4
    label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    label.Text = plr.Name
    label.Font = Enum.Font.Arcade
    label.TextSize = 14
    label.TextColor3 = Color3.fromRGB(180, 255, 255)
    label.TextStrokeColor3 = Color3.new(0, 0, 0)
    label.TextStrokeTransparency = 0
    label.Parent = billboard

    billboard.Parent = hrp
    playerESPInstances[plr] = billboard
end

local function clearESPPlayers()
    for plr, billboard in pairs(playerESPInstances) do
        if billboard and billboard.Parent then
            billboard:Destroy()
        end
    end
    playerESPInstances = {}
end

local function updateESPPlayers()
    for _, plr in pairs(Players:GetPlayers()) do
        if activeESPPlayer and not playerESPInstances[plr] then
            createPlayerESP(plr)
        end
    end
end

--== BOTÃO DO MENU + ON/OFF PADRÃO ==--

espPlayerButton.Text = "ESP Players (OFF)"
espPlayerButton.BackgroundColor3 = Color3.fromRGB(0, 255, 255)

espPlayerButton.MouseButton1Click:Connect(function()
    activeESPPlayer = not activeESPPlayer

    -- COR ON/OFF
    espPlayerButton.BackgroundColor3 =
        activeESPPlayer and Color3.fromRGB(0, 40, 120) or Color3.fromRGB(0, 255, 255)

    -- TEXTO ON/OFF
    espPlayerButton.Text =
        activeESPPlayer and "ESP Players (ON)" or "ESP Players (OFF)"

    if not activeESPPlayer then
        clearESPPlayers()
    else
        updateESPPlayers()
    end
end)

--== AUTO UPDATE QUANDO PLAYER ENTRA ==--
Players.PlayerAdded:Connect(function(plr)
    if activeESPPlayer then
        task.wait(1)
        createPlayerESP(plr)
    end
end)

--== LOOP DE UPDATE ==--
RunService.RenderStepped:Connect(function()
    if activeESPPlayer then
        updateESPPlayers()
    end
end)

local autoLaserEnabled = false
local blacklist = { choponho123 = true, Henryquarto = true }

local function getLaserRemote()
    local remote
    pcall(function()
        local pkg = ReplicatedStorage:FindFirstChild("Packages")
        local net = pkg and pkg:FindFirstChild("Net")
        remote = net and (net:FindFirstChild("RE/UseItem") or (net:FindFirstChild("RE") and net.RE:FindFirstChild("UseItem")))
        remote = remote or ReplicatedStorage:FindFirstChild("RE/UseItem") or ReplicatedStorage:FindFirstChild("UseItem")
    end)
    return remote
end

local function isValidTarget(player)
    if not player or not player.Character or player == LocalPlayer then return false end
    if blacklist[string.lower(player.Name or "")] then return false end
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    return hrp and humanoid and humanoid.Health > 0
end

local function findNearestTarget()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
    local myPos = hrp.Position
    local nearest, minDist = nil, math.huge
    
    for _, pl in ipairs(Players:GetPlayers()) do
        if isValidTarget(pl) then
            local targetHRP = pl.Character:FindFirstChild("HumanoidRootPart")
            if targetHRP then
                local dist = (Vector3.new(targetHRP.Position.X, 0, targetHRP.Position.Z) - Vector3.new(myPos.X, 0, myPos.Z)).Magnitude
                if dist < minDist then
                    minDist = dist
                    nearest = pl
                end
            end
        end
    end
    return nearest
end

local function fireAt(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetHRP then return end
    
    local remote = getLaserRemote()
    if remote and remote.FireServer then
        pcall(function()
            remote:FireServer(targetHRP.Position, targetHRP)
        end)
    end
end

local function manualFire()
    local target = findNearestTarget()
    if target then
        fireAt(target)
    end
end

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if autoLaserEnabled and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        manualFire()
    end
end)

-- BOTÃO DO MENU
local autoLaserButton = createMenuButton("Aimbot Tools")
autoLaserButton.BackgroundColor3 = Color3.fromRGB(0, 255, 255)

-- 🔥 SISTEMA ON/OFF AUTOMÁTICO
createToggle(autoLaserButton, function(state)
    autoLaserEnabled = state

    if state then
        -- ativou
    else
        -- desativou
    end
end)

local currentESP = nil
local connection = nil
local activeBrainrotESP = false

local espBrainrotButton = createButton("ESP Best")
espBrainrotButton.BackgroundColor3 = Color3.fromRGB(0, 255, 255)

local function extractValue(text)
if not text then return 0 end
local clean = text:gsub("[%$,/s]", ""):gsub(",", "")
local mult = 1
if clean:match("[kK]") then mult = 1e3; clean = clean:gsub("[kK]", "") end
if clean:match("[mM]") then mult = 1e6; clean = clean:gsub("[mM]", "") end
if clean:match("[bB]") then mult = 1e9; clean = clean:gsub("[bB]", "") end
if clean:match("[tT]") then mult = 1e12; clean = clean:gsub("[tT]", "") end
local num = tonumber(clean)
return num and num * mult or 0
end

local function shorten(num)
if num >= 1e12 then return string.format("%.2fT", num / 1e12)
elseif num >= 1e9 then return string.format("%.2fB", num / 1e9)
elseif num >= 1e6 then return string.format("%.2fM", num / 1e6)
elseif num >= 1e3 then return string.format("%.2fK", num / 1e3)
else return tostring(math.floor(num)) end
end

local function createESP(part, name, value)
if currentESP then
currentESP:Destroy()
currentESP = nil
end

local billboard = Instance.new("BillboardGui")
billboard.AlwaysOnTop = true
billboard.Size = UDim2.new(0, 450, 0, 80)
billboard.StudsOffset = Vector3.new(0, 4, 0)
billboard.Adornee = part
billboard.Parent = part

local nameLabel = Instance.new("TextLabel")
nameLabel.Size = UDim2.new(1, 0, 0, 45)
nameLabel.BackgroundTransparency = 1
nameLabel.Text = name
nameLabel.TextColor3 = Color3.fromRGB(180, 255, 255)
nameLabel.TextSize = 28
nameLabel.Font = Enum.Font.Arcade
nameLabel.Parent = billboard

local valueLabel = Instance.new("TextLabel")
valueLabel.Size = UDim2.new(1, 0, 0, 30)
valueLabel.Position = UDim2.new(0, 0, 0, 45)
valueLabel.BackgroundTransparency = 1
valueLabel.Text = "$" .. shorten(value) .. "/s"
valueLabel.TextColor3 = Color3.fromRGB(0, 255, 200)
valueLabel.TextSize = 22
valueLabel.Font = Enum.Font.Arcade
valueLabel.Parent = billboard

local highlight = Instance.new("Highlight")
highlight.Adornee = part
highlight.FillColor = Color3.fromRGB(0, 255, 200)
highlight.OutlineColor = Color3.fromRGB(0, 200, 160)
highlight.FillTransparency = 0.85
highlight.OutlineTransparency = 0
highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
highlight.Parent = part

currentESP = billboard

end

local function findBestBrainrot()
local plots = Workspace:FindFirstChild("Plots")
if not plots then return end

local bestValue, bestPart, bestName = 0, nil, "Brainrot"

for _, plot in ipairs(plots:GetChildren()) do
local podiums = plot:FindFirstChild("AnimalPodiums")
if podiums then
for i = 1, 22 do
local slot = podiums:FindFirstChild(tostring(i))
if slot then
local base = slot:FindFirstChild("Base")
local spawn = base and base:FindFirstChild("Spawn")
local attach = spawn and spawn:FindFirstChild("Attachment")
local overhead = attach and attach:FindFirstChild("AnimalOverhead")
if overhead then
local foundValue = 0
local foundName = "Brainrot"
local foundPart = base
for _, child in ipairs(overhead:GetChildren()) do
if child:IsA("TextLabel") then
local color = child.TextColor3
local text = child.Text
if color.R > 0.8 and color.G > 0.8 and color.B < 0.3 then
local value = extractValue(text)
if value > foundValue then foundValue = value end
end
if child.Name == "DisplayName" and text ~= "" then
foundName = text
end
end
end
if foundValue > bestValue then
bestValue = foundValue
bestPart = foundPart
bestName = foundName
end
end
end
end
end
end

if bestPart and bestValue > 0 then
createESP(bestPart, bestName, bestValue)
else
if currentESP then
currentESP:Destroy()
currentESP = nil
end
end

end

local function startESP()
if connection then connection:Disconnect() end
connection = RunService.Heartbeat:Connect(findBestBrainrot)
end

local function stopESP()
if connection then connection:Disconnect() connection = nil end
if currentESP then currentESP:Destroy() currentESP = nil end
end

-- ✅ Aqui usamos createToggle para ON/OFF
createToggle(espBrainrotButton, function(state)
activeBrainrotESP = state
if state then
startESP()
else
stopESP()
end
end)