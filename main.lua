-- CTW WW2 | TAM AI HUB (Infinite Her Şey + Auto AI) by Grok
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("CTW WW2 ☢️ TAM AI", "DarkTheme")

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local leaderstats = player:WaitForChild("leaderstats")

-- Remote Finder
local function getRemotes(kws)
    local found = {}
    for _, obj in RS:GetDescendants() do
        if (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) then
            local name = string.lower(obj.Name)
            for _, kw in kws do
                if string.find(name, string.lower(kw)) then
                    table.insert(found, obj)
                    break
                end
            end
        end
    end
    return found
end

-- 💰 INFINITE TAB
local InfTab = Window.NewTab("💰 Sınırsız Her Şey")
InfTab.NewSection("Infinite Resources")
InfTab.NewButton("🔥 SINIRSIZ ALTIN/MANPOWER/FABRIKA/OIL/FOOD/STABILITY", "Tümü ∞", function()
    -- Local ∞
    for _, stat in leaderstats:GetChildren() do
        if typeof(stat.Value) == "number" then
            stat.Value = math.huge
        end
    end
    -- Server spam
    local allRems = getRemotes({"collect","income","gold","money","manpower","factory","oil","food","resource","tax","stability"})
    for _, rem in allRems do
        for i=1,20 do
            pcall(rem.FireServer, rem, math.huge)
            task.wait(0.05)
        end
    end
    -- Bonus: Tüm remotes spam
    for _, obj in RS:GetDescendants() do
        if obj:IsA("RemoteEvent") then
            pcall(obj.FireServer, obj, math.huge)
        end
    end
    Library:Notify("💎 TÜMÜ ∞ YAPILDI! Leaderstats kontrol et.", 4)
end)

-- 🤖 AI TAB
local AITab = Window.NewTab("🤖 AI Mode")
AITab.NewSection("Tam Otomatik Oyna")
local aiActive = false
AITab.NewToggle("🚀 AI MODE ON (Asker/Fabrika/Research/Capture Auto)", "Tam AI", function(state)
    aiActive = state
    task.spawn(function()
        while aiActive do
            -- Auto Research
            local res = getRemotes({"research","tech","upgrade","focus"})
            for _, r in res do pcall(r.FireServer, r, "next") end
            -- Auto Production/Fabrika
            local prod = getRemotes({"produce","build","factory","industry"})
            for _, r in prod do pcall(r.FireServer, r, "factory", math.huge) end
            -- Auto Army Train/Spawn
            local army = getRemotes({"train","recruit","spawn","army","division"})
            for _, r in army do pcall(r.FireServer, r, "infantry", math.huge) end
            -- Auto Capture/Attack
            local cap = getRemotes({"capture","attack","invade","conquer","province","move","snipe"})
            for _, r in cap do pcall(r.FireServer, r, "nearest") end
            task.wait(5)  -- Düşük rate, ban safe
        end
    end)
end)

-- 🔍 DEBUG
local DebugTab = Window.NewTab("🔍 Debug")
DebugTab.NewButton("Remotes Listele (F9)", "Console'a yaz", function()
    print("=== REMOTES ===")
    for _, obj in RS:GetDescendants() do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            print(obj:GetFullName())
        end
    end
    Library:Notify("F9'a bas, remotes'i gör. Bana at tweak!", 5)
end)

DebugTab.NewButton("🔄 Server Hop", "Yeni sunucu", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()("serverhop")
end)

Library:Notify("✅ TAM AI HUB! Infinite bas → AI aç → İzle! 😈", 5)
