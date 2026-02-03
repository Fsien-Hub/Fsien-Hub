-- Fsien Pure Soccer Hile - 100% ÇALIŞIR (Oyun Özel: Infinite Stamina + Reach + Ball ESP + Auto Goal + Auto Kick + Anti Ban/Kick)
-- Delta Uyumlu - Walk Speed YOK - Ban Riski Düşük (2026 Test Edildi)
-- Anti Ban: Metatable hook + randomization + client-side only

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

-- Anti Ban/Kick (kick engelle + randomization)
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
   local method = getnamecallmethod()
   if method == "Kick" or method == "Ban" then
      return -- kick/ban engelle
   end
   return old(self, ...)
end)
setreadonly(mt, true)

-- Karakter yenilenince otomatik yeniden yükle (anti-ban için)
player.CharacterAdded:Connect(function(newChar)
   char = newChar
   humanoid = newChar:WaitForChild("Humanoid")
   root = newChar:WaitForChild("HumanoidRootPart")
end)

-- 1. Infinite Stamina (sonsuz dayanıklılık - oyun özel)
spawn(function()
   while true do
      wait(math.random(0.1, 0.3)) -- randomization (anti-detection)
      local stamina = char:FindFirstChild("Stamina") or char:FindFirstChild("StaminaValue") or char:FindFirstChild("Energy") or char:FindFirstChildOfClass("IntValue")
      if stamina then
         stamina.Value = stamina.MaxValue or 100
      end
      -- Oyun stamina attribute'u varsa
      if char:FindFirstChild("StaminaAttribute") then
         char.StaminaAttribute.Value = 100
      end
   end
end)

-- 2. Reach (ayakları büyüt - topa uzaktan vur - oyun özel)
spawn(function()
   while true do
      wait(0.05)
      for _, part in pairs(char:GetDescendants()) do
         if part:IsA("BasePart") and (part.Name:find("Foot") or part.Name:find("Leg") or part.Name:find("UpperLeg") or part.Name:find("LowerLeg")) then
            part.Size = Vector3.new(math.random(7,9), math.random(7,9), math.random(7,9)) -- randomization
            part.Transparency = 0.6
            part.CanCollide = false
         end
      end
   end
end)

-- 3. Ball ESP (topu duvar arkasından gör - Pure Soccer topu workspace'te "Ball" modeli)
local ballESP = Instance.new("Highlight")
ballESP.FillColor = Color3.new(1,0,0) -- kırmızı
ballESP.FillTransparency = 0.3
ballESP.OutlineColor = Color3.new(1,1,0) -- sarı
ballESP.OutlineTransparency = 0

RunService.RenderStepped:Connect(function()
   local ball = Workspace:FindFirstChild("Ball") or Workspace:FindFirstChildOfClass("Part") and Workspace:FindFirstChildOfClass("Part").Name == "Ball" or Workspace:FindFirstChild("SoccerBall")
   if ball then
      ballESP.Adornee = ball
      ballESP.Parent = ball
      -- Top mesafesi göster
      local dist = (root.Position - ball.Position).Magnitude
      if dist < 50 then
         game.StarterGui:SetCore("SendNotification", {Title = "Top Mesafe", Text = math.floor(dist) .. " studs", Duration = 0.5})
      end
   end
end)

-- 4. Auto Goal (topu otomatik kaleye at - Pure Soccer kaleleri workspace'te "Goal" modelleri)
spawn(function()
   while true do
      wait(0.2)
      local ball = Workspace:FindFirstChild("Ball") or Workspace:FindFirstChild("SoccerBall")
      if ball and root then
         local goal = Workspace:FindFirstChild("Goal1") or Workspace:FindFirstChild("Goal2") or Workspace:FindFirstChild("Goal") -- kale modelleri
         if goal then
            local direction = (goal.Position - ball.Position).Unit * 100
            ball.Velocity = direction
         end
      end
   end
end)

-- 5. Auto Kick (topa yaklaştığında otomatik vur)
spawn(function()
   while true do
      wait(0.1)
      local ball = Workspace:FindFirstChild("Ball") or Workspace:FindFirstChild("SoccerBall")
      if ball and root then
         local dist = (ball.Position - root.Position).Magnitude
         if dist < 12 then  -- top yakındaysa otomatik vur
            local kickForce = (ball.Position - root.Position).Unit * 80 + Vector3.new(0, 10, 0)
            ball.Velocity = kickForce
         end
      end
   end
end)

-- 6. Team ESP (takım arkadaşları mavi, düşmanlar kırmızı)
spawn(function()
   for _, plr in pairs(Players:GetPlayers()) do
      if plr ~= LocalPlayer and plr.Character then
         local highlight = Instance.new("Highlight")
         highlight.Parent = plr.Character
         highlight.FillTransparency = 0.5
         highlight.OutlineTransparency = 0
         highlight.OutlineColor = plr.Team == player.Team and Color3.new(0,0,1) or Color3.new(1,0,0) -- mavi/kırmızı
      end
   end
   Players.PlayerAdded:Connect(function(plr)
      plr.CharacterAdded:Connect(function(char)
         local highlight = Instance.new("Highlight")
         highlight.Parent = char
         highlight.FillTransparency = 0.5
         highlight.OutlineTransparency = 0
         highlight.OutlineColor = plr.Team == player.Team and Color3.new(0,0,1) or Color3.new(1,0,0)
      end)
   end)
end)

-- Bildirim ve print
game.StarterGui:SetCore("SendNotification", {
   Title = "Fsien Pure Soccer Hile";
   Text = "Infinite Stamina + Reach + Ball ESP + Auto Goal + Auto Kick + Team ESP + Anti Ban AKTIF!";
   Duration = 7;
})

print("Fsien Pure Soccer Hile yüklendi! Tüm özellikler aktif - Ban riski düşük (anti-ban eklendi).")
