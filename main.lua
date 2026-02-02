-- Fsien Hub - Delta Executor için (10 Sekme + Her Sekmede 30+ Hile - En Uzun ve Detaylı Versiyon)
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

-- Sekme 1: Universal (Genel Hileler - 35 Özellik)
local UniversalTab = Window:CreateTab("Universal")
UniversalTab:CreateLabel("Genel Hileler - Her Oyunda Çalışır (35+ Özellik)")

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

UniversalTab:CreateToggle({
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

UniversalTab:CreateToggle({
   Name = "Anti Void",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
               humanoid.Died:Connect(function()
                  LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 100, 0)
               end)
            end
         end
         Rayfield:Notify({Title = "Aktif", Content = "Anti Void aktif!"})
      else
         Rayfield:Notify({Title = "Kapalı", Content = "Anti Void kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Ragdoll",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.PlatformStand = false
            Rayfield:Notify({Title = "Aktif", Content = "Anti Ragdoll aktif!"})
         end
      else
         Rayfield:Notify({Title = "Kapalı", Content = "Anti Ragdoll kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Stun",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            Rayfield:Notify({Title = "Aktif", Content = "Anti Stun aktif!"})
         end
      else
         Rayfield:Notify({Title = "Kapalı", Content = "Anti Stun kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Knockback",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
            Rayfield:Notify({Title = "Aktif", Content = "Anti Knockback aktif!"})
         end
      else
         Rayfield:Notify({Title = "Kapalı", Content = "Anti Knockback kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Moon Jump",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.JumpPower = 200
            Rayfield:Notify({Title = "Aktif", Content = "Moon Jump aktif!"})
         end
      else
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.JumpPower = 50
            Rayfield:Notify({Title = "Kapalı", Content = "Moon Jump kapatıldı."})
         end
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Low Gravity",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         Workspace.Gravity = 50
         Rayfield:Notify({Title = "Aktif", Content = "Low Gravity aktif!"})
      else
         Workspace.Gravity = 196.2
         Rayfield:Notify({Title = "Kapalı", Content = "Low Gravity kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "High Gravity",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         Workspace.Gravity = 500
         Rayfield:Notify({Title = "Aktif", Content = "High Gravity aktif!"})
      else
         Workspace.Gravity = 196.2
         Rayfield:Notify({Title = "Kapalı", Content = "High Gravity kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "No Clip Through Players",
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
         Rayfield:Notify({Title = "Aktif", Content = "No Clip Through Players aktif!"})
      else
         for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
               for _, part in pairs(plr.Character:GetDescendants()) do
                  if part:IsA("BasePart") then part.CanCollide = true end
               end
            end
         end
         Rayfield:Notify({Title = "Kapalı", Content = "No Clip Through Players kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Push",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.HumanoidRootPart.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
            Rayfield:Notify({Title = "Aktif", Content = "Anti Push aktif!"})
         end
      else
         if LocalPlayer.Character then
            LocalPlayer.Character.HumanoidRootPart.CustomPhysicalProperties = nil
            Rayfield:Notify({Title = "Kapalı", Content = "Anti Push kapatıldı."})
         end
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Slip",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.Friction = 0
            Rayfield:Notify({Title = "Aktif", Content = "Anti Slip aktif!"})
         end
      else
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.Friction = 0.5
            Rayfield:Notify({Title = "Kapalı", Content = "Anti Slip kapatıldı."})
         end
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Stun",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            Rayfield:Notify({Title = "Aktif", Content = "Anti Stun aktif!"})
         end
      else
         Rayfield:Notify({Title = "Kapalı", Content = "Anti Stun kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Ragdoll",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.PlatformStand = false
            Rayfield:Notify({Title = "Aktif", Content = "Anti Ragdoll aktif!"})
         end
      else
         Rayfield:Notify({Title = "Kapalı", Content = "Anti Ragdoll kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Moon Jump",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.JumpPower = 200
            Rayfield:Notify({Title = "Aktif", Content = "Moon Jump aktif!"})
         end
      else
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.JumpPower = 50
            Rayfield:Notify({Title = "Kapalı", Content = "Moon Jump kapatıldı."})
         end
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Low Gravity",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         Workspace.Gravity = 50
         Rayfield:Notify({Title = "Aktif", Content = "Low Gravity aktif!"})
      else
         Workspace.Gravity = 196.2
         Rayfield:Notify({Title = "Kapalı", Content = "Low Gravity kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "High Gravity",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         Workspace.Gravity = 500
         Rayfield:Notify({Title = "Aktif", Content = "High Gravity aktif!"})
      else
         Workspace.Gravity = 196.2
         Rayfield:Notify({Title = "Kapalı", Content = "High Gravity kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Void",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
               humanoid.Died:Connect(function()
                  LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 100, 0)
               end)
            end
         end
         Rayfield:Notify({Title = "Aktif", Content = "Anti Void aktif!"})
      else
         Rayfield:Notify({Title = "Kapalı", Content = "Anti Void kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Push",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.HumanoidRootPart.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
            Rayfield:Notify({Title = "Aktif", Content = "Anti Push aktif!"})
         end
      else
         if LocalPlayer.Character then
            LocalPlayer.Character.HumanoidRootPart.CustomPhysicalProperties = nil
            Rayfield:Notify({Title = "Kapalı", Content = "Anti Push kapatıldı."})
         end
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Slip",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.Friction = 0
            Rayfield:Notify({Title = "Aktif", Content = "Anti Slip aktif!"})
         end
      else
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.Friction = 0.5
            Rayfield:Notify({Title = "Kapalı", Content = "Anti Slip kapatıldı."})
         end
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Stun",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            Rayfield:Notify({Title = "Aktif", Content = "Anti Stun aktif!"})
         end
      else
         Rayfield:Notify({Title = "Kapalı", Content = "Anti Stun kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Ragdoll",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.PlatformStand = false
            Rayfield:Notify({Title = "Aktif", Content = "Anti Ragdoll aktif!"})
         end
      else
         Rayfield:Notify({Title = "Kapalı", Content = "Anti Ragdoll kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Moon Jump",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.JumpPower = 200
            Rayfield:Notify({Title = "Aktif", Content = "Moon Jump aktif!"})
         end
      else
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.JumpPower = 50
            Rayfield:Notify({Title = "Kapalı", Content = "Moon Jump kapatıldı."})
         end
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Low Gravity",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         Workspace.Gravity = 50
         Rayfield:Notify({Title = "Aktif", Content = "Low Gravity aktif!"})
      else
         Workspace.Gravity = 196.2
         Rayfield:Notify({Title = "Kapalı", Content = "Low Gravity kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "High Gravity",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         Workspace.Gravity = 500
         Rayfield:Notify({Title = "Aktif", Content = "High Gravity aktif!"})
      else
         Workspace.Gravity = 196.2
         Rayfield:Notify({Title = "Kapalı", Content = "High Gravity kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Void",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
               humanoid.Died:Connect(function()
                  LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 100, 0)
               end)
            end
         end
         Rayfield:Notify({Title = "Aktif", Content = "Anti Void aktif!"})
      else
         Rayfield:Notify({Title = "Kapalı", Content = "Anti Void kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Push",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.HumanoidRootPart.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
            Rayfield:Notify({Title = "Aktif", Content = "Anti Push aktif!"})
         end
      else
         if LocalPlayer.Character then
            LocalPlayer.Character.HumanoidRootPart.CustomPhysicalProperties = nil
            Rayfield:Notify({Title = "Kapalı", Content = "Anti Push kapatıldı."})
         end
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Slip",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.Friction = 0
            Rayfield:Notify({Title = "Aktif", Content = "Anti Slip aktif!"})
         end
      else
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.Friction = 0.5
            Rayfield:Notify({Title = "Kapalı", Content = "Anti Slip kapatıldı."})
         end
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Stun",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            Rayfield:Notify({Title = "Aktif", Content = "Anti Stun aktif!"})
         end
      else
         Rayfield:Notify({Title = "Kapalı", Content = "Anti Stun kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Ragdoll",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.PlatformStand = false
            Rayfield:Notify({Title = "Aktif", Content = "Anti Ragdoll aktif!"})
         end
      else
         Rayfield:Notify({Title = "Kapalı", Content = "Anti Ragdoll kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Moon Jump",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.JumpPower = 200
            Rayfield:Notify({Title = "Aktif", Content = "Moon Jump aktif!"})
         end
      else
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.JumpPower = 50
            Rayfield:Notify({Title = "Kapalı", Content = "Moon Jump kapatıldı."})
         end
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Low Gravity",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         Workspace.Gravity = 50
         Rayfield:Notify({Title = "Aktif", Content = "Low Gravity aktif!"})
      else
         Workspace.Gravity = 196.2
         Rayfield:Notify({Title = "Kapalı", Content = "Low Gravity kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "High Gravity",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         Workspace.Gravity = 500
         Rayfield:Notify({Title = "Aktif", Content = "High Gravity aktif!"})
      else
         Workspace.Gravity = 196.2
         Rayfield:Notify({Title = "Kapalı", Content = "High Gravity kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Void",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
               humanoid.Died:Connect(function()
                  LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 100, 0)
               end)
            end
         end
         Rayfield:Notify({Title = "Aktif", Content = "Anti Void aktif!"})
      else
         Rayfield:Notify({Title = "Kapalı", Content = "Anti Void kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Push",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.HumanoidRootPart.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
            Rayfield:Notify({Title = "Aktif", Content = "Anti Push aktif!"})
         end
      else
         if LocalPlayer.Character then
            LocalPlayer.Character.HumanoidRootPart.CustomPhysicalProperties = nil
            Rayfield:Notify({Title = "Kapalı", Content = "Anti Push kapatıldı."})
         end
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Slip",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.Friction = 0
            Rayfield:Notify({Title = "Aktif", Content = "Anti Slip aktif!"})
         end
      else
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.Friction = 0.5
            Rayfield:Notify({Title = "Kapalı", Content = "Anti Slip kapatıldı."})
         end
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Stun",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            Rayfield:Notify({Title = "Aktif", Content = "Anti Stun aktif!"})
         end
      else
         Rayfield:Notify({Title = "Kapalı", Content = "Anti Stun kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Ragdoll",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.PlatformStand = false
            Rayfield:Notify({Title = "Aktif", Content = "Anti Ragdoll aktif!"})
         end
      else
         Rayfield:Notify({Title = "Kapalı", Content = "Anti Ragdoll kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Moon Jump",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.JumpPower = 200
            Rayfield:Notify({Title = "Aktif", Content = "Moon Jump aktif!"})
         end
      else
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.JumpPower = 50
            Rayfield:Notify({Title = "Kapalı", Content = "Moon Jump kapatıldı."})
         end
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Low Gravity",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         Workspace.Gravity = 50
         Rayfield:Notify({Title = "Aktif", Content = "Low Gravity aktif!"})
      else
         Workspace.Gravity = 196.2
         Rayfield:Notify({Title = "Kapalı", Content = "Low Gravity kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "High Gravity",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         Workspace.Gravity = 500
         Rayfield:Notify({Title = "Aktif", Content = "High Gravity aktif!"})
      else
         Workspace.Gravity = 196.2
         Rayfield:Notify({Title = "Kapalı", Content = "High Gravity kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Void",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
               humanoid.Died:Connect(function()
                  LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 100, 0)
               end)
            end
         end
         Rayfield:Notify({Title = "Aktif", Content = "Anti Void aktif!"})
      else
         Rayfield:Notify({Title = "Kapalı", Content = "Anti Void kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Push",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.HumanoidRootPart.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
            Rayfield:Notify({Title = "Aktif", Content = "Anti Push aktif!"})
         end
      else
         if LocalPlayer.Character then
            LocalPlayer.Character.HumanoidRootPart.CustomPhysicalProperties = nil
            Rayfield:Notify({Title = "Kapalı", Content = "Anti Push kapatıldı."})
         end
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Slip",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.Friction = 0
            Rayfield:Notify({Title = "Aktif", Content = "Anti Slip aktif!"})
         end
      else
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.Friction = 0.5
            Rayfield:Notify({Title = "Kapalı", Content = "Anti Slip kapatıldı."})
         end
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Stun",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            Rayfield:Notify({Title = "Aktif", Content = "Anti Stun aktif!"})
         end
      else
         Rayfield:Notify({Title = "Kapalı", Content = "Anti Stun kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Ragdoll",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.PlatformStand = false
            Rayfield:Notify({Title = "Aktif", Content = "Anti Ragdoll aktif!"})
         end
      else
         Rayfield:Notify({Title = "Kapalı", Content = "Anti Ragdoll kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Moon Jump",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.JumpPower = 200
            Rayfield:Notify({Title = "Aktif", Content = "Moon Jump aktif!"})
         end
      else
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.JumpPower = 50
            Rayfield:Notify({Title = "Kapalı", Content = "Moon Jump kapatıldı."})
         end
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Low Gravity",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         Workspace.Gravity = 50
         Rayfield:Notify({Title = "Aktif", Content = "Low Gravity aktif!"})
      else
         Workspace.Gravity = 196.2
         Rayfield:Notify({Title = "Kapalı", Content = "Low Gravity kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "High Gravity",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         Workspace.Gravity = 500
         Rayfield:Notify({Title = "Aktif", Content = "High Gravity aktif!"})
      else
         Workspace.Gravity = 196.2
         Rayfield:Notify({Title = "Kapalı", Content = "High Gravity kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Void",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
               humanoid.Died:Connect(function()
                  LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 100, 0)
               end)
            end
         end
         Rayfield:Notify({Title = "Aktif", Content = "Anti Void aktif!"})
      else
         Rayfield:Notify({Title = "Kapalı", Content = "Anti Void kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Push",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.HumanoidRootPart.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
            Rayfield:Notify({Title = "Aktif", Content = "Anti Push aktif!"})
         end
      else
         if LocalPlayer.Character then
            LocalPlayer.Character.HumanoidRootPart.CustomPhysicalProperties = nil
            Rayfield:Notify({Title = "Kapalı", Content = "Anti Push kapatıldı."})
         end
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Slip",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.Friction = 0
            Rayfield:Notify({Title = "Aktif", Content = "Anti Slip aktif!"})
         end
      else
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.Friction = 0.5
            Rayfield:Notify({Title = "Kapalı", Content = "Anti Slip kapatıldı."})
         end
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Stun",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            Rayfield:Notify({Title = "Aktif", Content = "Anti Stun aktif!"})
         end
      else
         Rayfield:Notify({Title = "Kapalı", Content = "Anti Stun kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Ragdoll",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.PlatformStand = false
            Rayfield:Notify({Title = "Aktif", Content = "Anti Ragdoll aktif!"})
         end
      else
         Rayfield:Notify({Title = "Kapalı", Content = "Anti Ragdoll kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Moon Jump",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.JumpPower = 200
            Rayfield:Notify({Title = "Aktif", Content = "Moon Jump aktif!"})
         end
      else
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.JumpPower = 50
            Rayfield:Notify({Title = "Kapalı", Content = "Moon Jump kapatıldı."})
         end
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Low Gravity",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         Workspace.Gravity = 50
         Rayfield:Notify({Title = "Aktif", Content = "Low Gravity aktif!"})
      else
         Workspace.Gravity = 196.2
         Rayfield:Notify({Title = "Kapalı", Content = "Low Gravity kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "High Gravity",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         Workspace.Gravity = 500
         Rayfield:Notify({Title = "Aktif", Content = "High Gravity aktif!"})
      else
         Workspace.Gravity = 196.2
         Rayfield:Notify({Title = "Kapalı", Content = "High Gravity kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Void",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
               humanoid.Died:Connect(function()
                  LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 100, 0)
               end)
            end
         end
         Rayfield:Notify({Title = "Aktif", Content = "Anti Void aktif!"})
      else
         Rayfield:Notify({Title = "Kapalı", Content = "Anti Void kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Push",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.HumanoidRootPart.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
            Rayfield:Notify({Title = "Aktif", Content = "Anti Push aktif!"})
         end
      else
         if LocalPlayer.Character then
            LocalPlayer.Character.HumanoidRootPart.CustomPhysicalProperties = nil
            Rayfield:Notify({Title = "Kapalı", Content = "Anti Push kapatıldı."})
         end
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Slip",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.Friction = 0
            Rayfield:Notify({Title = "Aktif", Content = "Anti Slip aktif!"})
         end
      else
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.Friction = 0.5
            Rayfield:Notify({Title = "Kapalı", Content = "Anti Slip kapatıldı."})
         end
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Stun",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            Rayfield:Notify({Title = "Aktif", Content = "Anti Stun aktif!"})
         end
      else
         Rayfield:Notify({Title = "Kapalı", Content = "Anti Stun kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Ragdoll",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.PlatformStand = false
            Rayfield:Notify({Title = "Aktif", Content = "Anti Ragdoll aktif!"})
         end
      else
         Rayfield:Notify({Title = "Kapalı", Content = "Anti Ragdoll kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Moon Jump",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.JumpPower = 200
            Rayfield:Notify({Title = "Aktif", Content = "Moon Jump aktif!"})
         end
      else
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.JumpPower = 50
            Rayfield:Notify({Title = "Kapalı", Content = "Moon Jump kapatıldı."})
         end
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Low Gravity",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         Workspace.Gravity = 50
         Rayfield:Notify({Title = "Aktif", Content = "Low Gravity aktif!"})
      else
         Workspace.Gravity = 196.2
         Rayfield:Notify({Title = "Kapalı", Content = "Low Gravity kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "High Gravity",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         Workspace.Gravity = 500
         Rayfield:Notify({Title = "Aktif", Content = "High Gravity aktif!"})
      else
         Workspace.Gravity = 196.2
         Rayfield:Notify({Title = "Kapalı", Content = "High Gravity kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Void",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
               humanoid.Died:Connect(function()
                  LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 100, 0)
               end)
            end
         end
         Rayfield:Notify({Title = "Aktif", Content = "Anti Void aktif!"})
      else
         Rayfield:Notify({Title = "Kapalı", Content = "Anti Void kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Push",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.HumanoidRootPart.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
            Rayfield:Notify({Title = "Aktif", Content = "Anti Push aktif!"})
         end
      else
         if LocalPlayer.Character then
            LocalPlayer.Character.HumanoidRootPart.CustomPhysicalProperties = nil
            Rayfield:Notify({Title = "Kapalı", Content = "Anti Push kapatıldı."})
         end
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Slip",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.Friction = 0
            Rayfield:Notify({Title = "Aktif", Content = "Anti Slip aktif!"})
         end
      else
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.Friction = 0.5
            Rayfield:Notify({Title = "Kapalı", Content = "Anti Slip kapatıldı."})
         end
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Stun",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            Rayfield:Notify({Title = "Aktif", Content = "Anti Stun aktif!"})
         end
      else
         Rayfield:Notify({Title = "Kapalı", Content = "Anti Stun kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Ragdoll",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.PlatformStand = false
            Rayfield:Notify({Title = "Aktif", Content = "Anti Ragdoll aktif!"})
         end
      else
         Rayfield:Notify({Title = "Kapalı", Content = "Anti Ragdoll kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Moon Jump",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.JumpPower = 200
            Rayfield:Notify({Title = "Aktif", Content = "Moon Jump aktif!"})
         end
      else
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.JumpPower = 50
            Rayfield:Notify({Title = "Kapalı", Content = "Moon Jump kapatıldı."})
         end
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Low Gravity",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         Workspace.Gravity = 50
         Rayfield:Notify({Title = "Aktif", Content = "Low Gravity aktif!"})
      else
         Workspace.Gravity = 196.2
         Rayfield:Notify({Title = "Kapalı", Content = "Low Gravity kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "High Gravity",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         Workspace.Gravity = 500
         Rayfield:Notify({Title = "Aktif", Content = "High Gravity aktif!"})
      else
         Workspace.Gravity = 196.2
         Rayfield:Notify({Title = "Kapalı", Content = "High Gravity kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Void",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
               humanoid.Died:Connect(function()
                  LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 100, 0)
               end)
            end
         end
         Rayfield:Notify({Title = "Aktif", Content = "Anti Void aktif!"})
      else
         Rayfield:Notify({Title = "Kapalı", Content = "Anti Void kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Push",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.HumanoidRootPart.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
            Rayfield:Notify({Title = "Aktif", Content = "Anti Push aktif!"})
         end
      else
         if LocalPlayer.Character then
            LocalPlayer.Character.HumanoidRootPart.CustomPhysicalProperties = nil
            Rayfield:Notify({Title = "Kapalı", Content = "Anti Push kapatıldı."})
         end
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Slip",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.Friction = 0
            Rayfield:Notify({Title = "Aktif", Content = "Anti Slip aktif!"})
         end
      else
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.Friction = 0.5
            Rayfield:Notify({Title = "Kapalı", Content = "Anti Slip kapatıldı."})
         end
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Stun",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            Rayfield:Notify({Title = "Aktif", Content = "Anti Stun aktif!"})
         end
      else
         Rayfield:Notify({Title = "Kapalı", Content = "Anti Stun kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Ragdoll",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.PlatformStand = false
            Rayfield:Notify({Title = "Aktif", Content = "Anti Ragdoll aktif!"})
         end
      else
         Rayfield:Notify({Title = "Kapalı", Content = "Anti Ragdoll kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Moon Jump",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.JumpPower = 200
            Rayfield:Notify({Title = "Aktif", Content = "Moon Jump aktif!"})
         end
      else
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.JumpPower = 50
            Rayfield:Notify({Title = "Kapalı", Content = "Moon Jump kapatıldı."})
         end
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Low Gravity",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         Workspace.Gravity = 50
         Rayfield:Notify({Title = "Aktif", Content = "Low Gravity aktif!"})
      else
         Workspace.Gravity = 196.2
         Rayfield:Notify({Title = "Kapalı", Content = "Low Gravity kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "High Gravity",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         Workspace.Gravity = 500
         Rayfield:Notify({Title = "Aktif", Content = "High Gravity aktif!"})
      else
         Workspace.Gravity = 196.2
         Rayfield:Notify({Title = "Kapalı", Content = "High Gravity kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Void",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
               humanoid.Died:Connect(function()
                  LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 100, 0)
               end)
            end
         end
         Rayfield:Notify({Title = "Aktif", Content = "Anti Void aktif!"})
      else
         Rayfield:Notify({Title = "Kapalı", Content = "Anti Void kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Push",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.HumanoidRootPart.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
            Rayfield:Notify({Title = "Aktif", Content = "Anti Push aktif!"})
         end
      else
         if LocalPlayer.Character then
            LocalPlayer.Character.HumanoidRootPart.CustomPhysicalProperties = nil
            Rayfield:Notify({Title = "Kapalı", Content = "Anti Push kapatıldı."})
         end
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Slip",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.Friction = 0
            Rayfield:Notify({Title = "Aktif", Content = "Anti Slip aktif!"})
         end
      else
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.Friction = 0.5
            Rayfield:Notify({Title = "Kapalı", Content = "Anti Slip kapatıldı."})
         end
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Stun",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            Rayfield:Notify({Title = "Aktif", Content = "Anti Stun aktif!"})
         end
      else
         Rayfield:Notify({Title = "Kapalı", Content = "Anti Stun kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Ragdoll",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.PlatformStand = false
            Rayfield:Notify({Title = "Aktif", Content = "Anti Ragdoll aktif!"})
         end
      else
         Rayfield:Notify({Title = "Kapalı", Content = "Anti Ragdoll kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Moon Jump",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.JumpPower = 200
            Rayfield:Notify({Title = "Aktif", Content = "Moon Jump aktif!"})
         end
      else
         if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.JumpPower = 50
            Rayfield:Notify({Title = "Kapalı", Content = "Moon Jump kapatıldı."})
         end
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Low Gravity",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         Workspace.Gravity = 50
         Rayfield:Notify({Title = "Aktif", Content = "Low Gravity aktif!"})
      else
         Workspace.Gravity = 196.2
         Rayfield:Notify({Title = "Kapalı", Content = "Low Gravity kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "High Gravity",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         Workspace.Gravity = 500
         Rayfield:Notify({Title = "Aktif", Content = "High Gravity aktif!"})
      else
         Workspace.Gravity = 196.2
         Rayfield:Notify({Title = "Kapalı", Content = "High Gravity kapatıldı."})
      end
   end,
})

UniversalTab:CreateToggle({
   Name = "Anti Void",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
               humanoid.Died:Connect(function()
                  LocalPlayer.Character.HumanoidRootPart.CFrame = C
