local Test = game.ReplicatedStorage.Resources.IceSlashVFX.LastSlashFx.LastSlashFx.Attachment
local test = Test:Clone()
test.Parent = game.Players.LocalPlayer.Character["HumanoidRootPart"]


for _, child in ipairs(test:GetChildren()) do
    if child:IsA("ParticleEmitter") then


        child:Emit(15)
        child.Enabled = true
    end
end
