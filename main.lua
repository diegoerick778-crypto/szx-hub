-- SZX HUB v5.0 - Menu RGB com Barra Lateral Deslizável
-- Interface Moderna, Colorida e SUPER Funcional

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- ============= CRIAR GUI RGB =============
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SZXHubGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Frame Principal com RGB
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 280, 0, 400)
mainFrame.Position = UDim2.new(0.02, 0, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 0, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Stroke RGB animado
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(255, 0, 0)
stroke.Thickness = 2
stroke.Parent = mainFrame

-- Canto Arredondado
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Barra Lateral RGB Deslizável
local sideBar = Instance.new("Frame")
sideBar.Name = "SideBar"
sideBar.Size = UDim2.new(0, 4, 1, 0)
sideBar.Position = UDim2.new(0, 0, 0, 0)
sideBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
sideBar.BorderSizePixel = 0
sideBar.Parent = mainFrame

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(0, 2)
barCorner.Parent = sideBar

-- Header RGB
local headerFrame = Instance.new("Frame")
headerFrame.Name = "Header"
headerFrame.Size = UDim2.new(1, 0, 0, 35)
headerFrame.Position = UDim2.new(0, 0, 0, 0)
headerFrame.BackgroundColor3 = Color3.fromRGB(100, 0, 150)
headerFrame.BorderSizePixel = 0
headerFrame.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = headerFrame

-- Gradiente no Header
local headerGradient = Instance.new("UIGradient")
headerGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 0, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 150, 255))
})
headerGradient.Parent = headerFrame

-- Título
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(0.7, 0, 1, 0)
titleLabel.Position = UDim2.new(0, 8, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 16
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "✨ SZX HUB ✨"
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = headerFrame

-- Botão fechar
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -32, 0, 2)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = "X"
closeBtn.BorderSizePixel = 0
closeBtn.Parent = headerFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- Scroll Frame
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "ScrollFrame"
scrollFrame.Size = UDim2.new(1, 0, 1, -35)
scrollFrame.Position = UDim2.new(0, 0, 0, 35)
scrollFrame.BackgroundColor3 = Color3.fromRGB(20, 0, 35)
scrollFrame.BorderSizePixel = 0
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 900)
scrollFrame.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 6)
listLayout.Parent = scrollFrame

local padding = Instance.new("UIPadding")
padding.PaddingLeft = UDim.new(0, 8)
padding.PaddingRight = UDim.new(0, 8)
padding.PaddingTop = UDim.new(0, 8)
padding.PaddingBottom = UDim.new(0, 8)
padding.Parent = scrollFrame

-- ============= ANIMAÇÃO RGB =============
local rgbHue = 0
task.spawn(function()
    while true do
        rgbHue = (rgbHue + 0.005) % 1
        
        -- Animar stroke
        stroke.Color = Color3.fromHSV(rgbHue, 1, 1)
        
        -- Animar sidebar
        sideBar.BackgroundColor3 = Color3.fromHSV(rgbHue, 1, 1)
        
        -- Animar header gradient
        headerGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHSV(rgbHue, 1, 1)),
            ColorSequenceKeypoint.new(0.5, Color3.fromHSV((rgbHue + 0.3) % 1, 1, 1)),
            ColorSequenceKeypoint.new(1, Color3.fromHSV((rgbHue + 0.6) % 1, 1, 1))
        })
        
        task.wait(0.05)
    end
end)

-- ============= FAZER MOVÍVEL =============
local dragging = false
local dragStart = nil
local startPos = nil

headerFrame.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input, gameProcessed)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ============= VARIÁVEIS =============
local noclipActive = false
local killAuraActive = false
local espActive = false
local antiFlingActive = false
local invisibleActive = false
local walkSpeed = 16
local fpsCounter = 0
local killAuraRadius = 15
local jumpPower = 50

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
    elseif not noclipActive and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
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

-- ============= ATUALIZAR VELOCIDADE =============
LocalPlayer.CharacterAdded:Connect(function(newChar)
    task.wait(0.1)
    if newChar:FindFirstChild("Humanoid") then
        newChar.Humanoid.WalkSpeed = walkSpeed
        newChar.Humanoid.JumpPower = jumpPower
    end
end)

if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
    LocalPlayer.Character.Humanoid.WalkSpeed = walkSpeed
    LocalPlayer.Character.Humanoid.JumpPower = jumpPower
end

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
                    end
                end
            end
        else
            SelectionSphere.Parent = nil
        end
    end
end)

-- ============= FUNÇÃO CRIAR BOTÃO RGB =============
local function createButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(50, 0, 80)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.Font = Enum.Font.Gotham
    btn.Text = text
    btn.BorderSizePixel = 0
    btn.Parent = parent
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    local btnGradient = Instance.new("UIGradient")
    btnGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 0, 200)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 0, 150))
    })
    btnGradient.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        callback()
        btn.BackgroundColor3 = Color3.fromRGB(100, 50, 150)
        task.wait(0.1)
        btn.BackgroundColor3 = Color3.fromRGB(50, 0, 80)
    end)
    
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(100, 0, 180)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(50, 0, 80)
    end)
    
    return btn
