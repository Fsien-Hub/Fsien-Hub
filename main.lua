-- FsienHub | ALL-IN-ONE Legit Training Hub (LocalScript)

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local Rayfield = require(ReplicatedStorage:WaitForChild("Rayfield"))

--------------------------------------------------
-- SPLASH: FsienHub Sunar (10 sn)
--------------------------------------------------
do
	local gui = Instance.new("ScreenGui")
	gui.Name = "FsienHubSplash"
	gui.ResetOnSpawn = false
	gui.Parent = player:WaitForChild("PlayerGui")

	local txt = Instance.new("TextLabel", gui)
	txt.Size = UDim2.fromScale(1,1)
	txt.BackgroundTransparency = 1
	txt.Text = "FsienHub\nSunar"
	txt.TextScaled = true
	txt.Font = Enum.Font.GothamBlack
	txt.TextColor3 = Color3.fromRGB(255,255,255)
	txt.TextStrokeColor3 = Color3.fromRGB(0,0,0)
	txt.TextTransparency = 1
	txt.TextStrokeTransparency = 1

	TweenService:Create(
		txt,
		TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{TextTransparency=0, TextStrokeTransparency=0.2}
	):Play()

	task.delay(10, function()
		local t = TweenService:Create(
			txt,
			TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
			{TextTransparency=1, TextStrokeTransparency=1}
		)
		t:Play()
		t.Completed:Wait()
		gui:Destroy()
	end)
end

--------------------------------------------------
-- WINDOW
--------------------------------------------------
local Window = Rayfield:CreateWindow({
	Name = "FsienHub",
	LoadingTitle = "FsienHub",
	LoadingSubtitle = "Training Panel",
	ConfigurationSaving = { Enabled = false }
})

--------------------------------------------------
-- TAB: FLY (Mobil uyumlu, local)
--------------------------------------------------
local FlyTab = Window:CreateTab("Fly", 4483362458)
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

local flying, flySpeed = false, 50
local bv = Instance.new("BodyVelocity")
bv.MaxForce = Vector3.new(1e5,1e5,1e5)
local bg = Instance.new("BodyGyro")
bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
bg.P = 1e4

FlyTab:CreateToggle({
	Name = "Fly",
	CurrentValue = false,
	Callback = function(v)
		flying = v
		if v then
			bv.Parent = root
			bg.Parent = root
			humanoid.PlatformStand = true
		else
			bv.Parent = nil
			bg.Parent = nil
			humanoid.PlatformStand = false
		end
	end
})

FlyTab:CreateSlider({
	Name = "Fly Speed",
	Range = {20,120},
	Increment = 5,
	CurrentValue = flySpeed,
	Callback = function(v) flySpeed = v end
})

RunService.RenderStepped:Connect(function()
	if flying then
		local cam = workspace.CurrentCamera
		bg.CFrame = cam.CFrame
		bv.Velocity = cam.CFrame.LookVector * flySpeed
	end
end)

--------------------------------------------------
-- TAB: AIM GUIDE (Görsel)
--------------------------------------------------
local AimTab = Window:CreateTab("Aim Guide", 4483362458)
local aimOn, fov = false, 80

local aimGui = Instance.new("ScreenGui", player.PlayerGui)
aimGui.Enabled = false
local circle = Instance.new("Frame", aimGui)
circle.AnchorPoint = Vector2.new(0.5,0.5)
circle.Position = UDim2.fromScale(0.5,0.5)
circle.Size = UDim2.fromOffset(fov*2, fov*2)
circle.BackgroundTransparency = 1
Instance.new("UICorner", circle).CornerRadius = UDim.new(1,0)
local stroke = Instance.new("UIStroke", circle)
stroke.Thickness = 2
stroke.Transparency = 0.2

AimTab:CreateToggle({
	Name = "Aim Guide (FOV)",
	CurrentValue = false,
	Callback = function(v)
		aimOn = v
		aimGui.Enabled = v
	end
})

