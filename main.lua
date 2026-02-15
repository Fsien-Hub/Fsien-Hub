-- Conquer The World WW2 | KENDİ HİLE - SINIRSIZ GOLD (2026 Fix)
local player = game.Players.LocalPlayer
local leaderstats = player:WaitForChild("leaderstats", 15)
local RS = game:GetService("ReplicatedStorage")

-- 1. Local infinite (sen görürsün)
if leaderstats then
    local gold = leaderstats:FindFirstChild("Gold")
    if gold and gold:IsA("IntValue") or gold:IsA("NumberValue") then
        gold.Value = math.huge  -- veya 9999999999999
        print("Local Gold ∞ yapıldı!")
    else
        print("Gold stat bulunamadı! Leaderstats kontrol et.")
    end
end

-- 2. Remote spam için finder (oyundaki income/collect remote'ları hedefle)
local function spamRemotes()
    local remotes = {}
    for _, obj in pairs(RS:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            local name = string.lower(obj.Name)
            if name:find("collect") or name:find("income") or name:find("tax") or name:find("gold") or name:find("resource") or name:find("money") then
                table.insert(remotes, obj)
                print("Bulunan remote:", obj.Name)
            end
        end
    end
    
    if #remotes == 0 then
        print("Hiç income remote bulunamadı! Tüm remotes'i dene veya F9 bak.")
        -- Ekstra: Tüm RemoteEvent'leri spam (riskli ama bazen çalışır)
        for _, obj in pairs(RS:GetDescendants()) do
            if obj:IsA("RemoteEvent") then
                table.insert(remotes, obj)
            end
        end
    end
    
    -- Spam loop (ban risk düşük tutmak için yavaş)
    while true do
        for _, remote in pairs(remotes) do
            pcall(function()
                remote:FireServer(999999999999)  -- veya math.huge, argümanı dene
                -- Alternatif argümanlar dene: remote:FireServer("Gold", 1e12) veya remote:FireServer(player, 999999)
            end)
        end
        wait(1.5)  -- 1.5 sn bekle, spam çok olursa ban gelebilir
    end
end

spawn(spamRemotes)  -- Arka planda çalıştır
print("SINIRSIZ GOLD SPAM BAŞLADI! Gold artıyorsa server sync oldu. Artmıyorsa remote argümanı yanlış – F9 console'dan remote isimleri at bana.")
