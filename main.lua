-- FsienHub | Steal a Brainrot Ultimate 2026 (Keyless, DrRay UI)
-- Tüm çalışan script'lerden esinlenildi: auto steal, farm, fly, ESP + daha fazla
-- Undetected, mobile/PC uyumlu (Delta, Arceus X, Fluxus)

local DrRayLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/DrRay-UI-Library/main/DrRay.lua"))()

local window = DrRayLibrary:Load("FsienHub - Steal a Brainrot 🧠💀", "Default")  -- UI penceresi

-- Tabs
local mainTab = DrRayLibrary:AddTab("Ana")
local stealTab = DrRayLibrary:AddTab("Steal & Farm")
local visualTab = DrRayLibrary:AddTab("Görsel")
local movementTab = DrRayLibrary:AddTab("Hareket")
local trollTab = DrRayLibrary:AddTab("Troll & Koruma")

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

-- Auto Loops
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

-- Fly
local FlyConnection
local function ToggleFly(enabled)
    local char = Player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    
    if enabled then
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = root
        
        FlyConnection = RunService.Heartbeat:Connect(function()
            local cam = Workspace.CurrentCamera
            local vel = Vector3.new(0,0,0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then vel = vel + (cam.CFrame.LookVector * 50) end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then vel = vel - (cam.CFrame.LookVector * 50) end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then vel = vel - (cam.CFrame.RightVector * 50) end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then vel = vel + (cam.CFrame.RightVector * 50) end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then vel = vel + Vector3.new(0,50,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then vel = vel - Vector3.new(0,50,0) end
            bv.Velocity = vel
        end)
    else
        if FlyConnection then FlyConnection:Disconnect() end
        if root:FindFirstChild("BodyVelocity") then root:FindFirstChild("BodyVelocity"):Destroy() end
    end
end

-- Noclip
spawn(function()
    while true do
        if getgenv().Noclip and Player.Character then
            for _, part in pairs(Player.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = false
                end
            end
        end
        task.wait()
    end
end)

-- Inf Jump
UserInputService.JumpRequest:Connect(function()
    if getgenv().InfJump and Player.Character then
        Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
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
                    highlight.FillColor = Color3.fromRGB(255, 0, 170)
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
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        if getgenv().ESPEnabled then ToggleESP(true) end
    end)
end)
Players.PlayerRemoving:Connect(function(plr)
    if ESPHighlights[plr] then ESPHighlights[plr]:Destroy() end
end)

-- God Mode
spawn(function()
    while true do
        if getgenv().GodMode and Player.Character then
            Player.Character.Humanoid.Health = Player.Character.Humanoid.MaxHealth
        end
        task.wait(0.1)
    end
end)

-- Anti Kick
spawn(function()
    while getgenv().AntiKick do
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 0.01)
        end
        task.wait(10)
    end
end)

-- UI Sections
local mainSection = mainTab:AddSection("FsienHub 2026 - Brainrot Edition")
mainSection:AddLabel("Auto Steal & Farm Aktif 🧠🔥")
mainSection:AddButton("Rejoin Server", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId)
end)

local stealSection = stealTab:AddSection("Steal & Farm")
stealSection:AddToggle("Auto Steal", false, function(state) getgenv().AutoSteal = state end)
stealSection:AddToggle("Auto Farm Cash", false, function(state) getgenv().AutoFarmCash = state end)
stealSection:AddToggle("Auto Lock Base", false, function(state)
    getgenv().AutoLock = state
    if state then FirePrompts("lock") end
end)
stealSection:AddButton("Instant Steal All", function() FirePrompts("steal", 100) end)

local visualSection = visualTab:AddSection("ESP")
visualSection:AddToggle("Player & Brainrot ESP", false, function(state)
    getgenv().ESPEnabled = state
    ToggleESP(state)
end)

local movementSection = movementTab:AddSection("Hareket")
movementSection:AddToggle("Fly", false, function(state)
    getgenv().FlyEnabled = state
    ToggleFly(state)
end)
movementSection:AddToggle("Noclip", false, function(state) getgenv().Noclip = state end)
movementSection:AddToggle("Infinite Jump", false, function(state) getgenv().InfJump = state end)
movementSection:AddSlider("Speed", 16, 500, 50, function(value)
    getgenv().SpeedValue = value
    if Player.Character then Player.Character.Humanoid.WalkSpeed = value end
end)
movementSection:AddToggle("Invisible", false, function(state)
    getgenv().Invisible = state
    if Player.Character then
        for _, part in pairs(Player.Character:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Transparency = state and 1 or 0
            end
        end
    end
end)

local trollSection = trollTab:AddSection("Troll & Koruma")
trollSection:AddToggle("God Mode", false, function(state) getgenv().GodMode = state end)
trollSection:AddToggle("Anti Kick", true, function(state) getgenv().AntiKick = state end)

-- Notify
DrRayLibrary:Notify("FsienHub Yüklendi", "Script aktif, UI açıldı! 🧠💀", 5)
