-- FsienHub | Steal a Brainrot Ultimate 2026 (Keyless, Orca UI)
-- Mobil fix'li, auto steal/farm/fly/ESP + anti-kick
-- Delta Mobile/Arceus X uyumlu, no siyah ekran

local Orca = loadstring(game:HttpGet("https://raw.githubusercontent.com/toasty-dev/orca/master/source.lua", true))()

local Window = Orca:CreateWindow({
    Title = "FsienHub - Steal a Brainrot 🧠💀",
    Size = UDim2.new(0, 500, 0, 300)
})

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

-- Auto Loops
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

-- Fly (Mobil Uyumlu - Input Loop)
local FlyConn, FlyBV
local function ToggleFly(on)
    local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    if on then
        FlyBV = Instance.new("BodyVelocity", root)
        FlyBV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        FlyBV.Velocity = Vector3.new(0,0,0)
        FlyConn = RunService.Heartbeat:Connect(function()
            local vel = Vector3.new(0,0,0)
            local cam = Workspace.CurrentCamera
            -- Mobil/PC için genel input (key + touch fallback)
            local forward = UserInputService:IsKeyDown(Enum.KeyCode.W) or (UserInputService.TouchEnabled and UserInputService:IsKeyDown(Enum.KeyCode.Up))
            local back = UserInputService:IsKeyDown(Enum.KeyCode.S) or (UserInputService.TouchEnabled and UserInputService:IsKeyDown(Enum.KeyCode.Down))
            local left = UserInputService:IsKeyDown(Enum.KeyCode.A) or (UserInputService.TouchEnabled and UserInputService:IsKeyDown(Enum.KeyCode.Left))
            local right = UserInputService:IsKeyDown(Enum.KeyCode.D) or (UserInputService.TouchEnabled and UserInputService:IsKeyDown(Enum.KeyCode.Right))
            local up = UserInputService:IsKeyDown(Enum.KeyCode.Space)
            local down = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)
            if forward then vel = vel + cam.CFrame.LookVector * 50 end
            if back then vel = vel - cam.CFrame.LookVector * 50 end
            if left then vel = vel - cam.CFrame.RightVector * 50 end
            if right then vel = vel + cam.CFrame.RightVector * 50 end
            if up then vel = vel + Vector3.new(0,50,0) end
            if down then vel = vel - Vector3.new(0,50,0) end
            FlyBV.Velocity = vel
        end)
    else
        if FlyConn then FlyConn:Disconnect() end
        if FlyBV then FlyBV:Destroy() end
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
Players.PlayerAdded:Connect(function(plr) plr.CharacterAdded:Connect(function() if ESPEnabled then ToggleESP(true) end end))

-- God & AntiKick
spawn(function()
    while true do
        if GodMode and Player.Character then Player.Character.Humanoid.Health = 100 end
        if AntiKick and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,0.01)
        end
        task.wait(AntiKick and 10 or 0.1)
    end
end)

-- UI Tabs
local StealTab = Window:CreateTab("Steal & Farm")
StealTab:CreateToggle({
    Name = "Auto Steal",
    Callback = function(v) AutoSteal = v end
})
StealTab:CreateToggle({
    Name = "Auto Farm Cash",
    Callback = function(v) AutoFarmCash = v end
})
StealTab:CreateButton({
    Name = "Instant Steal All",
    Callback = function() FirePrompts("steal", 100) end
})

local MoveTab = Window:CreateTab("Hareket")
MoveTab:CreateToggle({
    Name = "Fly (Mobil Uyumlu)",
    Callback = function(v) FlyEnabled = v ToggleFly(v) end
})
MoveTab:CreateToggle({
    Name = "Noclip",
    Callback = function(v) Noclip = v end
})
MoveTab:CreateToggle({
    Name = "Inf Jump",
    Callback = function(v) InfJump = v end
})
MoveTab:CreateSlider({
    Name = "Speed",
    Min = 16,
    Max = 300,
    Callback = function(v) SpeedValue = v if Player.Character then Player.Character.Humanoid.WalkSpeed = v end end
})

local VisualTab = Window:CreateTab("Görsel")
VisualTab:CreateToggle({
    Name = "Player ESP",
    Callback = function(v) ESPEnabled = v ToggleESP(v) end
})

local TrollTab = Window:CreateTab("Troll")
TrollTab:CreateToggle({
    Name = "God Mode",
    Callback = function(v) GodMode = v end
})
TrollTab:CreateToggle({
    Name = "Anti Kick",
    Callback = function(v) AntiKick = v end
})
TrollTab:CreateToggle({
    Name = "Invisible",
    Callback = function(v)
        Invisible = v
        if Player.Character then
            for _, p in pairs(Player.Character:GetChildren()) do
                if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then p.Transparency = v and 1 or 0 end
            end
        end
    end
})

-- Notify
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "FsienHub Yüklendi!",
    Text = "UI aktif, brainrot çalmaya başla Yildirim! 🧠🔥",
    Duration = 5
})
