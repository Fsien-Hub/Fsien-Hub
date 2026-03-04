local player = game.Players.LocalPlayer

-- GUI oluştur
local screenGui = script.Parent
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0,300,0,200)
frame.Position = UDim2.new(0.5,-150,0.5,-100)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)

local box = Instance.new("TextBox", frame)
box.Size = UDim2.new(0.8,0,0,40)
box.Position = UDim2.new(0.1,0,0.3,0)
box.PlaceholderText = "Miktar gir"
box.Text = ""

local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(0.8,0,0,40)
button.Position = UDim2.new(0.1,0,0.6,0)
button.Text = "Parayı Değiştir"

local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0,30,0,30)
close.Position = UDim2.new(1,-35,0,5)
close.Text = "X"

-- Para sadece kendinde değişir
button.MouseButton1Click:Connect(function()

	local amount = tonumber(box.Text)
	if not amount then return end

	local leaderstats = player:FindFirstChild("leaderstats")
	if not leaderstats then return end

	local money = leaderstats:FindFirstChild("Money")
	if not money then return end

	money.Value = amount

end)

-- Kapatma
close.MouseButton1Click:Connect(function()
	screenGui.Enabled = false
end)