end

-- ============= FUNÇÃO CRIAR TOGGLE RGB =============
local function createToggle(parent, text, onToggle)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 32)
    container.BackgroundColor3 = Color3.fromRGB(40, 0, 70)
    container.BorderSizePixel = 0
    container.Parent = parent
    
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 6)
    containerCorner.Parent = container
    
    local containerGradient = Instance.new("UIGradient")
    containerGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 0, 180)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 0, 100))
    })
    containerGradient.Parent = container
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, -5, 1, 0)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 12
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 35, 0, 20)
    toggleBtn.Position = UDim2.new(0.6, 0, 0.5, -10)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    toggleBtn.Text = "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextSize = 10
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Parent = container
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 4)
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

-- ============= BOTÕES DO MENU =============

-- MOVIMENTO
createToggle(scrollFrame, "✨ NoClip", function(state)
    noclipActive = state
end)

createButton(scrollFrame, "⬆️ +10 Velocidade", function()
    walkSpeed = math.min(walkSpeed + 10, 250)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = walkSpeed
    end
end)

createButton(scrollFrame, "⬇️ -10 Velocidade", function()
    walkSpeed = math.max(walkSpeed - 10, 16)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = walkSpeed
    end
end)

createButton(scrollFrame, "🔄 Reset Velocidade", function()
    walkSpeed = 16
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

createToggle(scrollFrame, "👻 Invisível", function(state)
    invisibleActive = state
    if LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                part.Transparency = state and 0.7 or 0
            end
        end
    end
end)

createButton(scrollFrame, "⬆️ +10 Jump", function()
    jumpPower = math.min(jumpPower + 10, 200)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = jumpPower
    end
end)

createButton(scrollFrame, "⬇️ -10 Jump", function()
    jumpPower = math.max(jumpPower - 10, 50)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = jumpPower
    end
end)

createToggle(scrollFrame, "🛡️ Anti-Fling", function(state)
    antiFlingActive = state
end)

-- COMBATE
createToggle(scrollFrame, "⚔️ Kill Aura", function(state)
    killAuraActive = state
end)

createButton(scrollFrame, "📈 +5 Aura", function()
    killAuraRadius = math.min(killAuraRadius + 5, 50)
end)

createButton(scrollFrame, "📉 -5 Aura", function()
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
                Highlight.Parent = player.Character
            else
                if player.Character:FindFirstChild("szx_Highlight") then
                    player.Character.szx_Highlight:Destroy()
                end
            end
        end
    end
end)

createToggle(scrollFrame, "📦 Expandir HB", function(state)
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.Size = state and Vector3.new(12, 12, 12) or Vector3.new(2, 2, 2)
        end
    end
end)

-- TELEPORTE
createButton(scrollFrame, "📍 TP Mais Próximo", function()
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

-- ATAQUE
createButton(scrollFrame, "🌪️ Fling", function()
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
        local hrp = target.Character.HumanoidRootPart
        hrp.Velocity = Vector3.new(math.random(-100, 100), math.random(50, 100), math.random(-100, 100))
    end
end)

createButton(scrollFrame, "🔄 Multi-Fling", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = p.Character.HumanoidRootPart
            hrp.Velocity = Vector3.new(math.random(-100, 100), math.random(50, 100), math.random(-100, 100))
            task.wait(0.05)
        end
    end
end)

-- VISUAL
createButton(scrollFrame, "📸 FOV +5", function()
    Camera.FieldOfView = math.min(Camera.FieldOfView + 5, 120)
end)

createButton(scrollFrame, "📸 FOV -5", function()
    Camera.FieldOfView = math.max(Camera.FieldOfView - 5, 70)
end)

-- INFO
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, 0, 0, 40)
infoLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
infoLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
infoLabel.TextSize = 11
infoLabel.Font = Enum.Font.Gotham
infoLabel.Text = "FPS: 0"
infoLabel.TextWrapped = true
infoLabel.Parent = scrollFrame

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 6)
infoCorner.Parent = infoLabel

local infoGradient = Instance.new("UIGradient")
infoGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 100)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 60))
})
infoGradient.Parent = infoLabel

RunService.RenderStepped:Connect(function()
    infoLabel.Text = "FPS: " .. fpsCounter .. "\nVEL: " .. walkSpeed .. " | JUMP: " .. jumpPower .. "\nAURA: " .. killAuraRadius
end)

-- ============= ABRIR MENU COM ESC =============
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Escape then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

print("✨ SZX HUB v5.0 RGB CARREGADO!")
print("Menu RGB animado com barra lateral deslizável!")
print("Pressione ESC para abrir/fechar")
