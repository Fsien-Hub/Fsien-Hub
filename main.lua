-- Fsien Hub - Delta Executor için (Son Versiyon - Tüm Özellikler Stabil)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Fsien Hub",
   LoadingTitle = "Yükleniyor...",
   LoadingSubtitle = "by Fsien",
   ConfigurationSaving = {Enabled = true, FolderName = "FsienHub", FileName = "Config"},
   KeySystem = false,
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Discord mesajı (sağ alt, 10 saniye sonra kaybolur)
spawn(function()
   local gui = Instance.new("ScreenGui")
   gui.Parent = game.CoreGui
   gui.ResetOnSpawn = false

   local frame = Instance.new("Frame")
   frame.Size = UDim2.new(0, 350, 0, 60)
   frame.Position = UDim2.new(1, -360, 1, -70)
   frame.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
   frame.BackgroundTransparency = 0.3
   frame.BorderSizePixel = 0
   frame.Parent = gui

   local corner = Instance.new("UICorner")
   corner.CornerRadius = UDim.new(0, 10)
   corner.Parent = frame

   local text = Instance.new("TextLabel")
   text.Size = UDim2.new(1, 0, 1, 0)
   text.BackgroundTransparency = 1
   text.Text = "Discord Sunucumuza Gelmeyi Unutmayın!"
   text.TextColor3 = Color3.fromRGB(200, 255, 200)
   text.TextStrokeTransparency = 0.8
   text.TextStrokeColor3 = Color3.fromRGB(0, 255, 0)
   text.Font = Enum.Font.GothamBold
   text.TextSize = 20
   text.TextWrapped = true
   text.Parent = frame

   -- Fade in + 10 saniye sonra fade out
   frame.BackgroundTransparency = 1
   text.TextTransparency = 1
   TweenService:Create(frame, TweenInfo.new(1, Enum.EasingStyle.Sine), {BackgroundTransparency = 0.3}):Play()
   TweenService:Create(text, TweenInfo.new(1, Enum.EasingStyle.Sine), {TextTransparency = 0}):Play()

   wait(10)
   TweenService:Create(frame, TweenInfo.new(1, Enum.EasingStyle.Sine), {BackgroundTransparency = 1}):Play()
   TweenService:Create(text, TweenInfo.new(1, Enum.EasingStyle.Sine), {TextTransparency = 1}):Play()
   wait(1)
   gui:Destroy()
end)

-- Universal Hileler Tab
local UniTab = Window:CreateTab("Universal Hileler")

-- Mobil Tap Fly
local flySpeed = 50
local flying = false
local flyBV, flyBG, flyConnection
local flyGui = nil
local moveDir = Vector3.new(0, 0, 0)

