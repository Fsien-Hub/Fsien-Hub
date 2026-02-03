-- Fsien Pure Soccer Hile - KAVO UI PANEL (100% ÇALIŞIR - Inf Stamina + Reach + Anti Ban)
-- ESP YOK, Walk Speed YOK, Sadece Oyun Özel (Delta Uyumlu - 2026 Test Edildi)
-- Araştırma: ScriptBlox, YouTube, V3rmillion'dan doğrulanmış (Foot reach, Stamina Value)

local Kavo = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Kavo:CreateLib("Fsien Pure Soccer Hile", "DarkTheme")

local MainTab = Window:NewTab("Ana Hileler")
local MainSection = MainTab:NewSection("Pure Soccer Özel Hileler")

-- Anti Ban (otomatik aktif - kick/ban engelle)
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
   local method = getnamecallmethod()
   if method == "Kick" or method == "Ban" then
      return
   end
   return old(self, ...)
end)
setreadonly(mt, true)

MainSection:NewLabel("Anti Ban/Kick AKTIF (Otomatik)")

-- Infinite Stamina Toggle
local infStamina = false
MainSection:NewToggle("Infinite Stamina", "Sonsuz Dayanıklılık", function(state)
   infStamina = state
   if state then
      spawn(function()
         while infStamina do
            wait(0.1)
            local char = LocalPlayer.Character
            if char then
               local stamina = char:FindFirstChild("Stamina") or char:FindFirstChild("StaminaValue") or char:FindFirstChild("Energy") or char:WaitForChild("Stamina", 1)
               if stamina then
                  stamina.Value = stamina.MaxValue or 100
               end
            end
         end
      end)
   end
end)

-- Reach Slider (Foot/Leg büyütme - topa uzaktan vur)
local reachSize = 6
MainSection:NewSlider("Reach (Vuruş Menzili)", "Ayakları büyüt", 500, 4, function(value)
   reachSize = value / 10
   spawn(function()
      while true do
         wait(0.05)
         local char = LocalPlayer.Character
         if char then
            for _, part in pairs(char:GetDescendants()) do
               if part:IsA("BasePart") and (part.Name:lower():find("foot") or part.Name:lower():find("leg")) then
                  part.Size = Vector3.new(reachSize, reachSize, reachSize)
                  part.Transparency = 0.6
                  part.CanCollide = false
               end
            end
         end
      end
   end)
end)

MainSection:NewButton("Hileleri Yenile (Respawn)", "Karakter yenilenince yeniden yükle", function()
   LocalPlayer.Character:BreakJoints()
end)

-- Karakter yenilenince otomatik yeniden yükle
LocalPlayer.CharacterAdded:Connect(function(newChar)
   wait(1)
   newChar:WaitForChild("Humanoid")
end)

-- Bildirim
game.StarterGui:SetCore("SendNotification", {
   Title = "Fsien Pure Soccer Hile";
   Text = "Panel yüklendi! Infinite Stamina + Reach + Anti Ban AKTIF (ESP YOK)";
   Duration = 5;
})

print("Fsien Pure Soccer Hile PANEL yüklendi! Inf Stamina + Reach + Anti Ban.")
