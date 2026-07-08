-- Carrega a biblioteca Rayfield atualizada
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- APLICAR TEMA ROXO NO RAYFIELD
local Window = Rayfield:CreateWindow({
   Name = "✨ szx hub | Premium Edition ✨",
   LoadingTitle = "Iniciando szx hub...",
   LoadingSubtitle = "Preparando ambiente e funções...",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "szx_hub_premium",
      FileName = "configuracao"
   },
   Discord = {
      Enabled = false,
      Invite = "",
      RememberJoins = true
   },
   KeySystem = false
})

-- APLICAR TEMA ROXO
pcall(function()
    Window.UI.Window.BackgroundColor3 = Color3.fromRGB(45, 0, 60)
    Window.UI.Window.BackgroundTransparency = 0.1
    
    -- Colorir abas roxo
    for _, tab in pairs(Window.UI.Tabs:GetChildren()) do
        if tab:IsA("TextButton") then
            tab.BackgroundColor3 = Color3.fromRGB(80, 0, 120)
            tab.TextColor3 = Color3.fromRGB(220, 180, 255)
        end
    end
end)

-- SERVIÇOS DO ROBLOX
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")

-- VERIFICAR SE É MOBILE
local isMobile = UserInputService:GetLastInputType() == Enum.UserInputType.Touch or 
                 game:GetService("GuiService"):IsTenFootInterface()

-- ABAS
local TabMovimento = Window:CreateTab("Movimento", "rewind")
local TabCombate = Window:CreateTab("Combate & Visual", "swords")
local TabTeleporte = Window:CreateTab("Teleportes", "map-pin")
local TabJogadores = Window:CreateTab("Painel de Jogadores", "users")
local TabVisual = Window:CreateTab("Visual & Camera", "eye")
local TabDesempenho = Window:CreateTab("Desempenho", "chart-bar")

-- VARIÁVEIS DE ESTADO
local noclipActive = false
local killAuraActive = false
local antiFlingActive = false
local espActive = false
local killAuraRadius = 15
local fpsLimit = 60
local fpsCounterActive = false
local flingActive = false
local flyCam = false
local flySpeed = 1
local flyCamHeight = 10

-- FPS Counter
local fpsCounter = 0
local lastFpsUpdate = 0
RunService.RenderStepped:Connect(function(deltaTime)
    fpsCounter = math.floor(1 / deltaTime)
    lastFpsUpdate = lastFpsUpdate + deltaTime
end)

-- FPS Performance Monitor
local FPSLabel = TabDesempenho:CreateLabel("FPS: 0")
local function updateFPSDisplay()
    while fpsCounterActive do
        FPSLabel:Set("🎮 FPS: " .. fpsCounter .. " | Limite: " .. fpsLimit)
        task.wait(0.5)
    end
    FPSLabel:Set("📊 FPS Counter desativado")
end

-- KILL AURA
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

