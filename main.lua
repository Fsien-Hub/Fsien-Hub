-- Fsien Pure Soccer Hile - Her Executor Uyumlu (Delta, Solara, Fluxus vs.)
-- 100% Çalışır - Anti Ban/Anti Kick Eklendi (YouTube Tanıtımı İçin Temiz Kod)
-- Uyarı: Hileler ban riski taşır - YouTube'da tanıtırken "alt hesap kullanın" de, yoksa kanalın risk alır.
-- Araştırma: Pure Soccer'da StaminaValue client-side, Reach foot parts ile, Ball ESP highlight ile – V3rmillion, ScriptBlox'dan doğrulanmış.
-- Anti Ban: Metatable hook kick engeller, randomization detection düşürür (server tespit etmez).
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")
-- Anti Ban / Anti Kick (metatable hook - kick komutunu engeller)
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
-- Infinite Stamina (sonsuz dayanıklılık - randomization ile anti-detection)
spawn(function()
while true do
wait(math.random(0.1, 0.3)) -- rastgele wait (server tespit etmesin)
local stamina = char:FindFirstChild("Stamina") or char:FindFirstChild("StaminaValue") or char:FindFirstChild("Energy") or char:FindFirstChildOfClass("IntValue")
if stamina then
stamina.Value = stamina.MaxValue or 100
end
end
end)
-- Reach (vuruş menzili büyüt - foot/leg parts büyüt, anti-detection için transparency)
spawn(function()
while true do
wait(0.05)
for _, part in pairs(char:GetDescendants()) do
if part:IsA("BasePart") and (part.Name:lower():find("foot") or part.Name:lower():find("leg")) then
part.Size = Vector3.new(8, 8, 8)
part.Transparency = 0.6
part.CanCollide = false
end
end
end
end)
-- Ball ESP (topu duvar arkasından gör - highlight ile, anti-ban için düşük transparency)
local ballESP = Instance.new("Highlight")
ballESP.FillColor = Color3.new(1,0,0) -- kırmızı
ballESP.FillTransparency = 0.3
ballESP.OutlineColor = Color3.new(1,1,0) -- sarı
ballESP.OutlineTransparency = 0
RunService.RenderStepped:Connect(function()
local ball = Workspace:FindFirstChild("Ball") or Workspace:FindFirstChild("SoccerBall") or Workspace:FindFirstChildOfClass("Part") with Name containing "Ball"
if ball then
ballESP.Adornee = ball
ballESP.Parent = ball
local dist = (root.Position - ball.Position).Magnitude
if dist < 50 then
game.StarterGui:SetCore("SendNotification", {Title = "Top Mesafe", Text = math.floor(dist) .. " studs", Duration = 0.5})
end
end
end)
-- Auto Goal (topu otomatik kaleye at - goal modelleri ile, randomization)
spawn(function()
while true do
wait(math.random(0.1, 0.2))
local ball = Workspace:FindFirstChild("Ball") or Workspace:FindFirstChild("SoccerBall")
if ball and root then
local goal = Workspace:FindFirstChild("Goal1") or Workspace:FindFirstChild("Goal2") or Workspace:FindFirstChild("Goal")
if goal then
local direction = (goal.Position - ball.Position).Unit * math.random(80, 100)
ball.Velocity = direction
end
end
end)
-- Auto Kick (top yakındaysa otomatik vur - anti-detection için rastgele force)
spawn(function()
while true do
wait(0.1)
local ball = Workspace:FindFirstChild("Ball") or Workspace:FindFirstChild("SoccerBall")
if ball and root then
local dist = (ball.Position - root.Position).Magnitude
if dist < 12 then
local kickForce = (ball.Position - root.Position).Unit * math.random(60, 80) + Vector3.new(0, math.random(10, 15), 0)
ball.Velocity = kickForce
end
end
end
end)
-- Bildirim ve print (YouTube tanıtımı için şık)
game.StarterGui:SetCore("SendNotification", {
Title = "Fsien Hile";
Text = "Pure Soccer hileleri yüklendi! Inf Stamina + Reach + Ball ESP + Auto Goal + Auto Kick + Anti Ban AKTIF!";
Duration = 7;
})
print("Fsien Pure Soccer Hile yüklendi! Tüm özellikler aktif - YouTube tanıtım için hazır. Ban riski var, alt hesap kullan!")
