-- FsienHub | Steal a Brainrot Stealth Edition 2026
-- Rayfield yok, Fluent + custom stealth
-- Brainrot modu, auto steal, farm, ESP, troll hepsi bir arada

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "FsienHub - Steal a Brainrot 🧠💀",
    SubTitle = "Yildirim's Brainrot Stealer | 2026 Stealth Mode",
    TabWidth = 160,
    Size = UDim2.fromOffset(620, 480),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Ana", Icon = "brain-cog" }),
    Steal = Window:AddTab({ Title = "Steal", Icon = "hand-platter" }),
    Farm = Window:AddTab({ Title = "Farm", Icon = "dollar-sign" }),
    Visual = Window:AddTab({ Title = "Görsel", Icon = "eye" }),
    Combat = Window:AddTab({ Title = "Troll/Savaş", Icon = "swords" }),
    Misc = Window:AddTab({ Title = "Diğer", Icon = "component" }),
    Settings = Window:AddTab({ Title = "Ayarlar", Icon = "settings" })
}

local Options = Fluent.Options

-- Global toggles for loops
_G.AutoSteal = false
_G.AutoFarmMoney = false
_G.AutoRebirth = false
_G.AutoLockBase = false
_G.BrainrotMode = false

-- ========================
-- ANA TAB - Brainrot Modu & Hoşgeldin
-- ========================
do
    Tabs.Main:AddParagraph({
        Title = "FsienHub Hoşgeldin Kral",
        Content = "Steal a Brainrot'un ruhunu çalıyoruz. Düşman beyinleri erisin 💨🧠\nAnti-detect: Fluent + delay'ler + no signature"
    })

    Tabs.Main:AddToggle("BrainrotMode", {
        Title = "Brainrot Modu (Chat + Efekt Saçmalığı)",
        Default = false,
        Callback = function(v)
            _G.BrainrotMode = v
            if v then
                Fluent:Notify({Title="FsienHub", Content="Brainrot modu aktif! Herkes skibidi rizz konuşuyo artık 💀", Duration=5})
                spawn(function()
                    while _G.BrainrotMode do
                        pcall(function()
                            game:GetService("ReplicatedStorage"):WaitForChild("ChatEvent",5):FireServer("trallero tralala stole ur mom " .. math.random(1,999) .. " rizzler 🧠💦")
                        end)
                        task.wait(math.random(8,15))
                    end
                end)
            end
        end
    })

    Tabs.Main:AddButton({
        Title = "Instant Brainrot Spam All",
        Description = "Sunucuya random brainrot mesajı spam at",
        Callback = function()
            for i=1,10 do
                pcall(function()
                    game:GetService("ReplicatedStorage"):FindFirstChild("ChatEvent",true):FireServer("skibidi toilet stole ur brainrot #"..i.." gyatt amk 🔥")
                end)
            end
            Fluent:Notify({Title="Spam!", Content="Brainrot dalgası gitti..."})
        end
    })
end

