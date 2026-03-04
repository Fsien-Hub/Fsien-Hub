--// SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

--// RemoteEvent oluştur (yoksa)
local AddMoneyEvent = ReplicatedStorage:FindFirstChild("AddMoneyEvent")
if not AddMoneyEvent then
	AddMoneyEvent = Instance.new("RemoteEvent")
	AddMoneyEvent.Name = "AddMoneyEvent"
	AddMoneyEvent.Parent = ReplicatedStorage
end

--// UI OLUŞTURMA
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "MoneyPanel"

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0,300,0,200)
frame.Position = UDim2.new(0.5,-150,0.5,-100)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)

local box = Instance.new("TextBox", frame)
box.Size = UDim2.new(0.8,0,0,40)
box.Position = UDim2.new(0.1,0,0.3,0)
box.PlaceholderText = "Para miktarı yaz"
box.Text = ""

local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(0.8,0,0,40)
button.Position = UDim2.new(0.1,0,0.6,0)
button.Text = "Parayı Ekle"

--// BUTON TIKLAMA
button.MouseButton1Click:Connect(function()

	local amount = tonumber(box.Text)
	if amount and amount > 0 then
		AddMoneyEvent:FireServer(amount)
	end

end)

--// SERVER TARAFI (tek script içinde çalışması için)
if game:GetService("RunService"):IsServer() then
	
	AddMoneyEvent.OnServerEvent:Connect(function(player, amount)

		if typeof(amount) ~= "number" then return end
		if amount <= 0 then return end

		local leaderstats = player:FindFirstChild("leaderstats")
		if leaderstats then
			local money = leaderstats:FindFirstChild("Money")
			if money then
				money.Value += amount
			end
		end

	end)

end
