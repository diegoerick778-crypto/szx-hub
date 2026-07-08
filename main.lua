-- Carrega a biblioteca Rayfield atualizada
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

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

-- SERVIÇOS DO ROBLOX
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera

-- ABAS
local TabMovimento = Window:CreateTab("Movimento", "rewind")
local TabCombate = Window:CreateTab("Combate & Visual", "swords")
local TabTeleporte = Window:CreateTab("Teleportes", "map-pin")
local TabJogadores = Window:CreateTab("Painel de Jogadores", "users")

-- VARIÁVEIS DE ESTADO
local noclipActive = false
local killAuraActive = false
local antiFlingActive = false
local espActive = false
local killAuraRadius = 15

local FPSLabel = TabCombate:CreateLabel("Medidor de Desempenho desativado")

-- FPS Counter
local fpsCounter = 0
RunService.RenderStepped:Connect(function(deltaTime)
    fpsCounter = math.floor(1 / deltaTime)
end)

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

TabCombate:CreateToggle({
   Name = "📊 FPS",
   CurrentValue = false,
   Callback = function(Value)
      task.spawn(function()
          while Value do
              FPSLabel:Set("FPS: " .. fpsCounter)
              task.wait(0.5)
          end
          FPSLabel:Set("Medidor desativado")
      end)
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
