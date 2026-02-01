-- Fsien Hub - Delta Executor için (Steal a Brainrot brainrot isimleri + scanner)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Fsien Hub",
   LoadingTitle = "Yükleniyor...",
   LoadingSubtitle = "by Fsien",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "FsienHub",
      FileName = "Config"
   },
   KeySystem = false,
})

-- Steal a Brainrot Özel Tab
local SabTab = Window:CreateTab("Steal a Brainrot")

SabTab:CreateLabel("Değerli Brainrot Scanner (İsimleri Gösterir)")

SabTab:CreateButton({
   Name = "Server Tarama & Brainrot İsimleri Göster (20M+ Filtre)",
   Callback = function()
      Rayfield:Notify({Title = "Tarama Başladı", Content = "Bu serverdeki 20M+ brainrot'lar aranıyor..."})

      local threshold = 20000000  -- 20 milyon income altı filtre
      local valuableFound = false
      local brainrotList = {}  -- Bulunan isimleri topla

      -- Workspace'teki pet/brainrot modellerini tara (oyunda pet'ler workspace'te model olarak spawn olur)
      for _, obj in pairs(workspace:GetChildren()) do
         if obj:IsA("Model") and (obj:FindFirstChild("Income") or obj:FindFirstChild("Value") or obj.Name:match("Brainrot") or obj.Name:match("God")) then
            local income = 0
            if obj:FindFirstChild("Income") then income = obj.Income.Value or 0 end
            if obj:FindFirstChild("Value") then income = obj.Value.Value or 0 end

            if income >= threshold then
               valuableFound = true
               local brainrotName = obj.Name or "Bilinmeyen Brainrot"
               table.insert(brainrotList, brainrotName .. " (Income: " .. income .. ")")
            end
         end
      end

      if #brainrotList > 0 then
         local message = "Bu serverde değerli brainrot var!\n\n" .. table.concat(brainrotList, "\n")
         Rayfield:Notify({
            Title = "Değerli Bulundu!",
            Content = message,
            Duration = 20  -- uzun süre göster
         })
         print(message)  -- konsola da yaz
         -- Otomatik join mantığı: değerli varsa hop yapma (kal), yoksa hop
         -- (TeleportService ile hop için aşağıda yorumlu kod var)
      else
         Rayfield:Notify({Title = "Bulunamadı", Content = "20M+ brainrot yok, server hop yapılıyor..."})
         -- Auto hop (ban riski için yavaşlattım)
         wait(2)
         game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
      end
   end,
})

SabTab:CreateButton({
   Name = "Hazır Gelişmiş Pet/Brainrot Finder Yükle",
   Callback = function()
      -- Popüler hazır script (force hop + isim loglama, 5M+ filtreli – 20M'ye uyarla)
      loadstring(game:HttpGet("https://raw.githubusercontent.com/r0bloxlucker/sabfinderwithoutdualhook/refs/heads/main/finderv2.lua"))()
      Rayfield:Notify({Title = "Yüklendi", Content = "Hazır finder aktif! Değerli brainrot bulunca isim gösterir ve durur."})
   end,
})

SabTab:CreateParagraph({
   Title = "Nasıl Çalışır?",
   Content = "Butona bas → Script bu serverdeki brainrot'ları tarar. 20M+ income'li olanların isimlerini listeler (örneğin 'Strawberry Elephant (250M/s)', 'Dragon Cannelloni (100M/s)'). Bulursa bildirir ve hop yapmaz (kal), yoksa otomatik hop'lar. Değerli örnekler: Strawberry Elephant, Meowl, Dragon Cannelloni, Skibidi Toilet, Tralalero Tralala vs."
})

print("Fsien Hub yüklendi - Brainrot isim tarayıcı hazır!")
