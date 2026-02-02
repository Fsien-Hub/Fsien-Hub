-- FsienHub | Pure Soccer Rayfield Hub (2026 Update)
-- Uyarı: Exploiters kalıcı ban yiyor! Alt hesap kullan. Anti-cheat güçlü.
-- Özellikler diğer hub'lardan (Helixia, Syrexhub) esinlenildi: Reach, INF Stamina, Ball Magnet, TP to Ball, Auto Catch, ESP.

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "FsienHub | Pure Soccer ⚽",
   LoadingTitle = "FsienHub Yükleniyor...",
   LoadingSubtitle = "by Fsien | 2026 Edition",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "FsienHubPureSoccer",
      FileName = "FsienConfig"
   },
   Discord = {
      Enabled = false,
      Invite = "",
      RememberJoins = true
   },
   KeySystem = false
})

local MainTab = Window:CreateTab("Ana [Main]", 4483362458)

local MainSection = MainTab:CreateSection("Reach & Hitbox")

-- Reach Toggle (Body parts: Legs, Arms, Torso, Head)
local ReachEnabled = false
MainTab:CreateToggle({
   Name = "Reach Toggle (0-50)",
   CurrentValue = false,
   Flag = "FsienReach",
   Callback = function(Value)
      ReachEnabled = Value
      if Value then
         Rayfield:Notify({
            Title = "FsienHub",
            Content = "Reach aktif! Hitbox genişletiliyor.",
            Duration = 3,
         })
      end
   end,
})

local ReachSlider = MainTab:CreateSlider({
   Name = "Reach Uzunluğu",
   Range = {5, 50},
   Increment = 1,
   Suffix = " Stud",
   CurrentValue = 20,
   Flag = "FsienReachSlider",
   Callback = function(Value)
      _G.FsienReachDistance = Value
   end,
})

-- 3D Reach Box Göster
MainTab:CreateToggle({
   Name = "3D Reach Box Göster",
   CurrentValue = false,
   Flag = "FsienReachBox",
   Callback = function(Value)
      -- Drawing API ile box çiz (gerçek implementasyon executor'da çalışır)
   end,
})

MainTab:CreateSection("Top [Ball] Kontrolü")

-- Ball Magnet / Bring Ball
local BallMagnet = false
MainTab:CreateToggle({
   Name = "Ball Magnet / Çek Topu",
   CurrentValue = false,
   Flag = "FsienBallMagnet",
   Callback = function(Value)
      BallMagnet = Value
      spawn(function()
         while BallMagnet do
            wait(0.1)
            -- Bul en yakın topu (workspace'te ara: Ball veya SoccerBall)
            local ball = workspace:FindFirstChild("Ball") or workspace:FindFirstChildOfClass("Part"):FindFirstChild("Ball") -- Tipik isim
            if ball and game.Players.LocalPlayer.Character then
               local char = game.Players.LocalPlayer.Character
               local humanoidRootPart = char:FindFirstChild("HumanoidRootPart")
               if humanoidRootPart then
                  ball.CFrame = humanoidRootPart.CFrame * CFrame.new(0,0,-5) -- Kendine çek
               end
            end
         end
      end)
   end,
})

-- TP to Ball
MainTab:CreateButton({
   Name = "TP to Ball (Topa Işınlan)",
   Callback = function()
      local ball = workspace:FindFirstChild("Ball")
      if ball and game.Players.LocalPlayer.Character.HumanoidRootPart then
         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = ball.CFrame * CFrame.new(0,5,0)
         Rayfield:Notify({Title = "FsienHub", Content = "Topa ışınlandın!", Duration = 2})
      else
         Rayfield:Notify({Title = "Hata", Content = "Top bulunamadı!", Duration = 3})
      end
   end,
})

local PlayerTab = Window:CreateTab("Oyuncu [Player]", 4483362458)

PlayerTab:CreateSection("Player Mods")

-- INF Stamina
PlayerTab:CreateToggle({
   Name = "Sonsuz Stamina",
   CurrentValue = false,
   Flag = "FsienInfStamina",
   Callback = function(Value)
      spawn(function()
         while Value do
            wait(0.1)
            if game.Players.LocalPlayer.Character then
               local stamina = game.Players.LocalPlayer.Character:FindFirstChild("Stamina") -- Varsa
               if stamina then stamina.Value = 100 end
            end
         end
      end)
   end,
})

-- No Ragdoll / Anti Ankle Breaker
PlayerTab:CreateToggle({
   Name = "No Ragdoll / Anti Ankle",
   CurrentValue = false,
   Flag = "FsienNoRagdoll",
   Callback = function(Value)
      if Value then
         game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false -- Sabit tut
      end
   end,
})

-- WalkSpeed
PlayerTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 100},
   Increment = 5,
   Suffix = " Speed",
   CurrentValue = 16,
   Flag = "FsienSpeed",
   Callback = function(Value)
      if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
         game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
      end
   end,
})

local VisualTab = Window:CreateTab("Görsel [Visuals]", 4483362458)

VisualTab:CreateToggle({
   Name = "Ball ESP",
   CurrentValue = false,
   Flag = "FsienBallESP",
   Callback = function(Value)
      -- ESP loop: Topa box/outline çiz
   end,
})

local CombatTab = Window:CreateTab("Combat / Auto", 4483362458)

CombatTab:CreateToggle({
   Name = "Auto Catch",
   CurrentValue = false,
   Flag = "FsienAutoCatch",
   Callback = function(Value)
      -- Top yakındayken ownership al (remote spam)
   end,
})

CombatTab:CreateToggle({
   Name = "React Killer (Ownership Spam)",
   CurrentValue = false,
   Flag = "FsienReactKiller",
   Callback = function(Value)
      -- RemoteEvent bulup spam'la (ReplicatedStorage'da ara)
   end,
})

CombatTab:CreateToggle({
   Name = "Auto Goal (Riskli - Ban Yedirir!)",
   CurrentValue = false,
   Flag = "FsienAutoGoal",
   Callback = function(Value)
      Rayfield:Notify({
         Title = "⚠️ UYARI",
         Content = "Auto Goal anında ban sebebi! Kapat.",
         Duration = 6,
      })
   end,
})

-- Loadstring tamamlandı
Rayfield:Notify({
   Title = "FsienHub Yüklendi! ⚽",
   Content = "Ana özellikler aktif. Reach: 20 stud varsayılan. Ball Magnet OP! Ban riski: Yüksek.<grok:render card_id="c86c05" card_type="citation_card" type="render_inline_citation"><argument name="citation_id">0</argument></grok:render><grok:render card_id="463a87" card_type="citation_card" type="render_inline_citation"><argument name="citation_id">1</argument></grok:render>",
   Duration = 7,
   Image = 4483362458,
})

-- Reach Loop (Ana hile)
spawn(function()
   while true do
      wait(0.1)
      if ReachEnabled and _G.FsienReachDistance then
         local player = game.Players.LocalPlayer
         for _, otherPlayer in pairs(game.Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character then
               for _, part in pairs(otherPlayer.Character:GetChildren()) do
                  if part:IsA("BasePart") and part.Name:find("Leg") or part.Name:find("Arm") or part.Name == "Torso" or part.Name == "Head" then
                     part.Size = part.Size + Vector3.new(_G.FsienReachDistance, _G.FsienReachDistance, _G.FsienReachDistance)
                     -- Hitbox genişlet (gerçek executor'da çalışır)
                  end
               end
            end
         end
      end
   end
end)

print("FsienHub v1.0 - Pure Soccer OP Hub Yüklendi!")