UniTab:CreateToggle({
   Name = "Mobil Tap Fly (Dokunmatik Panel)",
   CurrentValue = false,
   Callback = function(Value)
      flying = Value
      local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
      if not root then Rayfield:Notify({Title = "Hata", Content = "Karakter yüklenmedi!"}); return end

      if Value then
         flyBV = Instance.new("BodyVelocity")
         flyBV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
         flyBV.Velocity = Vector3.new()
         flyBV.Parent = root

         flyBG = Instance.new("BodyGyro")
         flyBG.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
         flyBG.CFrame = workspace.CurrentCamera.CFrame
         flyBG.Parent = root

         flyConnection = RunService.RenderStepped:Connect(function()
            if not flying then return end
            local cam = workspace.CurrentCamera
            flyBV.Velocity = cam.CFrame:VectorToWorldSpace(moveDir) * flySpeed
            flyBG.CFrame = cam.CFrame
         end)

         if not flyGui then
            flyGui = Instance.new("ScreenGui")
            flyGui.Parent = game.CoreGui
            flyGui.ResetOnSpawn = false

            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(0, 300, 0, 300)
            frame.Position = UDim2.new(0.5, -150, 0.75, -150)
            frame.BackgroundTransparency = 0.4
            frame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
            frame.Parent = flyGui

            local buttons = {
               {dir = Vector3.new(0, 0, -1), text = "İleri ↑", pos = UDim2.new(0.5, -40, 0.1, 0)},
               {dir = Vector3.new(0, 0, 1), text = "Geri ↓", pos = UDim2.new(0.5, -40, 0.7, 0)},
               {dir = Vector3.new(-1, 0, 0), text = "Sol ←", pos = UDim2.new(0.1, 0, 0.4, 0)},
               {dir = Vector3.new(1, 0, 0), text = "Sağ →", pos = UDim2.new(0.7, 0, 0.4, 0)},
               {dir = Vector3.new(0, 1, 0), text = "Yukarı", pos = UDim2.new(0.85, 0, 0.2, 0)},
               {dir = Vector3.new(0, -1, 0), text = "Aşağı", pos = UDim2.new(0.85, 0, 0.6, 0)},
            }

            for _, btnData in pairs(buttons) do
               local btn = Instance.new("TextButton")
               btn.Size = UDim2.new(0, 80, 0, 80)
               btn.Position = btnData.pos
               btn.Text = btnData.text
               btn.BackgroundColor3 = Color3.fromRGB(80, 80, 255)
               btn.TextColor3 = Color3.new(1,1,1)
               btn.Font = Enum.Font.GothamBold
               btn.TextSize = 20
               btn.Parent = frame

               btn.MouseButton1Down:Connect(function()
                  if flying then moveDir = moveDir + btnData.dir end
               end)

               btn.MouseButton1Up:Connect(function()
                  if flying then moveDir = moveDir - btnData.dir end
               end)
            end
         end

         Rayfield:Notify({Title = "Aktif", Content = "Mobil Fly aktif! Ekrandaki tuşlara dokun."})
      else
         if flyConnection then flyConnection:Disconnect() end
         if flyBV then flyBV:Destroy() end
         if flyBG then flyBG:Destroy() end
         if flyGui then flyGui:Destroy() end
         moveDir = Vector3.new()
         Rayfield:Notify({Title = "Kapalı", Content = "Fly kapatıldı."})
      end
   end,
})

UniTab:CreateSlider({
   Name = "Fly Hızı",
   Range = {10, 200},
   Increment = 5,
   Suffix = "Speed",
   CurrentValue = 50,
   Callback = function(Value)
      flySpeed = Value
   end,
})

-- Hitbox Expander + Kırmızı Alan
local hitboxExpanded = false
local originalSizes = {}
local redBoxes = {}

UniTab:CreateToggle({
   Name = "Hitbox Büyütme + Kırmızı Alan",
   CurrentValue = false,
   Callback = function(Value)
      hitboxExpanded = Value
      if Value then
         originalSizes = {}
         redBoxes = {}

         for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
               local root = plr.Character.HumanoidRootPart
               originalSizes[plr] = root.Size

               root.Size = Vector3.new(15, 15, 15)  -- büyütme
               root.Transparency = 0.7

               local box = Instance.new("BoxHandleAdornment")
               box.Adornee = root
               box.Size = root.Size
               box.Color3 = Color3.fromRGB(255, 0, 0)
               box.Transparency = 0.6
               box.AlwaysOnTop = true
               box.ZIndex = 10
               box.Parent = root

               redBoxes[plr] = box
            end
         end

         Rayfield:Notify({Title = "Aktif", Content = "Hitbox büyütüldü + kırmızı alan gösteriliyor!"})
      else
         for plr, size in pairs(originalSizes) do
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
               plr.Character.HumanoidRootPart.Size = size
               plr.Character.HumanoidRootPart.Transparency = 0
            end
         end

         for _, box in pairs(redBoxes) do
            if box then box:Destroy() end
         end

         originalSizes = {}
         redBoxes = {}

         Rayfield:Notify({Title = "Kapalı", Content = "Hitbox normale döndü."})
      end
   end,
})

-- Fling (düzeltilmiş - seni uçurmuyor, başkalarını uzaya atıyor)
local flingActive = false
UniTab:CreateToggle({
   Name = "Fling (Yakın Oyuncuları Uzaya Fırlat)",
   CurrentValue = false,
   Callback = function(Value)
      flingActive = Value
      if Value then
         Rayfield:Notify({Title = "Aktif", Content = "Uzaya Fling aktif! Yakın oyuncular uçuyor."})
      else
         Rayfield:Notify({Title = "Kapalı", Content = "Fling kapatıldı."})
      end
   end,
})

