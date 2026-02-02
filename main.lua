-- Fsien Hub - Delta Executor için (Uzaya Fling + Diğer Özellikler)
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

-- Universal Hileler Tab
local UniTab = Window:CreateTab("Universal Hileler")

-- Speed Hack
local currentSpeed = 16
UniTab:CreateSlider({
   Name = "Yürüme Hızı (Speed Hack)",
   Range = {16, 300},
   Increment = 10,
   Suffix = "Speed",
   CurrentValue = 16,
   Callback = function(Value)
      currentSpeed = Value
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
         LocalPlayer.Character.Humanoid.WalkSpeed = Value
      end
      Rayfield:Notify({Title = "Speed Güncellendi", Content = "Yeni hız: " .. Value})
   end,
})

-- Fly (önceki düzeltilmiş hali)
local flySpeed = 50
local flying = false
local flyBV, flyBG, flyConnection

UniTab:CreateToggle({
   Name = "Uçma (Fly) - Fare/Kamera yönüne göre",
   CurrentValue = false,
   Callback = function(Value)
      flying = Value
      local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
      if not root then return end

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
            local moveDir = Vector3.new()

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0,1,0) end

            flyBV.Velocity = moveDir.Unit * flySpeed
            flyBG.CFrame = cam.CFrame
         end)

         Rayfield:Notify({Title = "Aktif", Content = "Uçma aktif! Fareyi istediğin yöne çevir + WASD/Space/Ctrl."})
      else
         if flyConnection then flyConnection:Disconnect() flyConnection = nil end
         if flyBV then flyBV:Destroy() flyBV = nil end
         if flyBG then flyBG:Destroy() flyBG = nil end
         Rayfield:Notify({Title = "Kapalı", Content = "Uçma kapatıldı."})
      end
   end,
})

UniTab:CreateSlider({
   Name = "Uçma Hızı",
   Range = {10, 200},
   Increment = 5,
   Suffix = "Speed",
   CurrentValue = 50,
   Callback = function(Value)
      flySpeed = Value
   end,
})

-- Infinite Jump
UniTab:CreateToggle({
   Name = "Infinite Jump (Sonsuz Zıplama)",
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

-- Noclip
UniTab:CreateToggle({
   Name = "Noclip (Duvarlardan Geçme)",
   CurrentValue = false,
   Callback = function(Value)
      local noclipConn
      if Value then
         noclipConn = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
               for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                  if part:IsA("BasePart") then part.CanCollide = false end
               end
            end
         end)
         Rayfield:Notify({Title = "Aktif", Content = "Noclip aktif!"})
      else
         if noclipConn then noclipConn:Disconnect() end
         Rayfield:Notify({Title = "Kapalı", Content = "Noclip kapatıldı."})
      end
   end,
})

-- Düzeltilmiş Fling (Toggle - aktifken yakın oyuncuları UZAYA fırlatır)
local flingActive = false
UniTab:CreateToggle({
   Name = "Fling (Aktifken Yakın Oyuncuları Uzaya Fırlat)",
   CurrentValue = false,
   Callback = function(Value)
      flingActive = Value
      if Value then
         Rayfield:Notify({Title = "Aktif", Content = "Uzaya Fling aktif! Yakın oyuncular uzaya uçuyor."})
      else
         Rayfield:Notify({Title = "Kapalı", Content = "Fling kapatıldı."})
      end
   end,
})

-- Fling loop (toggle açıkken çalışır - uzaya fırlatma)
RunService.Heartbeat:Connect(function()
   if flingActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
      local root = LocalPlayer.Character.HumanoidRootPart
      for _, plr in pairs(Players:GetPlayers()) do
         if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local targetRoot = plr.Character.HumanoidRootPart
            local dist = (targetRoot.Position - root.Position).Magnitude
            if dist < 20 then  -- 20 studs mesafe içinde
               -- Uzaya fırlatma: yüksek yukarı + rastgele yön
               local flingForce = Vector3.new(math.random(-100,100), 500, math.random(-100,100))
               targetRoot.Velocity = flingForce
            end
         end
      end
   end
end)

-- ESP (düzeltilmiş, distance + temiz kapanma)
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
   Name = "Infinite Jump (Sonsuz Zıplama)",
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

-- Aimbot (kilitlenmiş, ayrılmıyor)
local aimbotTarget = nil
UniTab:CreateToggle({
   Name = "Aimbot (Kamera Hedefe Kilitlenir)",
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
            Rayfield:Notify({Title = "Aktif", Content = "Aimbot kilitlendi! Kamera ayrılmayacak."})
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

-- Bang (Kick + Yanına Işınla) - benzer isim bile olsa çalışır
UniTab:CreateInput({
   Name = "Bang (Kick + Yanına Işınla)",
   PlaceholderText = "Kişi adını yaz (benzer olsa yeter)...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      local targetName = Text:lower()
      for _, plr in pairs(Players:GetPlayers()) do
         if plr ~= LocalPlayer and (plr.Name:lower():find(targetName) or plr.DisplayName:lower():find(targetName)) then
            -- Yanına ışınla
            if LocalPlayer.Character and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
               LocalPlayer.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
            end
            plr:Kick("Fsien Hub tarafından banglandı!")
            Rayfield:Notify({Title = "Bang", Content = plr.Name .. " yanına ışınlandı ve banglandı!"})
            break
         end
      end
   end,
})

-- Troll Bölgesi Tab
local TrollTab = Window:CreateTab("Troll Bölgesi")

TrollTab:CreateLabel("Troll Özellikleri (Eğlence İçin)")

TrollTab:CreateButton({
   Name = "Fake Ban Mesajı Gönder (Kendine)",
   Callback = function()
      Rayfield:Notify({Title = "BANLANDIN!", Content = "Sen banlandın! Oyun sahibine bildirildi. 😈", Duration = 10})
   end,
})

TrollTab:CreateButton({
   Name = "Karakter Spin (Dönme Troll)",
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
   Name = "Random Teleport (Rastgele Işınlan)",
   Callback = function()
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
         local root = LocalPlayer.Character.HumanoidRootPart
         root.CFrame = CFrame.new(math.random(-500, 500), 100, math.random(-500, 500))
         Rayfield:Notify({Title = "Troll Teleport", Content = "Rastgele yere ışınlandın!"})
      end
   end,
})

TrollTab:CreateButton({
   Name = "Loop Ses Troll (Kulaklık Patlat)",
   Callback = function()
      spawn(function()
         while true do
            wait(0.1)
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://1847661820"  -- yüksek meme ses
            sound.Volume = 10
            sound.Parent = workspace
            sound:Play()
            game.Debris:AddItem(sound, 2)
         end
      end)
      Rayfield:Notify({Title = "Loop Ses", Content = "Ses troll başladı! (Durmak için oyunu yeniden başlat.)"})
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
         game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
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

print("Fsien Hub yüklendi! Uzaya Fling aktif.")
