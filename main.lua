-- Fsien Hub - Delta Executor için (Düzeltilmiş Fly + Noclip + Fling + ESP + Infinite Jump + Aimbot + Bang + Brainrot)
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

-- Universal Hileler Tab
local UniTab = Window:CreateTab("Universal Hileler")

-- Düzeltilmiş Fly (mobil/PC uyumlu, kamera yönü + hız slider)
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

            -- PC için WASD + Space/Ctrl
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

-- Fling (toggle - aktifken karakter etrafında fırlatma alanı)
local flingActive = false
UniTab:CreateToggle({
   Name = "Fling (Aktifken Yakın Oyuncuları Fırlat)",
   CurrentValue = false,
   Callback = function(Value)
      flingActive = Value
      if Value then
         Rayfield:Notify({Title = "Aktif", Content = "Fling aktif! Yakın oyuncular fırlatılacak."})
      else
         Rayfield:Notify({Title = "Kapalı", Content = "Fling kapatıldı."})
      end
   end,
})

-- Fling loop (toggle açıkken çalışır)
RunService.Heartbeat:Connect(function()
   if flingActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
      local root = LocalPlayer.Character.HumanoidRootPart
      for _, plr in pairs(Players:GetPlayers()) do
         if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local targetRoot = plr.Character.HumanoidRootPart
            local dist = (targetRoot.Position - root.Position).Magnitude
            if dist < 15 then  -- 15 studs mesafe içinde
               targetRoot.Velocity = (targetRoot.Position - root.Position).Unit * 200 + Vector3.new(0, 100, 0)  -- yukarı + ileri fırlatma
            end
         end
      end
   end
end)

-- ESP (düzeltilmiş, kapatınca temizlenir + distance ekli)
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

               -- Update distance her frame
               local conn = RunService.RenderStepped:Connect(function()
                  if billboard.Adornee and billboard.Adornee.Parent then
                     local dist = (LocalPlayer.Character.HumanoidRootPart.Position - billboard.Adornee.Position).Magnitude
                     text.Text = plr.Name .. "\n" .. math.floor(dist) .. " studs"
                  end
               end)

               table.insert(espConnections, {highlight = highlight, billboard = billboard, conn = conn})
            end
         end
         Rayfield:Notify({Title = "Aktif", Content = "ESP aktif! İsim + Distance gösteriliyor."})
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
         Rayfield:Notify({Title = "Aktif", Content = "Infinite Jump aktif! Boşluk tuşuna basmaya devam et."})
      else
         if infJumpConn then infJumpConn:Disconnect() end
         Rayfield:Notify({Title = "Kapalı", Content = "Infinite Jump kapatıldı."})
      end
   end,
})

-- Aimbot (basit, en yakın oyuncuya nişan al - toggle)
local aimbotActive = false
UniTab:CreateToggle({
   Name = "Aimbot (En Yakına Nişan Al)",
   CurrentValue = false,
   Callback = function(Value)
      aimbotActive = Value
      if Value then
         Rayfield:Notify({Title = "Aktif", Content = "Aimbot aktif! Fare en yakına dönecek."})
      else
         Rayfield:Notify({Title = "Kapalı", Content = "Aimbot kapatıldı."})
      end
   end,
})

RunService.RenderStepped:Connect(function()
   if aimbotActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
      local closest, dist = nil, math.huge
      for _, plr in pairs(Players:GetPlayers()) do
         if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
            local d = (plr.Character.Head.Position - workspace.CurrentCamera.CFrame.Position).Magnitude
            if d < dist then
               closest = plr.Character.Head
               dist = d
            end
         end
      end
      if closest then
         workspace.CurrentCamera.CFrame = CFrame.lookAt(workspace.CurrentCamera.CFrame.Position, closest.Position)
      end
   end
end)

-- Bang (Kick/Ban) - kişi adına göre (ban için oyun sahibi yetkisi lazım, genelde kick çalışır)
UniTab:CreateInput({
   Name = "Bang (Kick) - Kişi Adı Yaz",
   PlaceholderText = "Kişi adını yaz...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      local targetName = Text:lower()
      for _, plr in pairs(Players:GetPlayers()) do
         if plr.Name:lower():find(targetName) or plr.DisplayName:lower():find(targetName) then
            plr:Kick("Fsien Hub tarafından banglandı!")
            Rayfield:Notify({Title = "Bang", Content = plr.Name .. " banglandı!"})
            break
         end
      end
   end,
})

-- Steal a Brainrot Tab (önceki hali)
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

print("Fsien Hub yüklendi! Tüm özellikler aktif.")