-- NOCLIP
RunService.Stepped:Connect(function()
    if noclipActive and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- ANTI-FLING DETECTOR
RunService.Heartbeat:Connect(function()
    if antiFlingActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local humanoidRootPart = LocalPlayer.Character.HumanoidRootPart
        local velocity = humanoidRootPart.Velocity.Magnitude
        if velocity > 100 then
            humanoidRootPart.Velocity = Vector3.new(0, humanoidRootPart.Velocity.Y, 0)
        end
    end
end)

-- CONTROLES MOBILE - JOYSTICK VIRTUAL
local mobileJoystick = nil
if isMobile then
    local screenSize = game:GetService("GuiService"):GetScreenSize()
    local joystickSize = 80
    
    mobileJoystick = Instance.new("Folder")
    mobileJoystick.Name = "MobileJoystick"
    mobileJoystick.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    local mainGui = Instance.new("ScreenGui")
    mainGui.Name = "JoystickGui"
    mainGui.ResetOnSpawn = false
    mainGui.Parent = mobileJoystick
    
    -- Joystick Background (ROXO)
    local bgJoystick = Instance.new("Frame")
    bgJoystick.Name = "BackgroundJoystick"
    bgJoystick.Size = UDim2.new(0, joystickSize, 0, joystickSize)
    bgJoystick.Position = UDim2.new(0, 20, 1, -joystickSize - 20)
    bgJoystick.BackgroundColor3 = Color3.fromRGB(100, 0, 150)
    bgJoystick.BackgroundTransparency = 0.5
    bgJoystick.BorderSizePixel = 0
    bgJoystick.Parent = mainGui
    
    local corner1 = Instance.new("UICorner")
    corner1.CornerRadius = UDim.new(0, 40)
    corner1.Parent = bgJoystick
    
    -- Joystick Thumb (ROXO CLARO)
    local thumbJoystick = Instance.new("Frame")
    thumbJoystick.Name = "ThumbJoystick"
    thumbJoystick.Size = UDim2.new(0, 40, 0, 40)
    thumbJoystick.Position = UDim2.new(0.5, -20, 0.5, -20)
    thumbJoystick.BackgroundColor3 = Color3.fromRGB(200, 100, 255)
    thumbJoystick.BorderSizePixel = 0
    thumbJoystick.Parent = bgJoystick
    
    local corner2 = Instance.new("UICorner")
    corner2.CornerRadius = UDim.new(0, 20)
    corner2.Parent = thumbJoystick
    
    -- Botão de ataque (lado direito)
    local attackButton = Instance.new("TextButton")
    attackButton.Name = "AttackButton"
    attackButton.Size = UDim2.new(0, 70, 0, 70)
    attackButton.Position = UDim2.new(1, -90, 1, -90)
    attackButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    attackButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    attackButton.TextSize = 24
    attackButton.Text = "⚔️"
    attackButton.BorderSizePixel = 0
    attackButton.Parent = mainGui
    
    local cornerAttack = Instance.new("UICorner")
    cornerAttack.CornerRadius = UDim.new(0, 35)
    cornerAttack.Parent = attackButton
    
    -- Botão de abilidade (direita)
    local abilityButton = Instance.new("TextButton")
    abilityButton.Name = "AbilityButton"
    abilityButton.Size = UDim2.new(0, 70, 0, 70)
    abilityButton.Position = UDim2.new(1, -90, 1, -170)
    abilityButton.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    abilityButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    abilityButton.TextSize = 24
    abilityButton.Text = "🔥"
    abilityButton.BorderSizePixel = 0
    abilityButton.Parent = mainGui
    
    local cornerAbility = Instance.new("UICorner")
    cornerAbility.CornerRadius = UDim.new(0, 35)
    cornerAbility.Parent = abilityButton
    
    -- Controlar movimento do joystick
    local joystickActive = false
    local joystickConnection
    
    bgJoystick.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.Touch then
            joystickActive = true
        end
    end)
    
    bgJoystick.InputEnded:Connect(function(input, gameProcessed)
        if input.UserInputType == Enum.UserInputType.Touch then
            joystickActive = false
            thumbJoystick:TweenPosition(UDim2.new(0.5, -20, 0.5, -20), "Out", "Quad", 0.1, true)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input, gameProcessed)
        if joystickActive and input.UserInputType == Enum.UserInputType.Touch then
            local touchPos = input.Position
            local bgPos = bgJoystick.AbsolutePosition
            local bgSize = bgJoystick.AbsoluteSize
            
            local relativeX = touchPos.X - (bgPos.X + bgSize.X / 2)
            local relativeY = touchPos.Y - (bgPos.Y + bgSize.Y / 2)
            
            local magnitude = math.sqrt(relativeX^2 + relativeY^2)
            local maxDistance = bgSize.X / 2 - 20
            
            if magnitude > maxDistance then
                relativeX = (relativeX / magnitude) * maxDistance
                relativeY = (relativeY / magnitude) * maxDistance
            end
            
            thumbJoystick.Position = UDim2.new(0.5, relativeX - 20, 0.5, relativeY - 20)
            
            -- Aplicar movimento
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then
                    local moveDirection = Vector3.new(relativeX, 0, relativeY).Unit * 0.5
                    humanoid:MoveTo(LocalPlayer.Character.HumanoidRootPart.Position + moveDirection * 2)
                end
            end
        end
    end)
    
    -- Botão de ataque
    attackButton.MouseButton1Down:Connect(function()
        if LocalPlayer.Character then
            local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
        end
    end)
end

-- ==================== MOVIMENTO ====================
TabMovimento:CreateSlider({
   Name = "Velocidade Ajustável",
   Min = 16,
   Max = 250,
   DefaultValue = 16,
   Increment = 1,
   ValueName = "WalkSpeed",
   Callback = function(Value)
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
          LocalPlayer.Character.Humanoid.WalkSpeed = Value
      end
   end,
})

