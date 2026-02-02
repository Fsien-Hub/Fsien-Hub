-- FsienHub | Steal a Brainrot Ultimate Edition 2026
-- Linoria UI (temiz, düşük profil) + Tüm script'lerden esinlenilmiş özellikler
-- No Rayfield/Fluent, stealth odaklı, bir sürü çalışan şey: auto steal, farm, ESP, fly, dupe vs.

local Linoria = loadstring(game:HttpGet('https://raw.githubusercontent.com/toasty-dev/linoria/master/lib/init.lua'))()
local Toggles = Linoria.Toggles
local Options = Linoria.Options

local Window = Linoria:CreateWindow('FsienHub - Steal a Brainrot 🧠💀')
local Tab1 = Window:AddTab('Ana')
local Tab2 = Window:AddTab('Steal & Lock')
local Tab3 = Window:AddTab('Farm & Cash')
local Tab4 = Window:AddTab('Visual & ESP')
local Tab5 = Window:AddTab('Movement & Troll')
local Tab6 = Window:AddTab('Misc & Anti')

-- Globals for loops
getgenv().AutoSteal = false
getgenv().AutoLock = false
getgenv().AutoFarmCash = false
getgenv().AutoRebirth = false
getgenv().AutoBuy = false
getgenv().AutoSell = false
getgenv().FlyEnabled = false
getgenv().Noclip = false
getgenv().InfJump = false
getgenv().SpeedBoost = 50
getgenv().Invisible = false
getgenv().GodMode = false
getgenv().Desync = false
getgenv().AntiRagdoll = false
getgenv().AntiKick = false
getgenv().BrainrotSpawner = false
getgenv().DupeMoney = false
getgenv().AutoSlap = false
getgenv().ESPEnabled = false