RunService.Heartbeat:Connect(function()
   if flingActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
      local root = LocalPlayer.Character.HumanoidRootPart
      for _, plr in pairs(Players:GetPlayers()) do
         if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local targetRoot = plr.Character.HumanoidRootPart
            local dist = (targetRoot.Position - root.Position).Magnitude
            if dist < 15 then
               local flingForce = Vector3.new(math.random(-300,300), 1500, math.random(-300,300))
               targetRoot.Velocity = flingForce
            end
         end
      end
   end
end)

-- ESP + Distance
local espConnections = {}
UniTab:CreateToggle({
   Name = "ESP (Duvar Arkasından + Distance)",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
               local highlight = Instance.new("Highlight")
               highlight.FillColor = Color3.fromRGB(255, 0, 0)
               highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
               highlight.FillTransparency = 0.5
               highlight.OutlineTransparency = 0
               highlight.Parent = plr.Character

               local billboard = Instance.new("BillboardGui")
               billboard.Adornee = plr.Character:FindFirstChild("Head") or plr.Character:FindFirstChild("HumanoidRootPart")
               billboard.Size = UDim2.new(0, 200, 0, 50)
               billboard.StudsOffset = Vector3.new(0, 3, 0)
               billboard.AlwaysOnTop = true
               billboard.Parent = plr.Character

               local text = Instance.new("TextLabel")
               text.Size = UDim2.new(1, 0, 1, 0)
               text.BackgroundTransparency = 1
               text.TextColor3 = Color3.fromRGB(255, 255, 255)
               text.TextStrokeTransparency = 0
               text.Parent = billboard

               local conn = RunService.RenderStepped:Connect(function()
                  if billboard.Adornee and billboard.Adornee.Parent then
                     local dist = (LocalPlayer.Character.HumanoidRootPart.Position - billboard.Adornee.Position).Magnitude
                     text.Text = plr.Name .. "\n" .. math.floor(dist) .. " studs"
                  end
               end)

               table.insert(espConnections, {highlight = highlight, billboard = billboard, conn = conn})
            end
         end
         Rayfield:Notify({Title = "Aktif", Content = "ESP aktif!"})
      else
         for _, conn in pairs(espConnections) do
            if conn.highlight then conn.highlight:Destroy() end
            if conn.billboard then conn.billboard:Destroy() end
            if conn.conn then conn.conn:Disconnect() end
         end
         espConnections = {}
         Rayfield:Notify({Title = "Kapalı", Content = "ESP kapatıldı."})
      end
   end,
})

-- Infinite Jump
UniTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Callback = function(Value)
      local infJumpConn
      if Value then
         infJumpConn = UserInputService.JumpRequest:Connect(function()
            if LocalPlayer.Character then
               LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
            end
         end)
         Rayfield:Notify({Title = "Aktif", Content = "Infinite Jump aktif!"})
      else
         if infJumpConn then infJumpConn:Disconnect() end
         Rayfield:Notify({Title = "Kapalı", Content = "Infinite Jump kapatıldı."})
      end
   end,
})

-- Aimbot
local aimbotTarget = nil
UniTab:CreateToggle({
   Name = "Aimbot (Kamera Kilitlenir)",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         local closest, dist = nil, math.huge
         for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
               local d = (plr.Character.Head.Position - workspace.CurrentCamera.CFrame.Position).Magnitude
               if d < dist and d < 500 then
                  closest = plr.Character.Head
                  dist = d
               end
            end
         end

         if closest then
            aimbotTarget = closest
            Rayfield:Notify({Title = "Aktif", Content = "Aimbot kilitlendi!"})
         else
            aimbotTarget = nil
            Rayfield:Notify({Title = "Hedef Yok", Content = "Yakın hedef bulunamadı."})
         end
      else
         aimbotTarget = nil
         Rayfield:Notify({Title = "Kapalı", Content = "Aimbot kapatıldı."})
      end
   end,
})

