--[[
	Client file, stuff only the client needs
]]

net.Receive("nak_simf_gtasa_dmgsnd", function()
	local ent = net.ReadEntity()
	local snd = net.ReadString()
	if IsValid(ent) then ent.DamageSnd = CreateSound(ent, snd) end
end)

net.Receive("nak_gtasa_updsidedownfire", function()
	local ent = net.ReadEntity()
	if IsValid(ent) then
		local delay = 0.1
		local nextOccurance = 0
		hook.Add("Think", "nak_gtasa_updsidedownfire" .. ent:EntIndex(), function()
			local timeLeft = nextOccurance - CurTime()
			if timeLeft > 0 then return end
			if IsValid(ent) then
				local effectdata = EffectData()
				effectdata:SetOrigin(ent:GetEnginePos() + Vector(0, 0, 25))
				effectdata:SetEntity(ent)
				util.Effect("simf_gtasa_fire", effectdata)
				nextOccurance = CurTime() + delay
			else
				hook.Remove("Think", "nak_gtasa_updsidedownfire" .. ent:EntIndex())
			end
		end)
	end
end)