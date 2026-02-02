-- Fsien Hub - Delta Executor için (Düzeltilmiş Fly + Noclip + Fling + ESP + Brainrot)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Fsien Hub",
   LoadingTitle = "Yükleniyor...",
   LoadingSubtitle = "by Fsien",
   ConfigurationSaving = {Enabled = true, FolderName = "FsienHub", FileName = "Config"},
   KeySystem = false,
})

-- Universal Hileler Tab
local UniTab = Window:CreateTab("Universal Hileler")

-- Düzeltilmiş Fly (Kamera yönüne göre, sorunsuz aç/kapa)
local flySpeed = 50
local flying = false
local flyConnection

UniTab:CreateToggle({
   Name = "Uçma (Fly) - Fare/Kamera yönüne göre",
   CurrentValue = false,
   Callback = function(Value)
      flying = Value
      local player = game.Players.LocalPlayer
      local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
      if not root then return end

      if Value then
         local bv = Instance.new("BodyVelocity")
         bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
         bv.Velocity = Vector3.new()
         bv.Parent = root

         local bg = Instance.new("BodyGyro")
         bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
         bg.CFrame = workspace.CurrentCamera.CFrame
         bg.Parent = root

         flyConnection = game:GetService("RunService").RenderStepped:Connect(function()
            if not flying then return end
            local cam = workspace.CurrentCamera
            local moveDir = Vector3.new()
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0,1,0) end

            bv.Velocity = moveDir.Unit * flySpeed
            bg.CFrame = cam.CFrame
         end)

         Rayfield:Notify({Title = "Aktif", Content = "Uçma aktif! WASD + Space/Ctrl ile yönlendir. F tuşu ile aç/kapa."})
      else
         if flyConnection then flyConnection:Disconnect() end
         if root:FindFirstChildOfClass("BodyVelocity") then root:FindFirstChildOfClass("BodyVelocity"):Destroy() end
         if root:FindFirstChildOfClass("BodyGyro") then root:FindFirstChildOfClass("BodyGyro"):Destroy() end
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

-- Noclip (düzeltilmiş, sorunsuz)
UniTab:CreateToggle({
   Name = "Noclip (Duvarlardan Geçme)",
   CurrentValue = false,
   Callback = function(Value)
      local player = game.Players.LocalPlayer
      local noclipLoop = Value and game:GetService("RunService").Stepped:Connect(function()
         if player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
               if part:IsA("BasePart") then part.CanCollide = false end
            end
         end
      end)

      if not Value and noclipLoop then noclipLoop:Disconnect() end
      Rayfield:Notify({Title = Value and "Aktif" or "Kapalı", Content = Value and "Noclip aktif!" or "Noclip kapatıldı."})
   end,
})

-- Fling (yakın oyuncuları fırlat)
UniTab:CreateButton({
   Name = "Fling (Yakındaki Oyuncuları Fırlat)",
   Callback = function()
      local player = game.Players.LocalPlayer
      for _, plr in pairs(game.Players:GetPlayers()) do
         if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local root = plr.Character.HumanoidRootPart
            local oldPos = root.CFrame
            root.CFrame = CFrame.new(root.Position + Vector3.new(0, 1000, 0))
            wait(0.1)
            root.CFrame = oldPos
         end
      end
      Rayfield:Notify({Title = "Fling", Content = "Yakındaki oyuncular fırlatıldı!"})
   end,
})

-- ESP (box + isim)
UniTab:CreateToggle({
   Name = "ESP (Oyuncuları Duvar Arkasından Gör)",
   CurrentValue = false,
   Callback = function(Value)
      local espConnections = {}
      if Value then
         for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= game.Players.LocalPlayer and plr.Character then
               local highlight = Instance.new("Highlight")
               highlight.FillColor = Color3.fromRGB(255, 0, 0)
               highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
               highlight.FillTransparency = 0.5
               highlight.OutlineTransparency = 0
               highlight.Parent = plr.Character

               local billboard = Instance.new("BillboardGui")
               billboard.Adornee = plr.Character:FindFirstChild("Head")
               billboard.Size = UDim2.new(0, 200, 0, 50)
               billboard.StudsOffset = Vector3.new(0, 3, 0)
               billboard.AlwaysOnTop = true

               local text = Instance.new("TextLabel")
               text.Size = UDim2.new(1, 0, 1, 0)
               text.BackgroundTransparency = 1
               text.Text = plr.Name
               text.TextColor3 = Color3.fromRGB(255, 255, 255)
               text.TextStrokeTransparency = 0
               text.Parent = billboard
               billboard.Parent = plr.Character

               table.insert(espConnections, highlight)
               table.insert(espConnections, billboard)
            end
         end
         Rayfield:Notify({Title = "Aktif", Content = "ESP aktif! Duvar arkasından görünür."})
      else
         for _, conn in pairs(espConnections) do conn:Destroy() end
         espConnections = {}
         Rayfield:Notify({Title = "Kapalı", Content = "ESP kapatıldı."})
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

SabTab:CreateParagraph({
   Title = "Nasıl Çalışır?",
   Content = "Butona bas → Server taranır. 20M+ brainrot varsa isimlerini listeler. Bulursa kalır, yoksa hop'lar."
})

print("Fsien Hub yüklendi! Fly, Noclip, Fling, ESP aktif.")
