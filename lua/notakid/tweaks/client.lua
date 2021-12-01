--[[
	Client file, stuff only the client needs
]]

--replace damaged engine sound on client
net.Receive("nak_tweaks_snd_engine_damaged", function()
	local self = net.ReadEntity()
	local snd_engine_damaged = net.ReadString()
	if IsValid(self) then self.DamageSnd = CreateSound(self, snd_engine_damaged) end
end)

--run particles for fire
net.Receive("nak_tweaks_flipped_fire", function()
	local ent = net.ReadEntity()
	if IsValid(ent) then
		local delay = 0.1
		local nextOccurance = 0
		hook.Add("Think", "nak_tweaks_flipped_fire" .. ent:EntIndex(), function()
			local timeLeft = nextOccurance - CurTime()
			if timeLeft > 0 then return end
			if IsValid(ent) then
				local effectdata = EffectData()
				effectdata:SetOrigin(ent:GetEnginePos() + Vector(0, 0, 25))
				effectdata:SetEntity(ent)
				util.Effect("simf_gtasa_fire", effectdata)
				nextOccurance = CurTime() + delay
			else
				hook.Remove("Think", "nak_tweaks_flipped_fire" .. ent:EntIndex())
			end
		end)
	end
end)