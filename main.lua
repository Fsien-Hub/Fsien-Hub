-- Fsien Pure Soccer Hile - 100% ÇALIŞIR (Infinite Stamina + Reach + Speed + Anti Kick)
-- 2026 February - Delta Uyumlu

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

-- Infinite Stamina (sonsuz dayanıklılık)
spawn(function()
   while true do
      wait(0.1)
      local stamina = char:FindFirstChild("Stamina") or char:FindFirstChild("Energy")
      if stamina then
         stamina.Value = stamina.MaxValue or 100
      end
   end
end)

-- Reach (vuruş menzili büyüt - topa uzaktan vur)
spawn(function()
   while true do
      wait(0.05)
      local parts = char:GetDescendants()
      for _, part in pairs(parts) do
         if part:IsA("BasePart") and (part.Name:find("Foot") or part.Name:find("Leg")) then
            part.Size = Vector3.new(8, 8, 8)
            part.Transparency = 0.5
            part.CanCollide = false
         end
      end
   end
end)

-- Speed Hack (hız artır)
humanoid.WalkSpeed = 35  -- normal 16, 35 hızlı ama doğal görünüyor
humanoid.JumpPower = 65

-- Anti Kick (kick koruma)
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
   if getnamecallmethod() == "Kick" then
      return  -- kick'i engelle
   end
   return old(self, ...)
end)
setreadonly(mt, true)

-- Karakter yenilenince otomatik yeniden yükle
player.CharacterAdded:Connect(function(newChar)
   char = newChar
   humanoid = newChar:WaitForChild("Humanoid")
   root = newChar:WaitForChild("HumanoidRootPart")
   humanoid.WalkSpeed = 35
   humanoid.JumpPower = 65
end)

game.StarterGui:SetCore("SendNotification", {
   Title = "Fsien Hile";
   Text = "Pure Soccer hileleri yüklendi! Stamina sonsuz, reach büyütüldü.";
   Duration = 5;
})

print("Fsien Pure Soccer Hile yüklendi! Infinite Stamina, Reach, Speed, Anti Kick AKTIF 🚀")
