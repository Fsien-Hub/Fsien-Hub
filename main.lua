-- FsienHub | Steal a Brainrot Ultimate 2026 (Keyless, Venice UI)
-- Mobil uyumlu, siyah ekran fix'li, auto steal/farm/fly/ESP + daha fazla
-- Pastebin/Bo3.gg esinlenmeli, undetected (Delta Mobile, Arceus X)

local Venice = loadstring(game:HttpGet("https://raw.githubusercontent.com/Babyhamsta/Venice/main/Main.lua"))()

local Window = Venice:NewWindow("FsienHub - Steal a Brainrot 🧠💀")

-- Globals & Services
getgenv().AutoSteal = false
getgenv().AutoFarmCash = false
getgenv().FlyEnabled = false
getgenv().Noclip = false
getgenv().InfJump = false
getgenv().ESPEnabled = false
getgenv().GodMode = false
getgenv().SpeedValue = 50
getgenv().Invisible = false
getgenv().AntiKick = true

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer

-- Helper: Fire Proximity
local function FirePrompts(filter, dist)
    dist = dist or 50
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") and obj.Name:lower():find(filter) then
            local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
            if root and (obj.Parent.Position - root.Position).Magnitude < dist then
                fireproximityprompt(obj)
            end
        end
    end
end

-- Loops
spawn(function()
    while true do
        if AutoSteal then FirePrompts("steal") FirePrompts("collect") FirePrompts("brainrot") end
        if AutoFarmCash then FirePrompts("cash") FirePrompts("money") FirePrompts("collect") end
        task.wait(0.2)
    end
end)

spawn(function()
    while true do
        if Noclip and Player.Character then
            for _, part in pairs(Player.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
        task.wait()
    end
end)

-- Fly
local FlyConn
local function ToggleFly(on)
    local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    if on then
        local bv = Instance.new("BodyVelocity", root)
        bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bv.Velocity = Vector3.new(0,0,0)
        FlyConn = RunService.Heartbeat:Connect(function()
            local vel = Vector3.new(0,0,0)
            local cam = Workspace.CurrentCamera
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then vel = vel + cam.CFrame.LookVector * 50 end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then vel = vel - cam.CFrame.LookVector * 50 end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then vel = vel - cam.CFrame.RightVector * 50 end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then vel = vel + cam.CFrame.RightVector * 50 end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then vel = vel + Vector3.new(0,50,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then vel = vel - Vector3.new(0,50,0) end
            bv.Velocity = vel
        end)
    else
        if FlyConn then FlyConn:Disconnect() end
        if root:FindFirstChild("BodyVelocity") then root:FindFirstChild("BodyVelocity"):Destroy() end
    end
end

-- Inf Jump
UserInputService.JumpRequest:Connect(function()
    if InfJump and Player.Character then Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

-- ESP
local ESPs = {}
local function ToggleESP(on)
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player and plr.Character then
            if on then
                local hl = Instance.new("Highlight", plr.Character)
                hl.FillColor = Color3.fromRGB(255,0,170)
                ESPs[plr] = hl
            else
                if ESPs[plr] then ESPs[plr]:Destroy() end
            end
        end
    end
end
Players.PlayerAdded:Connect(function(plr) plr.CharacterAdded:Connect(function() if ESPEnabled then ToggleESP(true) end end) end)

-- God & AntiKick
spawn(function()
    while true do
        if GodMode and Player.Character then Player.Character.Humanoid.Health = 100 end
        if AntiKick and Player.Character then Player.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,0.01) end
        task.wait(AntiKick and 10 or 0.1)
    end
end)

-- UI Tabs
local StealTab = Window:NewTab("Steal & Farm")
local StealSec = StealTab:NewSection("Otomatik Özellikler")
StealSec:NewToggle("Auto Steal", function(v) AutoSteal = v end)
StealSec:NewToggle("Auto Farm Cash", function(v) AutoFarmCash = v end)
StealSec:NewButton("Instant Steal", function() FirePrompts("steal", 100) end)

local MoveTab = Window:NewTab("Hareket")
local MoveSec = MoveTab:NewSection("Hız & Uçma")
MoveSec:NewToggle("Fly", function(v) FlyEnabled = v ToggleFly(v) end)
MoveSec:NewToggle("Noclip", function(v) Noclip = v end)
MoveSec:NewToggle("Inf Jump", function(v) InfJump = v end)
MoveSec:NewSlider("Speed", 16, 300, function(v) SpeedValue = v if Player.Character then Player.Character.Humanoid.WalkSpeed = v end end)

local VisualTab = Window:NewTab("Görsel")
local VisualSec = VisualTab:NewSection("ESP")
VisualSec:NewToggle("Player ESP", function(v) ESPEnabled = v ToggleESP(v) end)

local TrollTab = Window:NewTab("Troll")
local TrollSec = TrollTab:NewSection("Koruma")
TrollSec:NewToggle("God Mode", function(v) GodMode = v end)
TrollSec:NewToggle("Anti Kick", function(v) AntiKick = v end)
TrollSec:NewToggle("Invisible", function(v)
    Invisible = v
    if Player.Character then
        for _, p in pairs(Player.Character:GetChildren()) do
            if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then p.Transparency = v and 1 or 0 end
        end
    end
end)

-- Notify
Venice:Notify("FsienHub Yüklendi", "UI aktif, steal başla kral! 🧠🔥")
