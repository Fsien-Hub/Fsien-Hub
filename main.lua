local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- RemoteEvent oluştur
local AddMoneyEvent = ReplicatedStorage:FindFirstChild("AddMoneyEvent")
if not AddMoneyEvent then
	AddMoneyEvent = Instance.new("RemoteEvent")
	AddMoneyEvent.Name = "AddMoneyEvent"
	AddMoneyEvent.Parent = ReplicatedStorage
end

-- Leaderstats oluştur
Players.PlayerAdded:Connect(function(player)

	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local Money = Instance.new("IntValue")
	Money.Name = "Money"
	Money.Value = 100
	Money.Parent = leaderstats

end)

-- Para ekleme
AddMoneyEvent.OnServerEvent:Connect(function(player, amount)

	if typeof(amount) ~= "number" then return end
	if amount <= 0 then return end

	local money = player:FindFirstChild("leaderstats"):FindFirstChild("Money")
	if money then
		money.Value += amount
	end

end)
