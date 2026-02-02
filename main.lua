-- Fsien Hub | Pure Soccer - Yeniden Açılabilir UI + Stabil Fix (2026)
-- Hotkey: RightShift ile aç/kapa | UI kapatınca destroy olur

local PlaceId = game.PlaceId
if PlaceId ~= 88920112778598 then
    warn("[Fsien Hub] Yanlış oyun! Sadece Pure Soccer.")
    return
end

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer

local Library = nil
local Window = nil
local GuiOpen = false

-- UI'yi yükle/yok et fonksiyonu
local function LoadUI()
    if GuiOpen then return end  -- Zaten açıksa tekrarlama
    
    Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
    Window = Library.CreateLib("Fsien Hub | Pure Soccer ⚽", "DarkTheme")  -- Tema değiştir: Ocean, Midnight, Sentinel vs.
    
    local Tab = Window:NewTab("Ana Özellikler")
    local Sec = Tab:NewSection("Reach & Ball Kontrolü (Maçta Dene)")
    
    -- Debug Label
    Tab:NewLabel("Durum: Maç başlasın diye bekleniyor...")
    Tab:NewLabel("Ban Riski: Reach >18 & Velocity >40 ↑")
    
    -- Değişkenler
    local ReachEnabled = false
    local ReachSize = 12
    local OriginalSizes = {}
    local BallMagnet = false
    
    -- Ball Bulma (daha akıllı)
    local function GetBall()
        for _, obj in ipairs(workspace:GetDescendants()) do
            local nameLower = obj.Name:lower()
            if obj:IsA("BasePart") and (nameLower:find("ball") or nameLower:find("soccer") or nameLower:find("football")) then
                if obj.Size.Magnitude > 5 and obj:IsDescendantOf(workspace) then
                    print("[DEBUG] Ball tespit edildi: " .. obj:GetFullName())
                    return obj
                end
            end
        end
        print("[DEBUG] Ball yok - Maç başlamadı mı?")
        return nil
    end
    
    -- Reach Toggle
    Sec:NewToggle("Reach Aktif", "Düşük tut (12-16 öneri)", function(state)
        ReachEnabled = state
        local char = LocalPlayer.Character
        if not char then return end
        
        if state then
            OriginalSizes = {}
            for _, part in ipairs(char:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    OriginalSizes[part] = part.Size
                end
            end
            
            spawn(function()
                while ReachEnabled and char.Parent do
                    task.wait(0.2)
                    pcall(function()
                        for part, _ in pairs(OriginalSizes) do
                            if part.Parent then
                                part.Size = Vector3.new(ReachSize, ReachSize, ReachSize)
                                part.Transparency = 0.92
                                part.CanCollide = false
                            end
                        end
                    end)
                end
            end)
        else
            pcall(function()
                for part, orig in pairs(OriginalSizes) do
                    if part.Parent then
                        part.Size = orig
                        part.Transparency = 0
                        part.CanCollide = true
                    end
                end
            end)
        end
    end)
    
    Sec:NewSlider("Reach Boyutu", "8-20", 130, 8, function(value)
        ReachSize = value / 10
    end)
    
    -- Ball Magnet
    Sec:NewToggle("Ball Magnet", "Top yavaşça sana gelsin", function(state)
        BallMagnet = state
        if state then
            spawn(function()
                while BallMagnet do
                    task.wait(0.12)
                    pcall(function()
                        local ball = GetBall()
                        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if ball and hrp then
                            local dir = (hrp.Position - ball.Position).Unit
                            ball.Velocity = dir * 25  -- Düşük hız = düşük ban riski
                        end
                    end)
                end
            end)
        end
    end)
    
    -- Tp to Ball
    Sec:NewButton("Topa Işınlan", "", function()
        pcall(function()
            local ball = GetBall()
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if ball and hrp then
                hrp.CFrame = ball.CFrame + Vector3.new(0, 5, 0)
            end
        end)
    end)
    
    -- Infinite Stamina (basit hız)
    Sec:NewToggle("Infinite Stamina", "Koşu bitmesin", function(state)
        spawn(function()
            while state do
                task.wait(0.3)
                pcall(function()
                    local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
                    if hum then hum.WalkSpeed = 22 end
                end)
            end
        end)
    end)
    
    GuiOpen = true
    StarterGui:SetCore("SendNotification", {Title = "Fsien Hub", Text = "UI Açıldı! RightShift ile kapat/aç", Duration = 5})
end

local function UnloadUI()
    if not GuiOpen then return end
    if Window then
        pcall(function()
            Window:Destroy()  -- Kavo'da destroy çağrısı
        end)
    end
    Library = nil
    Window = nil
    GuiOpen = false
    StarterGui:SetCore("SendNotification", {Title = "Fsien Hub", Text = "UI Kapatıldı", Duration = 3})
end

-- Hotkey: RightShift ile toggle
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        if GuiOpen then
            UnloadUI()
        else
            LoadUI()
        end
    end
end)

-- İlk yükleme (otomatik aç)
LoadUI()

-- Karakter yenilenince reach reset (otomatik)
LocalPlayer.CharacterAdded:Connect(function(char)
    wait(1)  -- Karakter tam yüklenene kadar bekle
    if ReachEnabled then
        -- Reach'i yeniden uygula
        for _, part in ipairs(char:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Size = Vector3.new(ReachSize, ReachSize, ReachSize)
                part.Transparency = 0.92
                part.CanCollide = false
            end
        end
    end
end)

print("[Fsien Hub] Yüklendi! RightShift ile UI aç/kapa. Maçta dene.")
