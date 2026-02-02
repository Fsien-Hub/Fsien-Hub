-- Fsien Hub - Delta Executor için (Temizlenmiş & Stabil Versiyon)
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

-- Discord mesajı (eski haliyle aynı, değişmedi)
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

-- Sekme 1: Universal (Tüm duplicate'ler temizlendi)
local UniversalTab = Window:CreateTab("Universal")
UniversalTab:CreateLabel("Genel Hileler - Her Oyunda Çalışır")

-- Fly (daha stabil, kamera yönüne göre uçuyor)
local flying = false
local flySpeed = 50
local bodyVelocity, bodyGyro
UniversalTab:CreateToggle({
   Name = "Fly (Uçma)",
   CurrentValue = false,
   Callback = function(Value)
      flying = Value
      if Value then
         if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local root = LocalPlayer.Character.HumanoidRootPart
            
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            bodyVelocity.Velocity = Vector3.new(0,0,0)
            bodyVelocity.Parent = root
            
            bodyGyro = Instance.new("BodyGyro")
            bodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
            bodyGyro.CFrame = root.CFrame
            bodyGyro.Parent = root
            
            spawn(function()
               while flying and root do
                  local cam = Workspace.CurrentCamera
                  local moveDir = Vector3.new(0,0,0)
                  if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
                  if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
                  if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
                  if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
                  if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
                  if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0,1,0) end
                  
                  bodyVelocity.Velocity = moveDir * flySpeed
                  bodyGyro.CFrame = cam.CFrame
                  task.wait()
               end
               if bodyVelocity then bodyVelocity:Destroy() end
               if bodyGyro then bodyGyro:Destroy() end
            end)
            Rayfield:Notify({Title = "Aktif", Content = "Fly aktif! WASD + Space/Ctrl ile kontrol et."})
         end
      else
         flying = false
         Rayfield:Notify({Title = "Kapalı", Content = "Fly kapatıldı."})
      end
   end,
})

-- Noclip (Stepped ile stabil)
local noclipConn
UniversalTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         noclipConn = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
               for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                  if part:IsA("BasePart") then
                     part.CanCollide = false
                  end
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

-- Infinite Jump
local infJumpConn
UniversalTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         infJumpConn = UserInputService.JumpRequest:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
               LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
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
   Name = "Godmode / No Fall Damage",
   CurrentValue = false,
   Callback = function(Value)
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
         local hum = LocalPlayer.Character.Humanoid
         hum.MaxHealth = Value and math.huge or 100
         hum.Health = Value and math.huge or 100
         Rayfield:Notify({Title = Value and "Aktif" or "Kapalı", Content = "Godmode " .. (Value and "aktif!" or "kapatıldı.")})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Invisible (Kendine)",
   CurrentValue = false,
   Callback = function(Value)
      if LocalPlayer.Character then
         for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then
               v.Transparency = Value and 1 or 0
            end
         end
      end
      Rayfield:Notify({Title = Value and "Aktif" or "Kapalı", Content = "Invisible " .. (Value and "aktif!" or "kapatıldı.")})
   end,
})

UniversalTab:CreateToggle({
   Name = "Full Bright",
   CurrentValue = false,
   Callback = function(Value)
      Lighting.Brightness = Value and 2 or 1
      Lighting.GlobalShadows = not Value
      Lighting.FogEnd = Value and 9e9 or 100
      Rayfield:Notify({Title = Value and "Aktif" or "Kapalı", Content = "Full Bright " .. (Value and "aktif!" or "kapatıldı.")})
   end,
})

UniversalTab:CreateToggle({
   Name = "Low Gravity",
   CurrentValue = false,
   Callback = function(Value)
      Workspace.Gravity = Value and 50 or 196.2
      Rayfield:Notify({Title = Value and "Aktif" or "Kapalı", Content = "Low Gravity " .. (Value and "aktif!" or "kapatıldı.")})
   end,
})

-- Daha fazla özellik istersen (ESP, Aimbot, Speed Hub tarzı sekmeler vs.) söyle, ekleyelim!
-- Şimdilik bu haliyle açılmalı ve stabil çalışmalı.

Rayfield:Notify({Title = "Fsien Hub", Content = "Yüklendi! Keyfini çıkar 🚀"})
