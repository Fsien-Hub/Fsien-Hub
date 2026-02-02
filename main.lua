-- Fsien Hub | Pure Soccer Özel - Geliştirilmiş Versiyon (2026)
-- Reach, TP Ball, Magnet, Stamina, Shoot + Ekstra: Reach Box, Ball ESP, Infinite Jump, Speed Slider

local PlaceId = game.PlaceId
if PlaceId ~= 88920112778598 then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Fsien Hub Hata",
        Text = "Bu script sadece Pure Soccer için! (PlaceId: 88920112778598)",
        Duration = 6
    })
    return
end

print("Fsien Hub - Pure Soccer Yükleniyor... (Geliştirilmiş Versiyon)")

-- UI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Fsien Hub | Pure Soccer ⚽", "DarkTheme")  -- Tema: Ocean, Sentinel, Midnight vs. dene

local Tab_Main = Window:NewTab("Ana Özellikler")
local Sec_Main = Tab_Main:NewSection("Temel Hileler - Ban Riski Düşük Tut")

-- Değişkenler
local ReachEnabled = false
local ReachSize = 12       -- Başlangıç güvenli (10-18 arası öneri)
local OriginalSizes = {}   -- Reset için orijinal boyutları sakla
local BallMagnet = false
local InfiniteStamina = false
local InfiniteJump = false
local WalkSpeed = 16       -- Varsayılan Roblox
local ReachBoxEnabled = false
local BallESPEnabled = false

-- Yardımcı Fonksiyon: Ball'ı daha iyi bul (genelde "Ball" adında, büyük Part)
local function GetBall()
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("BasePart") and obj.Name == "Ball" and obj.Size.Magnitude > 8 then  -- Boyut filtre
            return obj
        end
    end
    return nil  -- Bulamazsa nil
end

