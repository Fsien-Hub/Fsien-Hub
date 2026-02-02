-- FsienHub | Steal a Brainrot ULTIMATE 2026 (Keyless, Kavo UI)
-- Tüm çalışan script'lerden esinlenildi: Chilli Hub, FrostWare, MODDED, Moon Hub vs.
-- Bo3.gg & Pastebin 2026 güncel | ProximityPrompt auto steal + farm + fly + ESP + daha fazla
-- Undetected, mobile/PC uyumlu (Delta, Arceus X, Xeno)

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("FsienHub - Steal a Brainrot 🧠💀", "DarkTheme")

-- Globals
getgenv().AutoSteal = false
getgenv().AutoFarmCash = false
getgenv().AutoLock = false
getgenv().FlyEnabled = false
getgenv().Noclip = false
getgenv().InfJump = false
getgenv().ESPEnabled = false
getgenv().GodMode = false
getgenv().SpeedValue = 50
getgenv().Invisible = false
getgenv().AntiKick = true

-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer

-- Helper: Fire ProximityPrompts
local function FirePrompts(nameFilter, maxDist)
    maxDist = maxDist or 50
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") and obj.Name:lower():find(nameFilter) then
            local char = Player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local dist = (obj.Parent.Position - char.HumanoidRootPart.Position).Magnitude
                if dist < maxDist then
                    fireproximityprompt(obj)
                end
            end
        end
    end
end

-- Auto Steal Loop
spawn(function()
    while true do
        if getgenv().AutoSteal then
            FirePrompts("steal")
            FirePrompts("collect")
            FirePrompts("brainrot")
        end
        if getgenv().AutoFarmCash then
            FirePrompts("cash")
            FirePrompts("money")
            FirePrompts("collect")
        end
        task.wait(0.2)  -- Anti-kick delay
    end
end)

-- Fly Function (BodyVelocity)
local FlyConnection
local function ToggleFly(enabled)
    local char = Player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    
    if enabled then
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(4000, 4000, 4000)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = root
        
        FlyConnection = RunService.Heartbeat:Connect(function()
            local cam = Workspace.CurrentCamera
            local vel = cam.CFrame.LookVector * (UserInputService:IsKeyDown(Enum.KeyCode.W) and 50 or 0)
            vel = vel + cam.CFrame.RightVector * (UserInputService:IsKeyDown(Enum.KeyCode.D) and 50 or (UserInputService:IsKeyDown(Enum.KeyCode.A) and -50 or 0))
            vel = vel + Vector3.new(0, (UserInputService:IsKeyDown(Enum.KeyCode.Space) and 50 or (UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and -50 or 0)), 0)
            bv.Velocity = vel
        end)
    else
        if FlyConnection then FlyConnection:Disconnect() end
        if root:FindFirstChild("BodyVelocity") then root.BodyVelocity:Destroy() end
    end
end

-- Noclip Loop
spawn(function()
    while true do
        if getgenv().Noclip and Player.Character then
            for _, part in pairs(Player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
        task.wait()
    end
end)

-- Inf Jump
UserInputService.JumpRequest:Connect(function()
    if getgenv().InfJump then
        Player.Character.Humanoid:ChangeState("Jumping")
    end
end)

-- ESP (Highlight)
local ESPHighlights = {}
local function ToggleESP(enabled)
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player and plr.Character then
            local highlight = ESPHighlights[plr]
            if enabled then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.FillColor = Color3.fromRGB(255, 0, 170)  -- Brainrot pink
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.Parent = plr.Character
                    ESPHighlights[plr] = highlight
                end
            else
                if highlight then highlight:Destroy() end
                ESPHighlights[plr] = nil
            end
        end
    end
end
Players.PlayerRemoving:Connect(function(plr) if ESPHighlights[plr] then ESPHighlights[plr]:Destroy() end end)
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        if getgenv().ESPEnabled then ToggleESP(true) end
    end)
end)

-- God Mode / Anti Ragdoll
spawn(function()
    while true do
        if getgenv().GodMode and Player.Character then
            Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
        end
        task.wait(0.1)
    end
end)

-- Anti Kick (AFK)
spawn(function()
    while getgenv().AntiKick do
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame + Vector3.new(0,0,0.01)
        end
        task.wait(10)
    end
end)

-- Tabs
local MainTab = Window:NewTab("Ana Özellikler")
local StealTab = Window:NewTab("Steal & Farm")
local VisualTab = Window:NewTab("Görsel")
local MovementTab = Window:NewTab("Hareket")
local TrollTab = Window:NewTab("Troll & Diğer")

-- Main Tab
local MainSection = MainTab:NewSection("FsienHub 2026 - Brainrot Kralı")
MainSection:NewLabel("1M+ Cash / Instant Steal Hazır 🧠💀")
MainSection:NewButton("Rejoin Server", "Sunucuya yeniden katıl", function() game:GetService("TeleportService"):Teleport(game.PlaceId) end)

-- Steal & Farm Tab
local StealSection = StealTab:NewSection("Auto Steal & Farm")
StealSection:NewToggle("AutoSteal", "Otomatik Brainrot Çal", function(state) getgenv().AutoSteal = state end)
StealSection:NewToggle("AutoFarmCash", "Otomatik Para Topla", function(state) getgenv().AutoFarmCash = state end)
StealSection:NewToggle("AutoLock", "Auto Base Lock", function(state)
    getgenv().AutoLock = state
    if state then FirePrompts("lock") end
end)
StealSection:NewButton("Instant Steal All", "Hemen tüm steal'leri yap", function() FirePrompts("steal", 100) end)

-- Visual Tab
local VisualSection = VisualTab:NewSection("ESP")
VisualSection:NewToggle("PlayerESP", "Oyuncu & Brainrot ESP", function(state)
    getgenv().ESPEnabled = state
    ToggleESP(state)
end)

-- Movement Tab
local MoveSection = MovementTab:NewSection("Hareket Hızlandırıcı")
MoveSection:NewToggle("Fly", "Uçma", function(state)
    getgenv().FlyEnabled = state
    ToggleFly(state)
end)
MoveSection:NewToggle("Noclip", "Duvar Geçme", function(state) getgenv().Noclip = state end)
MoveSection:NewToggle("InfJump", "Sonsuz Zıplama", function(state) getgenv().InfJump = state end)
MoveSection:NewSlider("Speed", "Hız", 500, 16, function(s) getgenv().SpeedValue = s Player.Character.Humanoid.WalkSpeed = s end)
MoveSection:NewToggle("Invisible", "Görünmez", function(state)
    getgenv().Invisible = state
    if Player.Character then
        for _, part in pairs(Player.Character:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then part.Transparency = state and 1 or 0 end
        end
    end
end)

-- Troll Tab
local TrollSection = TrollTab:NewSection("Troll & Koruma")
TrollSection:NewToggle("GodMode", "Ölümsüz Mod", function(state) getgenv().GodMode = state end)
TrollSection:NewToggle("AntiKick", "Kick Koruması", function(state) getgenv().AntiKick = state end)

-- Load & Notify
Library:ToggleUI()
game:GetService("StarterGui"):SetCore("SendNotification", {Title="FsienHub Yüklendi!"; Text="Auto Steal & Farm Aktif 🧠🔥"; Duration=5})

print("FsienHub - Steal a Brainrot Çalışıyor | GitHub: FsienHub")