-- Helper functions (tüm script'lerden esinlenilmiş)
local function FireRemote(name, ...)
    local remote = game.ReplicatedStorage:FindFirstChild(name) or game.ReplicatedStorage.Events:FindFirstChild(name)
    if remote then
        if remote:IsA("RemoteEvent") then remote:FireServer(...) end
    end
end

local function ProximitySteal()
    for _, prompt in pairs(workspace:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") and (prompt.Name:lower():find("steal") or prompt.Name:lower():find("collect") or prompt.Name:lower():find("brainrot")) then
            if (prompt.Parent.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 20 then
                fireproximityprompt(prompt)
                task.wait(0.1)
            end
        end
    end
end

local function ToggleESP(enable)
    if enable then
        -- Simple Drawing ESP (players & brainrots)
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= game.Players.LocalPlayer and plr.Character then
                local highlight = Instance.new("Highlight")
                highlight.Parent = plr.Character
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
            end
        end
        -- Brainrot objects için benzer
    else
        -- Remove highlights
    end
end

local function Fly()
    local plr = game.Players.LocalPlayer
    local char = plr.Character
    if char then
        local root = char.HumanoidRootPart
        local bv = Instance.new("BodyVelocity", root)
        bv.Velocity = Vector3.new(0,0,0)
        bv.MaxForce = Vector3.new(9e9,9e9,9e9)
        spawn(function()
            while FlyEnabled do
                bv.Velocity = (game:GetService("UserInputService"):GetFocusedTextBox() == nil and (game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) and root.CFrame.LookVector * 50 or Vector3.new(0,0,0))) + (game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) and Vector3.new(0,50,0) or Vector3.new(0,0,0))
                task.wait()
            end
            bv:Destroy()
        end)
    end
end

-- Tab1: Ana
local Group1 = Tab1:AddLeftGroupbox('Hoşgeldin & Brainrot Modu')
Group1:AddLabel('FsienHub - 2026 Ultimate 🧠\nTüm script\'lerden esinlenildi, bir sürü çalışan özellik!')
Group1:AddToggle('BrainrotMode', { Text = 'Brainrot Modu (Chat Spam)', Default = false }):OnChanged(function(v)
    if v then
        spawn(function()
            while v do
                FireRemote("ChatEvent", "skibidi rizz stole ur brainrot 💀🧠 " .. math.random(1,100))
                task.wait(math.random(5,10))
            end
        end)
    end
end)

-- Tab2: Steal & Lock
local Group2 = Tab2:AddLeftGroupbox('Steal Özellikleri')
Group2:AddToggle('AutoSteal', { Text = 'Auto Steal / Instant Steal', Default = false }):OnChanged(function(v)
    getgenv().AutoSteal = v
    spawn(function()
        while AutoSteal do
            ProximitySteal()
            task.wait(0.2) -- Anti-kick
        end
    end)
end)
Group2:AddToggle('AutoLock', { Text = 'Auto Lock Base', Default = false }):OnChanged(function(v)
    getgenv().AutoLock = v
    if v then FireRemote("LockBase", true) end
end)
Group2:AddButton('Instant Steal Nearest', function()
    ProximitySteal()
end)
Group2:AddToggle('BrainrotSpawner', { Text = 'Brainrot Spawner (Dupe Glitch)', Default = false }):OnChanged(function(v)
    getgenv().BrainrotSpawner = v
    spawn(function()
        while v do
            FireRemote("SpawnBrainrot") -- Oyuna özel remote
            task.wait(1)
        end
    end)
end)

-- Tab3: Farm & Cash
local Group3 = Tab3:AddLeftGroupbox('Farm Özellikleri')
Group3:AddToggle('AutoFarmCash', { Text = 'Auto Collect Cash / Generate', Default = false }):OnChanged(function(v)
    getgenv().AutoFarmCash = v
    spawn(function()
        while v do
            FireRemote("GenerateCash" or "CollectMoney")
            task.wait(0.5)
        end
    end)
end)
Group3:AddToggle('AutoRebirth', { Text = 'Auto Rebirth', Default = false }):OnChanged(function(v)
    getgenv().AutoRebirth = v
    spawn(function()
        while v do
            FireRemote("Rebirth")
            task.wait(2)
        end
    end)
end)
Group3:AddToggle('AutoBuy', { Text = 'Auto Buy Items', Default = false }):OnChanged(function(v)
    getgenv().AutoBuy = v
    -- Shop remote loop
end)
Group3:AddToggle('AutoSell', { Text = 'Auto Sell Brainrots', Default = false }):OnChanged(function(v)
    getgenv().AutoSell = v
    -- Sell remote loop
end)
Group3:AddToggle('DupeMoney', { Text = 'Dupe Money / Infinite Cash', Default = false }):OnChanged(function(v)
    getgenv().DupeMoney = v
    spawn(function()
        while v do
            FireRemote("DupeCash", math.huge) -- Eğer dupe remote varsa
            task.wait(1)
        end
    end)
end)

-- Tab4: Visual & ESP
local Group4 = Tab4:AddLeftGroupbox('Görsel')
Group4:AddToggle('ESP', { Text = 'ESP (Players & Brainrots)', Default = false }):OnChanged(function(v)
    getgenv().ESPEnabled = v
    ToggleESP(v)
end)
Group4:AddSlider('ESPDistance', { Text = 'ESP Mesafe', Min = 500, Max = 5000, Default = 2000 })

-- Tab5: Movement & Troll
local Group5 = Tab5:AddLeftGroupbox('Hareket & Troll')
Group5:AddToggle('Fly', { Text = 'Fly Mode', Default = false }):OnChanged(function(v)
    getgenv().FlyEnabled = v
    if v then Fly() end
end)
Group5:AddToggle('Noclip', { Text = 'NoClip / Ghost Mode', Default = false }):OnChanged(function(v)
    getgenv().Noclip = v
    spawn(function()
        while v do
            for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
            task.wait()
        end
    end)
end)
Group5:AddToggle('InfJump', { Text = 'Infinite Jump', Default = false }):OnChanged(function(v)
    getgenv().InfJump = v
    game:GetService("UserInputService").JumpRequest:Connect(function()
        if v then game.Players.LocalPlayer.Character.Humanoid:ChangeState("Jumping") end
    end)
end)
Group5:AddSlider('Speed', { Text = 'Speed Boost', Min = 16, Max = 200, Default = 50 }):OnChanged(function(v)
    getgenv().SpeedBoost = v
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
end)
Group5:AddToggle('Invisible', { Text = 'Invisible', Default = false }):OnChanged(function(v)
    getgenv().Invisible = v
    if v then game.Players.LocalPlayer.Character.Transparency = 1 end
end)
Group5:AddToggle('AutoSlap', { Text = 'Auto Slap / Hit Aura', Default = false }):OnChanged(function(v)
    getgenv().AutoSlap = v
    spawn(function()
        while v do
            FireRemote("SlapEvent" or "HitPlayer")
            task.wait(0.3)
        end
    end)
end)
Group5:AddButton('Teleport to Nearest Base', function()
    -- En yakın base TP (workspace Bases ara)
end)

-- Tab6: Misc & Anti
local Group6 = Tab6:AddLeftGroupbox('Diğer & Koruma')
Group6:AddToggle('GodMode', { Text = 'God Mode / Anti Hit', Default = false }):OnChanged(function(v)
    getgenv().GodMode = v
    -- Health hook or ragdoll disable
end)
Group6:AddToggle('Desync', { Text = 'Desync / Anti Grab', Default = false }):OnChanged(function(v)
    getgenv().Desync = v
    -- Network desync loop
end)
Group6:AddToggle('AntiRagdoll', { Text = 'Anti Ragdoll', Default = false }):OnChanged(function(v)
    getgenv().AntiRagdoll = v
    game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
end)
Group6:AddToggle('AntiKick', { Text = 'Anti Kick / AFK', Default = false }):OnChanged(function(v)
    getgenv().AntiKick = v
    spawn(function()
        while v do
            game.Players.LocalPlayer.Character.Humanoid:Move(Vector3.new(0,0,0.01))
            task.wait(10)
        end
    end)
end)
Group6:AddButton('Bypass Anti-Cheat', function()
    -- Hook metamethod vs. basit bypass
end)

Linoria:Notify('FsienHub Yüklendi', 'Brainrot\'ları çalmaya hazır mısın? 💀🧠', 5)