TabMovimento:CreateToggle({
   Name = "✨ Ativar NoClip",
   CurrentValue = false,
   Callback = function(Value)
      noclipActive = Value
   end,
})

TabMovimento:CreateToggle({
   Name = "👻 Invisibilidade Local",
   CurrentValue = false,
   Callback = function(Value)
      if LocalPlayer.Character then
          for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
              if part:IsA("BasePart") or part:IsA("Decal") then
                  part.Transparency = Value and 0.5 or 0
              end
          end
      end
   end,
})

TabMovimento:CreateToggle({
   Name = "🛡️ Anti-Fling",
   CurrentValue = false,
   Callback = function(Value)
      antiFlingActive = Value
      if Value then
          Rayfield:Notify({Name = "Segurança", Content = "Anti-Fling Ativado!", Duration = 2})
      end
   end,
})

TabMovimento:CreateSlider({
   Name = "Jump Power",
   Min = 50,
   Max = 200,
   DefaultValue = 50,
   Increment = 5,
   ValueName = "JumpPower",
   Callback = function(Value)
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
          LocalPlayer.Character.Humanoid.JumpPower = Value
      end
   end,
})

if not isMobile then
    TabMovimento:CreateToggle({
       Name = "🚀 Voo de Câmera",
       CurrentValue = false,
       Callback = function(Value)
          flyCam = Value
          if Value then
              RunService.RenderStepped:Connect(function()
                  if not flyCam then return end
                  
                  local moveDirection = Vector3.new(0, 0, 0)
                  
                  if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                      moveDirection = moveDirection + (Camera.CFrame.LookVector)
                  end
                  if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                      moveDirection = moveDirection - (Camera.CFrame.LookVector)
                  end
                  if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                      moveDirection = moveDirection - (Camera.CFrame.RightVector)
                  end
                  if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                      moveDirection = moveDirection + (Camera.CFrame.RightVector)
                  end
                  if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                      moveDirection = moveDirection + Vector3.new(0, 1, 0)
                  end
                  if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                      moveDirection = moveDirection - Vector3.new(0, 1, 0)
                  end
                  
                  if moveDirection.Magnitude > 0 then
                      Camera.CFrame = Camera.CFrame + (moveDirection.Unit * flySpeed)
                  end
              end)
          end
       end,
    })

    TabMovimento:CreateSlider({
       Name = "Velocidade do Voo",
       Min = 0.5,
       Max = 3,
       DefaultValue = 1,
       Increment = 0.1,
       ValueName = "VooSpeed",
       Callback = function(Value)
          flySpeed = Value
       end,
    })
end

-- ==================== COMBATE ====================
TabCombate:CreateToggle({
   Name = "⚔️ Kill Aura",
   CurrentValue = false,
   Callback = function(Value)
      killAuraActive = Value
   end,
})

TabCombate:CreateSlider({
   Name = "Alcance da Aura",
   Min = 5,
   Max = 50,
   DefaultValue = 15,
   Increment = 1,
   ValueName = "Studs",
   Callback = function(Value)
      killAuraRadius = Value
   end,
})

TabCombate:CreateToggle({
   Name = "👁️ ESP",
   CurrentValue = false,
   Callback = function(Value)
      espActive = Value
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
   end,
})

TabCombate:CreateToggle({
   Name = "📦 Expandir Hitboxes",
   CurrentValue = false,
   Callback = function(Value)
      for _, player in pairs(Players:GetPlayers()) do
          if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
              player.Character.HumanoidRootPart.Size = Value and Vector3.new(12, 12, 12) or Vector3.new(2, 2, 2)
              player.Character.HumanoidRootPart.Transparency = Value and 0.6 or 1
          end
      end
   end,
})

TabCombate:CreateSlider({
   Name = "FOV",
   Min = 70,
   Max = 120,
   DefaultValue = 70,
   Increment = 1,
   ValueName = "FOV",
   Callback = function(Value)
      Camera.FieldOfView = Value
   end,
})

-- ==================== TELEPORTES ====================
TabTeleporte:CreateButton({
   Name = "📍 Teleportar ao Mais Próximo",
   Callback = function()
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
      if target then
          LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
          Rayfield:Notify({Name = "Sucesso", Content = "Teleportado!", Duration = 2})
      end
   end,
})

