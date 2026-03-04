--// Fsien Hub
--// Orion Library Required

local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

local Window = OrionLib:MakeWindow({
	Name = "Fsien Hub | Conquer UI",
	HidePremium = false,
	SaveConfig = false,
	ConfigFolder = "FsienHub"
})

--// Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

--// Mock Data (Replace with your game remotes)
local PlayerData = {
	CountriesOwned = {"France", "Germany"},
	IncomePerMinute = 1250,
	ArmySize = 5000,
	Manpower = 8000,
	Factories = 12,
	Capital = "Paris"
}

--========================--
-- TERRITORY TRACKER TAB --
--========================--

local TerritoryTab = Window:MakeTab({
	Name = "Territory Tracker",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

TerritoryTab:AddParagraph("Owned Nations", table.concat(PlayerData.CountriesOwned, ", "))

TerritoryTab:AddButton({
	Name = "Refresh Territory Data",
	Callback = function()
		-- Replace with remote call
		OrionLib:MakeNotification({
			Name = "Fsien Hub",
			Content = "Territory data refreshed.",
			Time = 3
		})
	end
})

--========================--
-- INCOME TAB --
--========================--

local IncomeTab = Window:MakeTab({
	Name = "Economy",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

IncomeTab:AddParagraph("Income Per Minute", "$"..PlayerData.IncomePerMinute)

IncomeTab:AddParagraph("Factories Owned", PlayerData.Factories)

IncomeTab:AddButton({
	Name = "Check Production Rates",
	Callback = function()
		print("Factory production check triggered")
	end
})

--========================--
-- ARMY TAB --
--========================--

local ArmyTab = Window:MakeTab({
	Name = "Army Stats",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

ArmyTab:AddParagraph("Army Size", PlayerData.ArmySize)
ArmyTab:AddParagraph("Manpower", PlayerData.Manpower)

ArmyTab:AddButton({
	Name = "Compare Closest Rival",
	Callback = function()
		OrionLib:MakeNotification({
			Name = "Army Comparison",
			Content = "You are stronger than nearest rival.",
			Time = 3
		})
	end
})

--========================--
-- TARGET HELPER TAB --
--========================--

local TargetTab = Window:MakeTab({
	Name = "Target Helper",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

TargetTab:AddButton({
	Name = "Find Weaker Neighbors",
	Callback = function()
		print("Scanning for weaker enemies...")
	end
})

TargetTab:AddParagraph("Nearest Weaker Nation", "Spain (Distance: 320km)")

--========================--
-- NAVIGATION TAB --
--========================--

local NavTab = Window:MakeTab({
	Name = "Navigation",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

NavTab:AddButton({
	Name = "Teleport to HQ",
	Callback = function()
		-- Replace with safe in-game teleport logic
		print("Teleport requested to HQ")
	end
})

NavTab:AddButton({
	Name = "Teleport to Capital",
	Callback = function()
		print("Teleport requested to Capital")
	end
})

--========================--
-- ALERT SYSTEM TAB --
--========================--

local AlertTab = Window:MakeTab({
	Name = "Alerts",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

AlertTab:AddButton({
	Name = "Simulate War Alert",
	Callback = function()
		OrionLib:MakeNotification({
			Name = "⚔ War Declared",
			Content = "A neighboring nation declared war!",
			Time = 5
		})
	end
})

AlertTab:AddButton({
	Name = "Simulate Income Drop",
	Callback = function()
		OrionLib:MakeNotification({
			Name = "⚠ Economy Warning",
			Content = "Income dropped below average.",
			Time = 5
		})
	end
})

OrionLib:Init()