-- ========================
-- STEAL TAB - Auto Steal & Lock
-- ========================
do
    local StealSection = Tabs.Steal:AddSection("Steal Özellikleri")

    StealSection:AddToggle("AutoSteal", {
        Title = "Auto Steal Brainrot (Yakın Proximity)",
        Default = false,
        Callback = function(v)
            _G.AutoSteal = v
            spawn(function()
                while _G.AutoSteal do
                    pcall(function()
                        for _, obj in pairs(workspace:GetDescendants()) do
                            if obj:IsA("ProximityPrompt") and (obj.Name:lower():find("steal") or obj.Name:lower():find("brainrot") or obj.Name:find("Collect")) then
                                if (obj.Parent.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 15 then
                                    fireproximityprompt(obj)
                                    task.wait(0.1)
                                end
                            end
                        end
                    end)
                    task.wait(0.25) -- Anti-kick delay
                end
            end)
        end
    })

    StealSection:AddToggle("AutoLockBase", {
        Title = "Auto Lock Base (Açılınca kilitler)",
        Default = false,
        Callback = function(v)
            _G.AutoLockBase = v
            Fluent:Notify({Title="AutoLock", Content="Base açılınca otomatik kilitlenir (eğer remote varsa)"})
            -- Buraya base lock remote'u koy (ReplicatedStorage:FindFirstChild("LockBase"):FireServer(true))
        end
    })

    StealSection:AddButton({
        Title = "Instant Steal Nearest",
        Callback = function()
            -- En yakın prompt'u fire et
            local closest = nil
            local dist = math.huge
            for _, p in pairs(workspace:GetDescendants()) do
                if p:IsA("ProximityPrompt") and p.Name:lower():find("steal") then
                    local d = (p.Parent.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                    if d < dist then dist = d closest = p end
                end
            end
            if closest and dist < 50 then fireproximityprompt(closest) end
        end
    })
end

-- ========================
-- FARM TAB - Money & Rebirth
-- ========================
do
    local FarmSection = Tabs.Farm:AddSection("Auto Farm")

    FarmSection:AddToggle("AutoMoney", {
        Title = "Auto Generate Money",
        Default = false,
        Callback = function(v)
            _G.AutoFarmMoney = v
            spawn(function()
                while _G.AutoFarmMoney do
                    pcall(function()
                        -- Oyunda money remote'u (örnek: ReplicatedStorage.GenerateMoney:FireServer())
                        game:GetService("ReplicatedStorage"):FindFirstChild("GenerateMoney", true):FireServer()
                    end)
                    task.wait(0.4) -- Rate limit için
                end
            end)
        end
    })

    FarmSection:AddToggle("AutoRebirth", {
        Title = "Auto Rebirth (Cash + Req varsa)",
        Default = false,
        Callback = function(v)
            _G.AutoRebirth = v
            spawn(function()
                while _G.AutoRebirth do
                    pcall(function()
                        game:GetService("ReplicatedStorage"):FindFirstChild("Rebirth", true):FireServer()
                    end)
                    task.wait(3) -- Rebirth cooldown büyük olur
                end
            end)
        end
    })

    FarmSection:AddSlider("FarmDelay", {
        Title = "Farm Delay (saniye)",
        Min = 0.1, Max = 2, Default = 0.4, Rounding = 2
    })
end

-- ========================
-- GÖRSEL TAB - ESP & Rarity
-- ========================
do
    local ESPSection = Tabs.Visual:AddSection("ESP & Görsel")

    ESPSection:AddToggle("PlayerESP", {
        Title = "Player & Brainrot ESP",
        Default = false
    }):AddColorPicker("ESPColor", {Title = "Renk", Default = Color3.fromRGB(255, 0, 170)})

    -- Basit ESP loop (Drawing API ile yapabilirsin ama Fluent'te toggle yeterli, istersen ekleriz)
end

-- ========================
-- TROLL / COMBAT TAB
-- ========================
do
    local TrollSection = Tabs.Combat:AddSection("Troll & Savaş")

    TrollSection:AddButton({
        Title = "Mass Slap / Hit All",
        Callback = function()
            Fluent:Notify({Title="Troll", Content="Slap dalgası (remote bulup fire et)"})
            -- Örnek: game.ReplicatedStorage.SlapEvent:FireServer("all")
        end
    })

    TrollSection:AddToggle("Invisible", {Title = "Ghost Mode (Transparency)", Default = false})
end

-- ========================
-- AYARLAR & SAVE
-- ========================
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
InterfaceManager:SetFolder("FsienHub")
SaveManager:SetFolder("FsienHub/StealABrainrot")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Tabs.Settings:AddButton({
    Title = "Config Sıfırla",
    Callback = function() SaveManager:DeleteAutoloadConfig() end
})

Window:SelectTab(1)

Fluent:Notify({
    Title = "FsienHub Yüklendi",
    Content = "Brainrot'ları çalmaya hazır mısın kral? 🧠🔥 (2026 Stealth)",
    Duration = 8
})

SaveManager:LoadAutoloadConfig()