AimTab:CreateSlider({
	Name = "FOV Size",
	Range = {40,200},
	Increment = 5,
	CurrentValue = fov,
	Callback = function(v)
		fov = v
		circle.Size = UDim2.fromOffset(v*2, v*2)
	end
})

--------------------------------------------------
-- TAB: CAMERA LOCK (NPC / Dummy)
--------------------------------------------------
local CamTab = Window:CreateTab("Camera Lock", 4483362458)
local lockOn, smooth = false, 0.15
local targetNpc

local function closestNPC()
	local cam = workspace.CurrentCamera
	local best, dist
	for _,m in ipairs(workspace:GetChildren()) do
		if m:IsA("Model") and m:FindFirstChild("HumanoidRootPart") and m:FindFirstChild("Humanoid") then
			if not Players:GetPlayerFromCharacter(m) then
				local p, ok = cam:WorldToViewportPoint(m.HumanoidRootPart.Position)
				if ok then
					local d = (Vector2.new(p.X,p.Y) - cam.ViewportSize/2).Magnitude
					if not dist or d < dist then dist, best = d, m end
				end
			end
		end
	end
	return best
end

CamTab:CreateToggle({
	Name = "NPC Camera Lock",
	CurrentValue = false,
	Callback = function(v)
		lockOn = v
		if not v then targetNpc = nil end
	end
})

CamTab:CreateSlider({
	Name = "Smoothness",
	Range = {0.05,0.5},
	Increment = 0.05,
	CurrentValue = smooth,
	Callback = function(v) smooth = v end
})

RunService.RenderStepped:Connect(function(dt)
	if lockOn then
		local cam = workspace.CurrentCamera
		if not targetNpc or not targetNpc.Parent then
			targetNpc = closestNPC()
		end
		if targetNpc and targetNpc:FindFirstChild("HumanoidRootPart") then
			local look = CFrame.new(cam.CFrame.Position, targetNpc.HumanoidRootPart.Position)
			cam.CFrame = cam.CFrame:Lerp(look, math.clamp(smooth*60*dt,0,1))
		end
	end
end)

--------------------------------------------------
-- TAB: OBJECTIVE ESP (Legit)
--------------------------------------------------
local EspTab = Window:CreateTab("Objective ESP", 4483362458)
local espOn = false
local marks = {}

local function refreshESP()
	for _,h in pairs(marks) do h:Destroy() end
	table.clear(marks)
	if not espOn then return end
	for _,o in ipairs(workspace:GetDescendants()) do
		if o:IsA("BasePart") and (o.Name:lower():find("flag") or o.Name:lower():find("ball") or o.Name:lower():find("objective")) then
			local hl = Instance.new("Highlight")
			hl.Adornee = o
			hl.FillTransparency = 0.7
			hl.OutlineTransparency = 0.1
			hl.Parent = o
			table.insert(marks, hl)
		end
	end
end

EspTab:CreateToggle({
	Name = "Objective ESP",
	CurrentValue = false,
	Callback = function(v) espOn = v; refreshESP() end
})

--------------------------------------------------
-- TAB: TRAINING TARGETS
--------------------------------------------------
local TrainTab = Window:CreateTab("Training", 4483362458)
local folder

local function spawnTargets(n)
	if folder then folder:Destroy() end
	folder = Instance.new("Folder", workspace)
	folder.Name = "FsienTargets"
	for i=1,n do
		local p = Instance.new("Part")
		p.Size = Vector3.new(2,2,2)
		p.Anchored = true
		p.BrickColor = BrickColor.new("Bright red")
		p.Position =
			workspace.CurrentCamera.CFrame.Position +
			workspace.CurrentCamera.CFrame.LookVector*(20+i*3) +
			Vector3.new(math.random(-5,5), math.random(-2,2), math.random(-5,5))
		p.Parent = folder
	end
end

TrainTab:CreateButton({
	Name = "Spawn Targets (5)",
	Callback = function() spawnTargets(5) end
})

TrainTab:CreateButton({
	Name = "Clear Targets",
	Callback = function()
		if folder then folder:Destroy(); folder=nil end
	end
})
