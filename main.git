-- Carrega a biblioteca Rayfield atualizada e limpa instâncias antigas se houver
local Rayfield = loadstring(game:HttpGet('https://sirius.menu'))()

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

-- ABAS COM ÍCONES ATRAENTES
local TabMovimento = Window:CreateTab("Movimento", "rewind") -- Ícone de velocidade/movimento
local TabCombate = Window:CreateTab("Combate & Visual", "swords") -- Ícone de combate
local TabTeleporte = Window:CreateTab("Teleportes", "map-pin") -- Ícone de localização
local TabJogadores = Window:CreateTab("Painel de Jogadores", "users") -- Ícone de comunidade

-- VARIÁVEIS DE ESTADO
local noclipActive = false
local killAuraActive = false
local antiFlingActive = false
local espActive = false
local killAuraRadius = 15

-- LABELS FLUTUANTES (AMIGÁVEIS PARA O USUÁRIO)
local FPSLabel = TabCombate:CreateLabel("Medidor de Desempenho desativado")

-- SISTEMA ATUALIZÁVEL DE FPS (Roda em segundo plano de forma otimizada)
local fpsCounter = 0
RunService.RenderStepped:Connect(function(deltaTime)
    fpsCounter = math.floor(1 / deltaTime)
end)

-- LOOP DO KILL AURA COM SELECTION SPHERE
local SelectionSphere = Instance.new("SelectionSphere")
SelectionSphere.Color3 = Color3.fromRGB(255, 60, 60)
SelectionSphere.Transparency = 0.5

task.spawn(function()
    while task.wait(0.1) do
        if killAuraActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            -- Posiciona o círculo visual perfeitamente no jogador
            SelectionSphere.Parent = LocalPlayer.Character.HumanoidRootPart
            SelectionSphere.Adornee = LocalPlayer.Character.HumanoidRootPart
            
            -- Detecta inimigos próximos dentro do raio definido
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character:FindFirstChild("HumanoidRootPart") then
                    local distance = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                    if distance <= killAuraRadius and player.Character.Humanoid.Health > 0 then
                        -- Lógica universal de ataque simulado (pode ser adaptada para ferramentas do seu jogo)
                        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                        if tool then 
                            tool:Activate() 
                        end
                        -- Altera sutilmente a cor para indicar que está batendo
                        SelectionSphere.Color3 = Color3.fromRGB(255, 0, 0)
                    end
                end
            end
        else
            SelectionSphere.Parent = nil
        end
    end
end)

-- LOOP DO NOCLIP SEGURO
RunService.Stepped:Connect(function()
    if noclipActive and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- ==================== 1. ABA MOVIMENTO ====================
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
   Name = "✨ Ativar NoClip (Atravessar Paredes)",
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
                  part.Transparency = Value and 0.5 or 0 -- 0.5 deixa você fantasma para você mesmo não se perder
              end
          end
      end
   end,
})

TabMovimento:CreateToggle({
   Name = "🛡️ Proteção Anti-Fling",
   CurrentValue = false,
   Callback = function(Value)
      antiFlingActive = Value
      if Value then
          Rayfield:Notify({Name = "Segurança", Content = "Anti-Fling Ativado!", Duration = 2})
      end
   end,
})

-- ==================== 2. ABA COMBATE & VISUAL ====================
TabCombate:CreateToggle({
   Name = "⚔️ Ativar Kill Aura",
   CurrentValue = false,
   Callback = function(Value)
      killAuraActive = Value
   end,
})

TabCombate:CreateSlider({
   Name = "Alcance da Aura (Raio do Círculo)",
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
   Name = "👁️ ESP (Ver Jogadores pelas Paredes)",
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
   Name = "📦 Expandir Hitboxes dos Inimigos",
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
   Name = "📊 Exibir Contador de FPS",
   CurrentValue = false,
   Callback = function(Value)
      task.spawn(function()
          while Value do
              FPSLabel:Set("Taxa de Quadros Atual: " .. fpsCounter .. " FPS")
              task.wait(0.5)
          end
          FPSLabel:Set("Medidor de Desempenho desativado")
      end)
   end,
})

TabCombate:CreateSlider({
   Name = "Ajuste de Tela (FOV / Esticar)",
   Min = 70,
   Max = 120,
   DefaultValue = 70,
   Increment = 1,
   ValueName = "FOV",
   Callback = function(Value)
      Camera.FieldOfView = Value
   end,
})

-- ==================== 3. ABA TELEPORTES ====================
TabTeleporte:CreateButton({
   Name = "📍 Teleportar ao Jogador Mais Próximo (tp)",
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
          Rayfield:Notify({Name = "Sucesso", Content = "Teleportado para: " .. target.DisplayName, Duration = 2})
      end
   end,
})

TabTeleporte:CreateButton({
   Name = "🎒 Coletar Itens Automaticamente (Touch)",
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
      Rayfield:Notify({Name = "Coletor", Content = "Interagiu com " .. count .. " itens com sucesso!", Duration = 2})
   end,
})

-- ==================== 4. ABA PAINEL JOGADORES ====================
TabJogadores:CreateButton({
   Name = "🌪️ Executar Ataque Fling (Empurrar Longe)",
   Callback = function()
      -- Executa uma força física rotacional extrema para empurrar o jogador mais próximo para longe
      local target = nil
      local maxDist = math.huge
      for _, p in pairs(Players:GetPlayers()) do
          if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
              local dist = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
              if dist < maxDist then maxDist = dist target = p end
          end
      end

      
