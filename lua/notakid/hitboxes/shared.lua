--[[
	Shared file, stuff needed on both client and server
]]
NAK = istable( NAK ) and NAK or {}
function NAK.GetHitboxes(self)

	local hblist = list.Get("nak_simf_hitboxes")
	local hbspawnlist = IsValid(self) and hblist[self:GetSpawn_List()] or false

	if hbspawnlist then
		local HBInfo = hbspawnlist[2] and hbspawnlist[1] or hbspawnlist
		local HBExtra = hbspawnlist[2] and hbspawnlist[2] or nil
		
		for id in pairs(HBInfo) do
			--Set current health, unless it is added by the mod maker
			HBInfo[id].CurHealth =
				HBInfo[id].CurHealth or HBInfo[id].Health
			HBInfo[id].Stage = 0
			--Mirror that hitbox!
			if HBInfo[id].Mirror then
				local MirrorAxis = HBInfo[id].Mirror
				HBInfo[id .. "_2"] = {}
				--The hitboxes bounds
				HBInfo[id .. "_2"].OBBMin =
					HBInfo[id].OBBMin * MirrorAxis
				HBInfo[id .. "_2"].OBBMax =
					HBInfo[id].OBBMax * MirrorAxis
				--Type of hitbox (glass, gas tank, normal)
				HBInfo[id .. "_2"].TypeFlag =
					HBInfo[id].TypeFlag
				--Gib model, offset, ect
				HBInfo[id .. "_2"].BDGroup =
					HBInfo[id].BDGroup_2
				HBInfo[id .. "_2"].GibModel =
					HBInfo[id].GibModel_2
				HBInfo[id .. "_2"].GibOffset =
					HBInfo[id].GibOffset * MirrorAxis
				--Health & stage
				HBInfo[id .. "_2"].Health = HBInfo[id].Health
				HBInfo[id .. "_2"].CurHealth =
					HBInfo[id].CurHealth
				HBInfo[id .. "_2"].Stage = HBInfo[id].Stage
			end
		end
		return HBInfo, HBExtra
	else
		return false
	end
end