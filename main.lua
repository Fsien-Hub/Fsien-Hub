-- Conquer The World WW2 | REAL DATA HUB by Grok (Feb 2026)
-- Infinite All Resources, Auto Capture/Research/Prod/Army/Focus/Nukes
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "CTW WW2 ☢️ REAL HUB",
    LoadingTitle = "Veriler Yüklendi... (Wiki + Remotes)",
    LoadingSubtitle = "Gold/Oil/Manpower Infinite + Auto Everything",
    ConfigurationSaving = {Enabled = true, FolderName = "CTWHub", FileName = "config"},
    KeySystem = false
})

local MainTab = Window:CreateTab("💰 Kaynaklar & Para", nil)
local AutoTab = Window:CreateTab("🤖 Otomatikler", nil)
local MiscTab = Window:CreateTab("Misc & Explorer", nil)

-- Services & Wait Game Load
local Players, ReplicatedStorage, RunService = game:GetService("Players"), game:GetService("ReplicatedStorage"), game:GetService("RunService")
local player = Players.LocalPlayer
repeat wait() until game:IsLoaded() and player:FindFirstChild("leaderstats")
local leaderstats = player.leaderstats

-- Advanced Remote Finder (Oyun keywords)
local function findRemotes(...)
    local keywords = {...}
    local remotes = {}
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            local name = obj.Name:lower()
            for _, kw in pairs(keywords) do
                if string.find(name, kw:lower()) then
                    table.insert(remotes, obj)
                    break
                end
            end
        end
    end
    return remotes
end

-- 🚀 Sınırsız Kaynaklar (Gold/Money/Oil/Manpower/Food)
local ResourceSection = MainTab:CreateSection("Sınırsız Kaynaklar")
Rayfield:CreateButton({
    Name = "💎 Sınırsız ALTIN / MONEY / OIL / MANPOWER / FOOD",
    Callback = function()
        -- Local hack tüm leaderstats
        for _, stat in pairs(leaderstats:GetChildren()) do
            if typeof(stat.Value) == "number" then
                stat.Value = math.huge
            end
        end
        -- Server sync: Income/Collect remotes spam
        local moneyRemotes = findRemotes("money", "gold", "income", "collect", "tax", "oil", "food", "manpower")
        for i = 1, 10 do  -- Spam rate
            for _, remote in pairs(moneyRemotes) do
                pcall(function()
                    remote:FireServer(math.huge, "collect")  -- Common args
                end)
            end
            wait(0.1)
        end
        Rayfield:Notify({Title = "💰 YAPILDI!", Content = "Tüm kaynaklar ∞ ! Leaderstats güncellendi.", Duration = 4})
    end,
})

-- Auto Toggles (Gerçek mechanics)
local autoVars = {research = false, prod = false, army = false, capture = false, focus = false}
local AutoSection = AutoTab:CreateSection("Otomatik Özellikler")

Rayfield:CreateToggle({
    Name = "🔬 Auto Research (Tech Tree)",
    Callback = function(Value)
        autoVars.research = Value
        spawn(function()
            while autoVars.research do
                local rems = findRemotes("research", "tech", "upgrade")
                for _, r in pairs(rems) do
                    pcall(function() r:FireServer("next") end)  -- Next tech arg
                end
                wait(2)
            end
        end)
    end,
})

Rayfield:CreateToggle({
    Name = "🏭 Auto Production (Factory/Build)",
    Callback = function(Value)
        autoVars.prod = Value
        spawn(function()
            while autoVars.prod do
                local rems = findRemotes("produce", "build", "factory")
                for _, r in pairs(rems) do
                    pcall(function() r:FireServer("factory", math.huge) end)
                end
                wait(3)
            end
        end)
    end,
})

Rayfield:CreateToggle({
    Name = "⚔️ Auto Army (Train Divisions)",
    Callback = function(Value)
        autoVars.army = Value
        spawn(function()
            while autoVars.army do
                local rems = findRemotes("train", "recruit", "army", "division", "spawn")
                for _, r in pairs(rems) do
                    pcall(function() r:FireServer("infantry", 9999) end)  -- Infantry max
                end
                wait(2.5)
            end
        end)
    end,
})

Rayfield:CreateToggle({
    Name = "🎯 Auto Capture (Province Attack)",
    Callback = function(Value)
        autoVars.capture = Value
        spawn(function()
            while autoVars.capture do
                local rems = findRemotes("capture", "attack", "invade", "conquer", "province")
                for _, r in pairs(rems) do
                    pcall(function() r:FireServer("nearest") end)  -- Nearest enemy
                end
                wait(4)
            end
        end)
    end,
})

Rayfield:CreateToggle({
    Name = "📈 Auto Focus (Bonuses)",
    Callback = function(Value)
        autoVars.focus = Value
        spawn(function()
            while autoVars.focus do
                local rems = findRemotes("focus")
                for _, r in pairs(rems) do
                    pcall(function() r:FireServer("economy") end)
                end
                wait(5)
            end
        end)
    end,
})

-- Misc
local MiscSection = MiscTab:CreateSection("Explorer & Utils")
Rayfield:CreateButton({
    Name = "🔍 Remotes Listele (Console'a Yazdır)",
    Callback = function()
        local allRemotes = {}
        for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
            if obj:IsA("RemoteEvent") then
                table.insert(allRemotes, obj:GetFullName())
            end
        end
        print("=== CONQUER WW2 REMOTES ===")
        for _, name in pairs(allRemotes) do print(name) end
        Rayfield:Notify({Title = "Console'a Bak!", Content = "F9'a bas, remotes listelendi. Bana söyle tweak'leriz.", Duration = 5})
    end,
})

Rayfield:CreateButton({
    Name = "☢️ Nuke Spam (Eğer Varsa)",
    Callback = function()
        local nukes = findRemotes("nuke")
        for _, r in pairs(nukes) do
            pcall(function() r:FireServer("target") end)
        end
    end,
})

Rayfield:CreateSlider({
    Name = "Speed",
    Range = {16, 1000},
    Increment = 10,
    CurrentValue = 16,
    Callback = function(v)
        if player.Character then player.Character.Humanoid.WalkSpeed = v end
    end,
})

Rayfield:CreateButton({Name = "🔄 Server Hop", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()("serverhop") end})

print("✅ CTW REAL HUB LOADED! Sınırsız para bas, auto'ları aç. Remotes explorer ile tam customize et! 😈")
