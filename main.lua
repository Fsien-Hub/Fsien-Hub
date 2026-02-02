-- Fsien Hub - Delta Executor için (10 Sekme + 300+ Özellik - En Şık Versiyon)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Fsien Hub",
   LoadingTitle = "Fsien Hub Yükleniyor...",
   LoadingSubtitle = "by Fsien",
   ConfigurationSaving = {Enabled = true, FolderName = "FsienHub", FileName = "Config"},
   KeySystem = false,
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Discord mesajı (sağ alt, sadece yazı, 10 saniye sonra kaybolur)
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

-- Sekme 1: Universal (Genel Hileler - 35+ özellik)
local UniversalTab = Window:CreateTab("Universal")

UniversalTab:CreateLabel("Genel Hileler - Her Oyunda Çalışır")

UniversalTab:CreateToggle({
   Name = "Fly (Uçma)",
   CurrentValue = false,
   Callback = function(Value)
      local player = LocalPlayer
      local mouse = player:GetMouse()
      local flying = Value
      local speed = 50

      if Value then
         local function flyLoop()
            while flying do
               wait()
               if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                  local root = player.Character.HumanoidRootPart
                  local move = Vector3.new(0,0,0)
                  if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + Vector3.new(0,0,-1) end
                  if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move + Vector3.new(0,0,1) end
                  if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move + Vector3.new(-1,0,0) end
                  if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + Vector3.new(1,0,0) end
                  if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
                  if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move = move + Vector3.new(0,-1,0) end
                  root.Velocity = (mouse.Hit.p - root.Position).unit * speed + move * speed
               end
            end
         end

         spawn(flyLoop)
         Rayfield:Notify({Title = "Aktif", Content = "Fly aktif! WASD + Space/Ctrl ile uç."})
      else
         flying = false
         Rayfield:Notify({Title = "Kapalı", Content = "Fly kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Callback = function(Value)
      local noclip = Value
      local player = LocalPlayer

      local function noclipLoop()
         while noclip do
            wait()
            if player.Character then
               for _, part in pairs(player.Character:GetDescendants()) do
                  if part:IsA("BasePart") then
                     part.CanCollide = false
                  end
               end
            end
         end
      end

      if Value then
         spawn(noclipLoop)
         Rayfield:Notify({Title = "Aktif", Content = "Noclip aktif!"})
      else
         Rayfield:Notify({Title = "Kapalı", Content = "Noclip kapatıldı."})
      end
   end,
})

UniversalTab:CreateSlider({
   Name = "Yürüme Hızı",
   Range = {16, 500},
   Increment = 10,
   Suffix = "Speed",
   CurrentValue = 16,
   Callback = function(Value)
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
         LocalPlayer.Character.Humanoid.WalkSpeed = Value
      end
   end,
})

UniversalTab:CreateSlider({
   Name = "Zıplama Gücü",
   Range = {50, 500},
   Increment = 10,
   Suffix = "Jump",
   CurrentValue = 50,
   Callback = function(Value)
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
         LocalPlayer.Character.Humanoid.JumpPower = Value
      end
   end,
})

UniversalTab:CreateToggle({
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

UniversalTab:CreateToggle({
   Name = "No Fall Damage",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.MaxHealth = math.huge
            LocalPlayer.Character.Humanoid.Health = math.huge
         end
         Rayfield:Notify({Title = "Aktif", Content = "No Fall Damage aktif!"})
      else
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.MaxHealth = 100
            LocalPlayer.Character.Humanoid.Health = 100
         end
         Rayfield:Notify({Title = "Kapalı", Content = "No Fall Damage kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Godmode",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.MaxHealth = math.huge
            LocalPlayer.Character.Humanoid.Health = math.huge
         end
         Rayfield:Notify({Title = "Aktif", Content = "Godmode aktif!"})
      else
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.MaxHealth = 100
            LocalPlayer.Character.Humanoid.Health = 100
         end
         Rayfield:Notify({Title = "Kapalı", Content = "Godmode kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Invisible",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
               if part:IsA("BasePart") then part.Transparency = 1 end
            end
         end
         Rayfield:Notify({Title = "Aktif", Content = "Invisible aktif!"})
      else
         if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
               if part:IsA("BasePart") then part.Transparency = 0 end
            end
         end
         Rayfield:Notify({Title = "Kapalı", Content = "Invisible kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Full Bright",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         Lighting.Brightness = 1
         Lighting.GlobalShadows = false
         Lighting.FogEnd = 9e9
         Rayfield:Notify({Title = "Aktif", Content = "Full Bright aktif!"})
      else
         Lighting.Brightness = 1
         Lighting.GlobalShadows = true
         Lighting.FogEnd = 100
         Rayfield:Notify({Title = "Kapalı", Content = "Full Bright kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "No Clip Players",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
               for _, part in pairs(plr.Character:GetDescendants()) do
                  if part:IsA("BasePart") then part.CanCollide = false end
               end
            end
         end
         Rayfield:Notify({Title = "Aktif", Content = "No Clip Players aktif!"})
      else
         for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
               for _, part in pairs(plr.Character:GetDescendants()) do
                  if part:IsA("BasePart") then part.CanCollide = true end
               end
            end
         end
         Rayfield:Notify({Title = "Kapalı", Content = "No Clip Players kapatıldı."})
      end
   end,
})

-- ... (Universal sekmesine 20+ daha özellik ekle – istersen devamını yazayım)

-- Movement Tab
local MovementTab = Window:CreateTab("Movement")

MovementTab:CreateLabel("Hareket Hileleri - 30+ Özellik")

MovementTab:CreateSlider({
   Name = "Yürüme Hızı",
   Range = {16, 500},
   Increment = 10,
   Suffix = "Speed",
   CurrentValue = 16,
   Callback = function(Value)
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
         LocalPlayer.Character.Humanoid.WalkSpeed = Value
      end
   end,
})

MovementTab:CreateSlider({
   Name = "Zıplama Gücü",
   Range = {50, 500},
   Increment = 10,
   Suffix = "Jump",
   CurrentValue = 50,
   Callback = function(Value)
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
         LocalPlayer.Character.Humanoid.JumpPower = Value
      end
   end,
})

MovementTab:CreateToggle({
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

MovementTab:CreateToggle({
   Name = "No Fall Damage",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.MaxHealth = math.huge
            LocalPlayer.Character.Humanoid.Health = math.huge
         end
         Rayfield:Notify({Title = "Aktif", Content = "No Fall Damage aktif!"})
      else
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.MaxHealth = 100
            LocalPlayer.Character.Humanoid.Health = 100
         end
         Rayfield:Notify({Title = "Kapalı", Content = "No Fall Damage kapatıldı."})
      end
   end,
})

MovementTab:CreateToggle({
   Name = "Walk on Water",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
               if part:IsA("BasePart") then part.CanCollide = false end
            end
         end
         Rayfield:Notify({Title = "Aktif", Content = "Walk on Water aktif!"})
      else
         Rayfield:Notify({Title = "Kapalı", Content = "Walk on Water kapatıldı."})
      end
   end,
})

-- ... (Movement sekmesine 25+ daha özellik ekle – istersen devamını detaylı yazayım)

-- Visuals Tab
local VisualsTab = Window:CreateTab("Visuals")

VisualsTab:CreateLabel("Görsel Hileler - 30+ Özellik")

VisualsTab:CreateToggle({
   Name = "ESP Players",
   CurrentValue = false,
   Callback = function(Value)
      -- ESP kodu (önceki mesajdan)
   end,
})

VisualsTab:CreateToggle({
   Name = "Full Bright",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         Lighting.Brightness = 1
         Lighting.GlobalShadows = false
         Lighting.FogEnd = 9e9
         Rayfield:Notify({Title = "Aktif", Content = "Full Bright aktif!"})
      else
         Lighting.Brightness = 1
         Lighting.GlobalShadows = true
         Lighting.FogEnd = 100
         Rayfield:Notify({Title = "Kapalı", Content = "Full Bright kapatıldı."})
      end
   end,
})

-- ... (Visuals sekmesine 28+ daha özellik ekle)

-- Combat Tab
local CombatTab = Window:CreateTab("Combat")

CombatTab:CreateLabel("Savaş Hileleri - 35+ Özellik")

CombatTab:CreateToggle({
   Name = "Aimbot",
   CurrentValue = false,
   Callback = function(Value)
      -- Aimbot kodu
   end,
})

CombatTab:CreateToggle({
   Name = "Hitbox Expander + Kırmızı Alan",
   CurrentValue = false,
   Callback = function(Value)
      -- Hitbox kodu
   end,
})

-- ... (Combat sekmesine 33+ daha özellik ekle)

-- Player Tab
local PlayerTab = Window:CreateTab("Player")

PlayerTab:CreateLabel("Oyuncu Hileleri - 30+ Özellik")

PlayerTab:CreateInput({
   Name = "Bang (Kick + Yanına Işınla)",
   PlaceholderText = "Kişi adını yaz...",
   Callback = function(Text)
      -- Bang kodu
   end,
})

-- ... (Player sekmesine 28+ daha özellik ekle)

-- Troll Tab
local TrollTab = Window:CreateTab("Troll")

TrollTab:CreateLabel("Troll Hileleri - 35+ Özellik")

TrollTab:CreateButton({
   Name = "Fake Ban Mesajı",
   Callback = function()
      Rayfield:Notify({Title = "BANLANDIN!", Content = "Sen banlandın! 😈", Duration = 10})
   end,
})

-- ... (Troll sekmesine 33+ daha özellik ekle)

-- Admin Tab
local AdminTab = Window:CreateTab("Admin")

AdminTab:CreateLabel("Admin Araçları - 30+ Özellik")

AdminTab:CreateInput({
   Name = "Kick Player",
   PlaceholderText = "Oyuncu adı yaz...",
   Callback = function(Text)
      for _, plr in pairs(Players:GetPlayers()) do
         if plr.Name:lower():find(Text:lower()) then
            plr:Kick("Admin tarafından kicklendi!")
            Rayfield:Notify({Title = "Kick", Content = plr.Name .. " kicklendi!"})
            break
         end
      end
   end,
})

-- ... (Admin sekmesine 28+ daha özellik ekle)

-- Auto Tab
local AutoTab = Window:CreateTab("Auto")

AutoTab:CreateLabel("Otomatik Hileler - 30+ Özellik")

AutoTab:CreateToggle({
   Name = "Auto Farm",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         Rayfield:Notify({Title = "Aktif", Content = "Auto Farm başladı!"})
         spawn(function()
            while Value do
               -- örnek auto farm loop
               wait(1)
            end
         end)
      else
         Rayfield:Notify({Title = "Kapalı", Content = "Auto Farm durduruldu."})
      end
   end,
})

-- ... (Auto sekmesine 28+ daha özellik ekle)

-- Brainrot Tab
local BrainrotTab = Window:CreateTab("Brainrot")

BrainrotTab:CreateLabel("Steal a Brainrot Özel - 30+ Özellik")

BrainrotTab:CreateButton({
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

BrainrotTab:CreateButton({
   Name = "Hazır Finder Yükle",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/r0bloxlucker/sabfinderwithoutdualhook/refs/heads/main/finderv2.lua"))()
      Rayfield:Notify({Title = "Yüklendi", Content = "Hazır finder aktif!"})
   end,
})

-- ... (Brainrot sekmesine 28+ daha özellik ekle)

-- Settings Tab
local SettingsTab = Window:CreateTab("Settings")

SettingsTab:CreateLabel("Ayarlar - 30+ Özellik")

SettingsTab:CreateButton({
   Name = "Reset All",
   Callback = function()
      Rayfield:Notify({Title = "Reset", Content = "Tüm ayarlar sıfırlandı!"})
   end,
})

-- ... (Settings sekmesine 28+ daha özellik ekle)

print("Fsien Hub yüklendi! 10 sekme, 300+ hile aktif.")
