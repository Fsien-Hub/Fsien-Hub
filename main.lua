local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- GÜVENLİK/REMOTE AYARLARI (SimpleSpy ile bunları bulmalısın!)
local RemoteContainer = game:GetService("ReplicatedStorage"):WaitForChild("Remotes") -- Burayı kontrol et
local EconomyRemote = RemoteContainer:FindFirstChild("UpgradeEconomy") -- Remote ismi
local MilitaryRemote = RemoteContainer:FindFirstChild("TrainArmy")      -- Remote ismi
local WarRemote = RemoteContainer:FindFirstChild("AttackTerritory")    -- Remote ismi

local Window = Rayfield:CreateWindow({Name = "FsienHub PRO - AI Manager", LoadingTitle = "AI Yükleniyor...", LoadingSubtitle = "by Fsien"})
local AIMode = "None"
local AIActive = false

-- AI DÖNGÜSÜ
task.spawn(function()
    while true do
        if AIActive then
            if AIMode == "Ekonomi" and EconomyRemote then
                EconomyRemote:FireServer("AutoUpgrade") -- Örnek: "AutoUpgrade" argümanı
            elseif AIMode == "Askeri" and MilitaryRemote then
                MilitaryRemote:FireServer("TrainFull")
            elseif AIMode == "Savaş" and WarRemote then
                WarRemote:FireServer("FastAttack")
            end
        end
        task.wait(0.2) -- Sunucuyu yormamak için kısa delay
    end
end)

-- UI Ekleme
local MainTab = Window:CreateTab("AI Yönetimi", nil)

MainTab:CreateDropdown({
   Name = "AI Modunu Seç",
   Options = {"Ekonomi", "Askeri", "Savaş"},
   CurrentOption = "Ekonomi",
   Callback = function(Option)
      AIMode = Option
      print("Mod değişti: " .. Option)
   end,
})

MainTab:CreateToggle({
   Name = "AI Yönetimini Başlat",
   CurrentValue = false,
   Callback = function(Value)
      AIActive = Value
   end,
})

-- Hızlı Erişim (Manuel)
MainTab:CreateButton({
   Name = "Full Ekonomik Kalkınma (Tek At)",
   Callback = function()
      if EconomyRemote then EconomyRemote:FireServer("Max") end
   end,
})
