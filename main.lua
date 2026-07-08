-- SZX HUB v3.0 - Interface Custom Sem Rayfield
-- Menu Roxo 100% Funcional

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- ============= CRIAR GUI ROXO =============
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SZXHubGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Fundo Roxo Principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 600)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -300)
mainFrame.BackgroundColor3 = Color3.fromRGB(45, 0, 60)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(150, 50, 200)
mainFrame.Parent = screenGui

-- Canto Arredondado
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = mainFrame

-- Título Roxo
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 50)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(100, 0, 150)
titleLabel.TextColor3 = Color3.fromRGB(255, 200, 255)
titleLabel.TextSize = 20
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "✨ SZX HUB ROXO ✨"
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleLabel

-- Scroll Frame para conteúdo
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "ScrollFrame"
scrollFrame.Size = UDim2.new(1, -20, 1, -80)
scrollFrame.Position = UDim2.new(0, 10, 0, 60)
scrollFrame.BackgroundColor3 = Color3.fromRGB(35, 0, 50)
scrollFrame.BorderSizePixel = 0
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 1000)
scrollFrame.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 10)
listLayout.Parent = scrollFrame

-- ============= VARIÁVEIS =============
local noclipActive = false
local killAuraActive = false
local espActive = false
local antiFlingActive = false
local fpsCounterActive = false
local walkSpeed = 16
local fpsCounter = 0
local killAuraRadius = 15

-- ============= FPS Counter =============
RunService.RenderStepped:Connect(function(deltaTime)
    fpsCounter = math.floor(1 / deltaTime)
end)

-- ============= NOCLIP =============
RunService.Stepped:Connect(function()
    if noclipActive and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- ============= ANTI-FLING =============
RunService.Heartbeat:Connect(function()
    if antiFlingActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local humanoidRootPart = LocalPlayer.Character.HumanoidRootPart
        local velocity = humanoidRootPart.Velocity.Magnitude
        if velocity > 100 then
            humanoidRootPart.Velocity = Vector3.new(0, humanoidRootPart.Velocity.Y, 0)
        end
    end
end)

-- ============= KILL AURA =============
local SelectionSphere = Instance.new("SelectionSphere")
SelectionSphere.Color3 = Color3.fromRGB(255, 60, 60)
SelectionSphere.Transparency = 0.5

task.spawn(function()
    while task.wait(0.1) do
        if killAuraActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            SelectionSphere.Parent = LocalPlayer.Character.HumanoidRootPart
            SelectionSphere.Adornee = LocalPlayer.Character.HumanoidRootPart
            
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character:FindFirstChild("HumanoidRootPart") then
                    local distance = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                    if distance <= killAuraRadius and player.Character.Humanoid.Health > 0 then
                        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                        if tool then 
                            tool:Activate() 
                        end
                        SelectionSphere.Color3 = Color3.fromRGB(255, 0, 0)
                    end
                end
            end
        else
            SelectionSphere.Parent = nil
        end
    end
end)

-- ============= FUNÇÃO CRIAR BOTÃO =============
local function createButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(80, 0, 120)
    btn.TextColor3 = Color3.fromRGB(220, 180, 255)
    btn.TextSize = 16
    btn.Font = Enum.Font.Gotham
    btn.Text = text
    btn.Parent = parent
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btn.UICorner = btnCorner
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(120, 0, 180)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(80, 0, 120)
    end)
    
    return btn
end

-- ============= FUNÇÃO CRIAR TOGGLE =============
local function createToggle(parent, text, onToggle)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -20, 0, 40)
    container.BackgroundColor3 = Color3.fromRGB(60, 0, 100)
    container.BorderSizePixel = 0
    container.Parent = parent
    
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 8)
    containerCorner.Parent = container
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(220, 180, 255)
    label.TextSize = 16
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 40, 0, 25)
    toggleBtn.Position = UDim2.new(0.75, 0, 0.5, -12)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    toggleBtn.Text = "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.Parent = container
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 5)
    toggleCorner.Parent = toggleBtn
    
    local toggled = false
    toggleBtn.MouseButton1Click:Connect(function()
        toggled = not toggled
        toggleBtn.BackgroundColor3 = toggled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        toggleBtn.Text = toggled and "ON" or "OFF"
        onToggle(toggled)
    end)
    
    return container
end

-- ============= SEÇÕES DO MENU =============

-- SEÇÃO MOVIMENTO
local movSection = Instance.new("TextLabel")
movSection.Size = UDim2.new(1, -20, 0, 30)
movSection.BackgroundColor3 = Color3.fromRGB(150, 50, 200)
movSection.TextColor3 = Color3.fromRGB(255, 255, 255)
movSection.TextSize = 16
movSection.Font = Enum.Font.GothamBold
movSection.Text = "🏃 MOVIMENTO"
movSection.Parent = scrollFrame

local movCorner = Instance.new("UICorner")
movCorner.CornerRadius = UDim.new(0, 8)
movCorner.Parent = movSection

createToggle(scrollFrame, "✨ NoClip", function(state)
    noclipActive = state
end)

createButton(scrollFrame, "⬆️ Aumentar Velocidade", function()
    walkSpeed = math.min(walkSpeed + 10, 250)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = walkSpeed
    end
end)

createButton(scrollFrame, "⬇️ Diminuir Velocidade", function()
    walkSpeed = math.max(walkSpeed - 10, 16)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = walkSpeed
    end
end)

createToggle(scrollFrame, "👻 Invisível", function(state)
    if LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                part.Transparency = state and 0.5 or 0
            end
        end
    end
end)

createToggle(scrollFrame, "🛡️ Anti-Fling", function(state)
    antiFlingActive = state
end)