TabTeleporte:CreateButton({
   Name = "🎒 Coletar Itens",
   Callback = function()
      local count = 0
      for _, v in pairs(workspace:GetDescendants()) do
          if v:IsA("TouchTransmitter") and v.Parent and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
              firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v.Parent, 0)
              task.wait(0.02)
              firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v.Parent, 1)
              count = count + 1
          end
      end
      Rayfield:Notify({Name = "Coletor", Content = "Coletados " .. count .. " itens!", Duration = 2})
   end,
})

-- Teleporte Customizado
TabTeleporte:CreateInput({
   Name = "Teleportar para Coordenadas",
   PlaceholderText = "X, Y, Z",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      local coords = {}
      for num in Text:gmatch("[^,]+") do
          table.insert(coords, tonumber(num:match("^%s*(.-)%s*$")))
      end
      if coords[1] and coords[2] and coords[3] then
          if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
              LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(coords[1], coords[2], coords[3])
              Rayfield:Notify({Name = "Teleporte", Content = "Teleportado para " .. Text, Duration = 2})
          end
      else
          Rayfield:Notify({Name = "Erro", Content = "Formato inválido! Use: X, Y, Z", Duration = 2})
      end
   end,
})

-- ==================== PAINEL JOGADORES ====================
TabJogadores:CreateButton({
   Name = "🌪️ Fling Attack",
   Callback = function()
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
          Rayfield:Notify({Name = "Fling", Content = "Ataque executado!", Duration = 2})
      end
   end,
})

TabJogadores:CreateButton({
   Name = "🔄 Multi-Fling",
   Callback = function()
      for _, p in pairs(Players:GetPlayers()) do
          if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
              local humanoidRootPart = p.Character.HumanoidRootPart
              humanoidRootPart.Velocity = Vector3.new(math.random(-100, 100), math.random(50, 100), math.random(-100, 100))
              task.wait(0.1)
          end
      end
      Rayfield:Notify({Name = "Multi-Fling", Content = "Todos foram atacados!", Duration = 2})
   end,
})

-- ==================== VISUAL & CAMERA ====================
TabVisual:CreateToggle({
   Name = "🌈 Modo Arco-Íris",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
          task.spawn(function()
              local hue = 0
              while Value do
                  Camera.FieldOfView = 70 + math.sin(hue) * 5
                  hue = hue + 0.02
                  task.wait(0.05)
              end
          end)
      end
   end,
})

if not isMobile then
    TabVisual:CreateToggle({
       Name = "🌙 Zoom Dinâmico",
       CurrentValue = false,
       Callback = function(Value)
          if Value then
              task.spawn(function()
                  local scrollWheelConnection
                  scrollWheelConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                      if gameProcessed then return end
                      if input.UserInputType == Enum.UserInputType.MouseWheel then
                          local fov = Camera.FieldOfView
                          if input.Position.Z > 0 then
                              Camera.FieldOfView = math.max(1, fov - 5)
                          else
                              Camera.FieldOfView = math.min(120, fov + 5)
                          end
                      end
                  end)
              end)
          end
       end,
    })
end

-- ==================== DESEMPENHO ====================
TabDesempenho:CreateToggle({
   Name = "📊 Mostrar FPS",
   CurrentValue = false,
   Callback = function(Value)
      fpsCounterActive = Value
      if Value then
          task.spawn(updateFPSDisplay)
      end
   end,
})

TabDesempenho:CreateSlider({
   Name = "Limite de FPS",
   Min = 30,
   Max = 240,
   DefaultValue = 60,
   Increment = 10,
   ValueName = "FPS",
   Callback = function(Value)
      fpsLimit = Value
      RunService:Set3dRenderingEnabled(true)
   end,
})

TabDesempenho:CreateLabel("⚙️ Otimizações do Sistema")

TabDesempenho:CreateButton({
   Name = "🧹 Limpar Cache",
   Callback = function()
      collectgarbage("collect")
      Rayfield:Notify({Name = "Cache", Content = "Cache limpo!", Duration = 2})
   end,
})

if isMobile then
    TabDesempenho:CreateLabel("📱 Modo Mobile Ativado")
    TabDesempenho:CreateLabel("Use o joystick para andar")
    TabDesempenho:CreateLabel("Botões de ataque à direita")
else
    TabDesempenho:CreateLabel("💻 Versão PC Completa")
end

TabDesempenho:CreateLabel("Versão: 2.6 | ROXO + Mobile")

Rayfield:Notify({Name = "SZX Hub", Content = "✨ Menu roxo ativado! Use com cuidado.", Duration = 3})
