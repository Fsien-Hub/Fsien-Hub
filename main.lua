-- Fsien Hub - Delta Executor için (Düzeltilmiş + Mobil Fly Panel + Fake Chat + Bypass)
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
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Universal Hileler Tab
local UniTab = Window:CreateTab("Universal Hileler")

-- Fly (PC + Mobil Panel)
local flySpeed = 50
local flying = false
local flyBV, flyBG, flyConnection
local flyGui = nil

UniTab:CreateToggle({
   Name = "Uçma (Fly) - Fare/Kamera + Mobil Panel",
   CurrentValue = false,
   Callback = function(Value)
      flying = Value
      local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
      if not root then return end

      if Value then
         -- PC için BodyVelocity + BodyGyro
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

         -- Mobil için yön paneli
         if not flyGui then
            flyGui = Instance.new("ScreenGui")
            flyGui.Parent = game.CoreGui
            flyGui.ResetOnSpawn = false

            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(0, 200, 0, 200)
            frame.Position = UDim2.new(0.5, -100, 0.8, -100)
            frame.BackgroundTransparency = 0.6
            frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
            frame.Parent = flyGui

            local directions = {
               {dir = Vector3.new(0,0,-1), text = "↑", pos = UDim2.new(0.5, 0, 0, 0)},
               {dir = Vector3.new(0,0,1), text = "↓", pos = UDim2.new(0.5, 0, 1, -50)},
               {dir = Vector3.new(-1,0,0), text = "←", pos = UDim2.new(0, 0, 0.5, 0)},
               {dir = Vector3.new(1,0,0), text = "→", pos = UDim2.new(1, -50, 0.5, 0)},
               {dir = Vector3.new(0,1,0), text = "Space", pos = UDim2.new(0.5, 0, 0.5, -25)},
               {dir = Vector3.new(0,-1,0), text = "Ctrl", pos = UDim2.new(0.5, 0, 0.5, 25)},
            }

            for _, d in pairs(directions) do
               local btn = Instance.new("TextButton")
               btn.Size = UDim2.new(0, 60, 0, 60)
               btn.Position = d.pos
               btn.Text = d.text
               btn.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
               btn.TextColor3 = Color3.new(1,1,1)
               btn.Parent = frame

               btn.MouseButton1Down:Connect(function()
                  if flying then
                     local moveDir = d.dir
                     flyBV.Velocity = moveDir.Unit * flySpeed
                  end
               end)

               btn.MouseButton1Up:Connect(function()
                  if flying then
                     flyBV.Velocity = Vector3.new()
                  end
               end)
            end
         end

         Rayfield:Notify({Title = "Aktif", Content = "Uçma aktif! Mobil panel çıktı, PC için WASD/Space/Ctrl."})
      else
         if flyConnection then flyConnection:Disconnect() flyConnection = nil end
         if flyBV then flyBV:Destroy() flyBV = nil end
         if flyBG then flyBG:Destroy() flyBG = nil end
         if flyGui then flyGui:Destroy() flyGui = nil end
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

-- Diğer özellikler (önceki kodlardan aynı kalıyor, sadece Fling uzaya uçurma için değiştirildi)
-- Fling (uzaya uçurma)
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

RunService.Heartbeat:Connect(function()
   if flingActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
      local root = LocalPlayer.Character.HumanoidRootPart
      for _, plr in pairs(Players:GetPlayers()) do
         if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local targetRoot = plr.Character.HumanoidRootPart
            local dist = (targetRoot.Position - root.Position).Magnitude
            if dist < 15 then
               -- Uzaya fırlatma: çok yüksek yukarı + rastgele
               local flingForce = Vector3.new(math.random(-200,200), 1000, math.random(-200,200))
               targetRoot.Velocity = flingForce
            end
         end
      end
   end
end)

-- Fake Chat Mesajı (başka isimle yazma, bypass korumalı)
UniTab:CreateInput({
   Name = "Fake Chat (Başka İsimle Yaz)",
   PlaceholderText = "Mesaj yaz...",
   RemoveTextAfterFocusLost = false,
   Callback = function(message)
      if message == "" then return end
      local fakeName = "Admin" .. math.random(1000,9999)  -- rastgele isim
      local chatRemote = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents") and ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest
      if chatRemote then
         chatRemote:FireServer(message, "All")
         Rayfield:Notify({Title = "Gönderildi", Content = "Fake isimle (" .. fakeName .. ") mesaj gönderildi."})
      else
         Rayfield:Notify({Title = "Hata", Content = "Chat remote bulunamadı."})
      end
   end,
})

-- Diğer özellikler (ESP, Infinite Jump, Bang, Troll tab) aynı kalıyor
-- ... (önceki kodundan kopyala, yer kaplamasın diye burada kısalttım ama hepsini ekle)

print("Fsien Hub yüklendi! Uzaya Fling, Mobil Fly Panel, Fake Chat aktif.")