-- SEÇÃO COMBATE
local combatSection = Instance.new("TextLabel")
combatSection.Size = UDim2.new(1, -20, 0, 30)
combatSection.BackgroundColor3 = Color3.fromRGB(200, 0, 50)
combatSection.TextColor3 = Color3.fromRGB(255, 255, 255)
combatSection.TextSize = 16
combatSection.Font = Enum.Font.GothamBold
combatSection.Text = "⚔️ COMBATE"
combatSection.Parent = scrollFrame

local combatCorner = Instance.new("UICorner")
combatCorner.CornerRadius = UDim.new(0, 8)
combatCorner.Parent = combatSection

createToggle(scrollFrame, "⚔️ Kill Aura", function(state)
    killAuraActive = state
end)

createButton(scrollFrame, "📈 Aumentar Alcance", function()
    killAuraRadius = math.min(killAuraRadius + 5, 50)
end)

createButton(scrollFrame, "📉 Diminuir Alcance", function()
    killAuraRadius = math.max(killAuraRadius - 5, 5)
end)

createToggle(scrollFrame, "👁️ ESP", function(state)
    espActive = state
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if espActive then
                local Highlight = player.Character:FindFirstChild("szx_Highlight") or Instance.new("Highlight")
                Highlight.Name = "szx_Highlight"
                Highlight.FillColor = Color3.fromRGB(0, 255, 150)
                Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                Highlight.Parent = player.Character
            else
                if player.Character:FindFirstChild("szx_Highlight") then
                    player.Character.szx_Highlight:Destroy()
                end
            end
        end
    end
end)

-- SEÇÃO TELEPORTE
local tpSection = Instance.new("TextLabel")
tpSection.Size = UDim2.new(1, -20, 0, 30)
tpSection.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
tpSection.TextColor3 = Color3.fromRGB(255, 255, 255)
tpSection.TextSize = 16
tpSection.Font = Enum.Font.GothamBold
tpSection.Text = "📍 TELEPORTE"
tpSection.Parent = scrollFrame

local tpCorner = Instance.new("UICorner")
tpCorner.CornerRadius = UDim.new(0, 8)
tpCorner.Parent = tpSection

createButton(scrollFrame, "📍 Teleportar Mais Próximo", function()
    local target = nil
    local maxDist = math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
            if dist < maxDist then
                maxDist = dist
                target = p
            end
        end
    end
    if target and LocalPlayer.Character then
        LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
    end
end)

-- SEÇÃO ATAQUE
local atkSection = Instance.new("TextLabel")
atkSection.Size = UDim2.new(1, -20, 0, 30)
atkSection.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
atkSection.TextColor3 = Color3.fromRGB(255, 255, 255)
atkSection.TextSize = 16
atkSection.Font = Enum.Font.GothamBold
atkSection.Text = "💥 ATAQUE"
atkSection.Parent = scrollFrame

local atkCorner = Instance.new("UICorner")
atkCorner.CornerRadius = UDim.new(0, 8)
atkCorner.Parent = atkSection

createButton(scrollFrame, "🌪️ Fling Mais Próximo", function()
    local target = nil
    local maxDist = math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
            if dist < maxDist then
                maxDist = dist
                target = p
            end
        end
    end
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local humanoidRootPart = target.Character.HumanoidRootPart
        humanoidRootPart.Velocity = Vector3.new(math.random(-100, 100), math.random(50, 100), math.random(-100, 100))
    end
end)

createButton(scrollFrame, "🔄 Multi-Fling", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local humanoidRootPart = p.Character.HumanoidRootPart
            humanoidRootPart.Velocity = Vector3.new(math.random(-100, 100), math.random(50, 100), math.random(-100, 100))
            task.wait(0.1)
        end
    end
end)

-- SEÇÃO VISUAL
local visSection = Instance.new("TextLabel")
visSection.Size = UDim2.new(1, -20, 0, 30)
visSection.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
visSection.TextColor3 = Color3.fromRGB(255, 255, 255)
visSection.TextSize = 16
visSection.Font = Enum.Font.GothamBold
visSection.Text = "👁️ VISUAL"
visSection.Parent = scrollFrame

local visCorner = Instance.new("UICorner")
visCorner.CornerRadius = UDim.new(0, 8)
visCorner.Parent = visSection

createButton(scrollFrame, "📸 FOV +", function()
    Camera.FieldOfView = math.min(Camera.FieldOfView + 5, 120)
end)

createButton(scrollFrame, "📸 FOV -", function()
    Camera.FieldOfView = math.max(Camera.FieldOfView - 5, 70)
end)

createToggle(scrollFrame, "📊 FPS Counter", function(state)
    fpsCounterActive = state
end)

-- SEÇÃO INFO
local infoSection = Instance.new("TextLabel")
infoSection.Size = UDim2.new(1, -20, 0, 30)
infoSection.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
infoSection.TextColor3 = Color3.fromRGB(255, 255, 255)
infoSection.TextSize = 14
infoSection.Font = Enum.Font.Gotham
infoSection.Text = "📊 FPS: " .. fpsCounter .. " | Velocidade: " .. walkSpeed
infoSection.Parent = scrollFrame

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 8)
infoCorner.Parent = infoSection

-- Atualizar info em tempo real
RunService.RenderStepped:Connect(function()
    infoSection.Text = "📊 FPS: " .. fpsCounter .. " | Velocidade: " .. walkSpeed
end)

-- ============= FECHAR MENU COM ESC =============
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Escape then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

-- ============= MENSAGEM =============
print("✨ SZX HUB ROXO CARREGADO! ✨")
print("Pressione ESC para mostrar/esconder o menu")
