-- FsienHub | Conquer the World AIO
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "FsienHub | Conquer the World",
   LoadingTitle = "FsienHub Yükleniyor...",
   LoadingSubtitle = "by Fsien",
   ConfigurationSaving = { Enabled = true, FolderName = "FsienHub", FileName = "ConquerData" },
   KeySystem = false
})

-- TABLAR
local MainTab = Window:CreateTab("Genel", nil)
local FarmTab = Window:CreateTab("Otomatikler", nil)
local PlayerTab = Window:CreateTab("Oyuncu", nil)

-- OYUN DEĞİŞKENLERİ (Buraları RemoteSpy ile bulup güncelle!)
local RS = game:GetService("ReplicatedStorage")
local Remotes = RS:FindFirstChild("Remotes") or RS -- Remote klasörünü buraya yaz
local MoneyEvent = Remotes:FindFirstChild("UpdateMoney") -- ÖRNEK: Remote ismi
local AttackEvent = Remotes:FindFirstChild("Attack")     -- ÖRNEK: Remote ismi

-- ÖZELLİKLER
MainTab:CreateButton({
   Name = "Parayı Maksimum Yap",
   Callback = function()
      if MoneyEvent then MoneyEvent:FireServer("SetMax") end
   end,
})

FarmTab:CreateToggle({
   Name = "Otomatik Kaynak Topla",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoCollect = Value
      task.spawn(function()
         while _G.AutoCollect do
            if Remotes:FindFirstChild("Collect") then Remotes.Collect:FireServer() end
            task.wait(0.5)
         end
      end)
   end,
})

FarmTab:CreateToggle({
   Name = "Otomatik Fetih (Auto-Conquer)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoConquer = Value
      task.spawn(function()
         while _G.AutoConquer do
            if AttackEvent then AttackEvent:FireServer("All") end
            task.wait(1)
         end
      end)
   end,
})

PlayerTab:CreateSlider({
   Name = "Yürüme Hızı",
   Range = {16, 200},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(Value)
      game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end,
})

PlayerTab:CreateButton({
   Name = "Sonsuz Zıplama",
   Callback = function()
      local Humanoid = game.Players.LocalPlayer.Character.Humanoid
      Humanoid.Changed:connect(function(Prop)
         if Prop == "Jump" and Humanoid.Jump == true then Humanoid.Jump = true end
      end)
   end,
})

Rayfield:LoadConfiguration()