-- Reach Toggle
Sec_Main:NewToggle("Reach Aktif", "Topa ekstra ulaş (düşük tut ban riski azalır)", function(state)
    ReachEnabled = state
    local player = game.Players.LocalPlayer
    local char = player.Character
    if not char then return end

    if state then
        -- Orijinal boyutları kaydet (ilk seferde)
        if next(OriginalSizes) == nil then
            for _, part in ipairs(char:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    OriginalSizes[part.Name] = part.Size
                end
            end
        end

        spawn(function()
            while ReachEnabled and char.Parent do
                task.wait(0.15)  -- Lag önleme
                pcall(function()
                    for _, part in ipairs(char:GetChildren()) do
                        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                            part.Size = Vector3.new(ReachSize, ReachSize, ReachSize)
                            part.Transparency = 0.88  -- Neredeyse görünmez
                            part.CanCollide = false
                        end
                    end
                end)
            end
        end)
    else
        -- Reset
        pcall(function()
            for _, part in ipairs(char:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" and OriginalSizes[part.Name] then
                    part.Size = OriginalSizes[part.Name]
                    part.Transparency = 0
                    part.CanCollide = true
                end
            end
        end)
    end
end)

Sec_Main:NewSlider("Reach Boyutu", "8-25 arası (20+ ban riski ↑)", 180, 8, function(value)
    ReachSize = value / 10
end)

-- Reach Box (görsel kutu - ban riski biraz artırır)
Sec_Main:NewToggle("Reach Box Göster (Kırmızı)", "Reach alanını gör", function(state)
    ReachBoxEnabled = state
    local player = game.Players.LocalPlayer
    spawn(function()
        while ReachBoxEnabled do
            task.wait(0.2)
            pcall(function()
                local char = player.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local root = char.HumanoidRootPart
                    local box = root:FindFirstChild("ReachBox")
                    if not box then
                        box = Instance.new("BoxHandleAdornment")
                        box.Name = "ReachBox"
                        box.Adornee = root
                        box.Size = Vector3.new(ReachSize*2, ReachSize*2, ReachSize*2)
                        box.Color3 = Color3.fromRGB(255, 0, 0)
                        box.Transparency = 0.6
                        box.AlwaysOnTop = true
                        box.ZIndex = 10
                        box.Parent = root
                    end
                    box.Size = Vector3.new(ReachSize*2, ReachSize*2, ReachSize*2)
                end
            end)
        end
        -- Kapatınca sil
        pcall(function()
            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local box = root:FindFirstChild("ReachBox")
                if box then box:Destroy() end
            end
        end)
    end)
end)

-- Ball Magnet
Sec_Main:NewToggle("Ball Magnet", "Top sana doğru gelsin", function(state)
    BallMagnet = state
    if state then
        spawn(function()
            while BallMagnet do
                task.wait(0.08)
                pcall(function()
                    local ball = GetBall()
                    local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if ball and hrp then
                        local dir = (hrp.Position - ball.Position).Unit
                        ball.Velocity = dir * 30  -- 30 hız güvenli, 50+ kick riski
                    end
                end)
            end
        end)
    end
end)

-- Topa TP
Sec_Main:NewButton("Topa Işınlan", "Anında topa git", function()
    pcall(function()
        local ball = GetBall()
        local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if ball and hrp then
            hrp.CFrame = ball.CFrame + Vector3.new(0, 5, 0)  -- Üstüne çık
        end
    end)
end)

-- Infinite Stamina + Speed Slider
Sec_Main:NewToggle("Infinite Stamina + Hız", "Enerji bitmez + hız", function(state)
    InfiniteStamina = state
    local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
    if hum then
        if state then
            hum.WalkSpeed = WalkSpeed
        else
            hum.WalkSpeed = 16
        end
    end
end)

Sec_Main:NewSlider("Yürüme Hızı", "16-40 arası", 240, 16, function(value)
    WalkSpeed = value
    local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
    if hum and InfiniteStamina then
        hum.WalkSpeed = value
    end
end)

-- Infinite Jump
Sec_Main:NewToggle("Infinite Jump", "Sonsuz zıpla (Space)", function(state)
    InfiniteJump = state
    if state then
        local conn
        conn = game:GetService("UserInputService").JumpRequest:Connect(function()
            if InfiniteJump then
                local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
                if hum then hum:ChangeState("Jumping") end
            end
        end)
        -- Bağlantıyı kapatmak için (toggle off)
        spawn(function()
            while InfiniteJump do task.wait(1) end
            conn:Disconnect()
        end)
    end
end)

-- Ball ESP (highlight)
Sec_Main:NewToggle("Ball ESP", "Topu duvar arkasından gör", function(state)
    BallESPEnabled = state
    spawn(function()
        while BallESPEnabled do
            task.wait(0.5)
            pcall(function()
                local ball = GetBall()
                if ball then
                    local hl = ball:FindFirstChild("BallESP")
                    if not hl then
                        hl = Instance.new("Highlight")
                        hl.Name = "BallESP"
                        hl.FillColor = Color3.fromRGB(255, 215, 0)
                        hl.OutlineColor = Color3.fromRGB(255, 0, 0)
                        hl.FillTransparency = 0.4
                        hl.OutlineTransparency = 0
                        hl.Parent = ball
                    end
                end
            end)
        end
        -- Kapat
        pcall(function()
            local ball = GetBall()
            if ball then
                local hl = ball:FindFirstChild("BallESP")
                if hl then hl:Destroy() end
            end
        end)
    end)
end)

-- Basit Auto Shoot (önüne vur)
Sec_Main:NewButton("Hızlı Vuruş (Shoot)", "Önüne doğru vur", function()
    pcall(function()
        local ball = GetBall()
        local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if ball and hrp then
            ball.Velocity = hrp.CFrame.LookVector * 60 + Vector3.new(0, 25, 0)  -- İleri + yukarı
        end
    end)
end)

-- Bilgi Label
Tab_Main:NewSection("Notlar & Uyarılar")
Tab_Main:NewLabel("Ban Riski: Reach >20, Velocity >70, spam yapma")
Tab_Main:NewLabel("Private server'da test et")
Tab_Main:NewLabel("Executor: Delta/Fluxus önerilir")
Tab_Main:NewLabel("Güncel: Şubat 2026 - Anti-cheat orta seviye")

print("Fsien Hub yüklendi! Özellikleri dene, keyifli oyunlar ⚽")