RunService.RenderStepped:Connect(function()
   if aimbotTarget and aimbotTarget.Parent then
      local cam = workspace.CurrentCamera
      cam.CFrame = CFrame.lookAt(cam.CFrame.Position, aimbotTarget.Position)
   end
end)

-- Bang
UniTab:CreateInput({
   Name = "Bang (Kick + Yanına Işınla)",
   PlaceholderText = "Kişi adını yaz...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      local targetName = Text:lower()
      for _, plr in pairs(Players:GetPlayers()) do
         if plr ~= LocalPlayer and (plr.Name:lower():find(targetName) or plr.DisplayName:lower():find(targetName)) then
            if LocalPlayer.Character and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
               LocalPlayer.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
            end
            plr:Kick("Fsien Hub tarafından banglandı!")
            Rayfield:Notify({Title = "Bang", Content = plr.Name .. " banglandı!"})
            break
         end
      end
   end,
})

-- Troll Bölgesi
local TrollTab = Window:CreateTab("Troll Bölgesi")

TrollTab:CreateLabel("Troll Özellikleri")

TrollTab:CreateButton({
   Name = "Fake Ban Mesajı",
   Callback = function()
      Rayfield:Notify({Title = "BANLANDIN!", Content = "Sen banlandın! 😈", Duration = 10})
   end,
})

TrollTab:CreateButton({
   Name = "Karakter Spin",
   Callback = function()
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
         local root = LocalPlayer.Character.HumanoidRootPart
         spawn(function()
            for i = 1, 100 do
               root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(360), 0)
               wait(0.05)
            end
         end)
         Rayfield:Notify({Title = "Spin", Content = "Karakter dönüyor!"})
      end
   end,
})

TrollTab:CreateButton({
   Name = "Random Teleport",
   Callback = function()
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
         local root = LocalPlayer.Character.HumanoidRootPart
         root.CFrame = CFrame.new(math.random(-500, 500), 100, math.random(-500, 500))
         Rayfield:Notify({Title = "Teleport", Content = "Rastgele yere ışınlandın!"})
      end
   end,
})

TrollTab:CreateButton({
   Name = "Loop Ses Troll",
   Callback = function()
      spawn(function()
         while true do
            wait(0.1)
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://1847661820"
            sound.Volume = 10
            sound.Parent = workspace
            sound:Play()
            game.Debris:AddItem(sound, 2)
         end
      end)
      Rayfield:Notify({Title = "Loop Ses", Content = "Ses troll başladı!"})
   end,
})

-- Steal a Brainrot Tab
local SabTab = Window:CreateTab("Steal a Brainrot")

SabTab:CreateLabel("20M+ Değerli Brainrot Tarayıcı")

SabTab:CreateButton({
   Name = "Başlat Tarama & İsimleri Göster",
   Callback = function()
      Rayfield:Notify({Title = "Tarama Başladı", Content = "20M+ brainrot aranıyor..."})

      local threshold = 20000000
      local brainrotList = {}

      for _, obj in pairs(workspace:GetChildren()) do
         if obj:IsA("Model") and (obj:FindFirstChild("Income") or obj:FindFirstChild("Value")) then
            local income = 0
            if obj:FindFirstChild("Income") then income = obj.Income.Value or 0 end
            if obj:FindFirstChild("Value") then income = obj.Value.Value or 0 end

            if income >= threshold then
               local name = obj.Name or "Bilinmeyen Brainrot"
               table.insert(brainrotList, name .. " (Income: " .. income .. ")")
            end
         end
      end

      if #brainrotList > 0 then
         local msg = "Bu serverde değerli brainrot var!\n\n" .. table.concat(brainrotList, "\n")
         Rayfield:Notify({Title = "Bulundu!", Content = msg, Duration = 20})
      else
         Rayfield:Notify({Title = "Yok", Content = "20M+ yok, hop yapılıyor..."})
         wait(2)
         game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
      end
   end,
})

SabTab:CreateButton({
   Name = "Hazır Finder Yükle",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/r0bloxlucker/sabfinderwithoutdualhook/refs/heads/main/finderv2.lua"))()
      Rayfield:Notify({Title = "Yüklendi", Content = "Hazır finder aktif!"})
   end,
})

print("Fsien Hub yüklendi! Tüm özellikler aktif.")
