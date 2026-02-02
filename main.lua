-- Fsien Hub - Delta Executor için (Uçma, Noclip, Fling, ESP + Brainrot scanner)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Fsien Hub",
   LoadingTitle = "Yükleniyor...",
   LoadingSubtitle = "by Fsien",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "FsienHub",
      FileName = "Config"
   },
   KeySystem = false,
})

-- Universal Hileler Tab
local UniTab = Window:CreateTab("Universal Hileler")

-- Fly
UniTab:CreateToggle({
   Name = "Uçma (Fly) - F tuşu ile aç/kapa",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         local player = game.Players.LocalPlayer
         local mouse = player:GetMouse()
         local flying = true
         local speed = 50

         local function flyLoop()
            while flying do
               wait()
               if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                  local root = player.Character.HumanoidRootPart
                  local move = Vector3.new(0,0,0)
                  if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then move = move + Vector3.new(0,0,-1) end
                  if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then move = move + Vector3.new(0,0,1) end
                  if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then move = move + Vector3.new(-1,0,0) end
                  if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then move = move + Vector3.new(1,0,0) end
                  if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
                  if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftControl) then move = move + Vector3.new(0,-1,0) end
                  root.Velocity = (mouse.Hit.p - root.Position).unit * speed + move * speed
               end
            end
         end

         spawn(flyLoop)
         Rayfield:Notify({Title = "Aktif", Content = "Uçma aktif! F tuşuna basarak aç/kapa."})
      else
         flying = false
         Rayfield:Notify({Title = "Kapalı", Content = "Uçma kapatıldı."})
      end
   end,
})

-- Noclip
UniTab:CreateToggle({
   Name = "Noclip (Duvarlardan Geçme)",
   CurrentValue = false,
   Callback = function(Value)
      local noclip = Value
      local player = game.Players.LocalPlayer

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
         Rayfield:Notify({Title = "Aktif", Content = "Noclip aktif! Duvarlardan geçebilirsin."})
      else
         Rayfield:Notify({Title = "Kapalı", Content = "Noclip kapatıldı."})
      end
   end,
})

-- Fling
UniTab:CreateButton({
   Name = "Fling (Yakındaki Oyuncuları Fırlat)",
   Callback = function()
      local player = game.Players.LocalPlayer
      for _, plr in pairs(game.Players:GetPlayers()) do
         if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local root = plr.Character.HumanoidRootPart
            local oldPos = root.CFrame
            root.CFrame = CFrame.new(root.Position + Vector3.new(0,1000,0))
            wait(0.1)
            root.CFrame = oldPos
         end
      end
      Rayfield:Notify({Title = "Fling", Content = "Yakındaki oyuncular fırlatıldı!"})
   end,
})

-- ESP (Basit box + isim)
UniTab:CreateToggle({
   Name = "ESP (Oyuncuları Duvar Arkasından Gör)",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= game.Players.LocalPlayer and plr.Character then
               local highlight = Instance.new("Highlight")
               highlight.FillColor = Color3.fromRGB(255,0,0)
               highlight.OutlineColor = Color3.fromRGB(255,255,0)
               highlight.FillTransparency = 0.5
               highlight.OutlineTransparency = 0
               highlight.Parent = plr.Character
               local billboard = Instance.new("BillboardGui")
               billboard.Adornee = plr.Character:FindFirstChild("Head")
               billboard.Size = UDim2.new(0,200,0,50)
               billboard.StudsOffset = Vector3.new(0,3,0)
               billboard.AlwaysOnTop = true
               local text = Instance.new("TextLabel")
               text.Size = UDim2.new(1,0,1,0)
               text.BackgroundTransparency = 1
               text.Text = plr.Name
               text.TextColor3 = Color3.fromRGB(255,255,255)
               text.TextStrokeTransparency = 0
               text.Parent = billboard
               billboard.Parent = plr.Character
            end
         end
         Rayfield:Notify({Title = "Aktif", Content = "ESP aktif! Oyuncular duvar arkasından görünüyor."})
      else
         for _, plr in pairs(game.Players:GetPlayers()) do
            if plr.Character then
               if plr.Character:FindFirstChildOfClass("Highlight") then
                  plr.Character:FindFirstChildOfClass("Highlight"):Destroy()
               end
               if plr.Character:FindFirstChildOfClass("BillboardGui") then
                  plr.Character:FindFirstChildOfClass("BillboardGui"):Destroy()
               end
            end
         end
         Rayfield:Notify({Title = "Kapalı", Content = "ESP kapatıldı."})
      end
   end,
})

-- Steal a Brainrot Tab (önceki kodun aynısı)
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

print("Fsien Hub yüklendi! Fly, Noclip, Fling, ESP aktif.")
