AddCSLuaFile( "notakid/tweaks/client.lua" )
if CLIENT then
	include( "notakid/tweaks/client.lua" )
	return
else
	include("notakid/tweaks/hooks.lua")
	util.AddNetworkString("nak_tweaks_snd_engine_damaged")
	util.AddNetworkString("nak_tweaks_flipped_fire")
end

function NAK.GetTweaks(self)
	local simftweaks = list.Get("nak_simf_tweaks")
    local hastweaklist = IsValid(self) and simftweaks[self:GetSpawn_List()] or false
	return hastweaklist
end

function NAK.InitTweaks(self)
	--get tweak list, if non then stop script
	local TweakList = NAK.GetTweaks(self)
	if not TweakList then return end

	--replace engine start sound
	if TweakList.snd_engine_start then
		NAK.TweakEngineStart(self, TweakList.snd_engine_start)
	end
	--replace wheel skid sounds
	if TweakList.snd_engine_damaged then
		NAK.TweakEngineDamaged(self, TweakList.snd_engine_damaged)
	end
	--replace wheel skid sounds
	if TweakList.skid_sounds then
		NAK.TweakSkid(self, TweakList.skid_sounds)
	end
	
	if TweakList.flipped_tick_check then
		self.nak_flipped_tick_check = true
	end

	if TweakList.snd_reverse_whine then
		NAK.TweakReverseWhine(self, TweakList.snd_reverse_whine)
	end
	
end

--bunch of functions that do stuff

--Tell clients to replace damaged engine sound
function NAK.TweakEngineDamaged(self, snd_engine_damaged)
    net.Start("nak_tweaks_snd_engine_damaged")
		net.WriteEntity(self)
		net.WriteString(snd_engine_damaged)
    net.Broadcast()
end

--Start engine sound (lazy way) - might switch to hook in future
function NAK.TweakEngineStart(self, snd_engine_start)
    self.StartEngine = function(self, bIgnoreSettings)
        if not self:CanStart() then return end
        if not self:EngineActive() then
            if not bIgnoreSettings then self.CurrentGear = 2 end
            if not self.IsInWater or self:GetDoNotStall() then
                self:EmitSound(snd_engine_start)
                self.EngineRPM = self:GetEngineData().IdleRPM
                self.EngineIsOn = 1
            end
        end
    end
end

--Custom skid sounds
function NAK.TweakSkid(self, skid_sounds)
    for i = 1, #self.Wheels do
        local Wheel = self.Wheels[i]
		--replace a sound only if it was listed
        if skid_sounds.snd_skid then Wheel.snd_skid = skid_sounds.snd_skid end
        if skid_sounds.snd_skid_dirt then Wheel.snd_skid_dirt = skid_sounds.snd_skid_dirt end
        if skid_sounds.snd_skid_grass then Wheel.snd_skid_grass = skid_sounds.snd_skid_grass end
    end
end

--Custom skid sounds
function NAK.TweakReverseWhine(self, snd_reverse_whine)
	if not self.nak_snd_reverse_whine then
		self.nak_snd_reverse_whine = CreateSound(self, snd_reverse_whine)
		self.nak_snd_reverse_whine:PlayEx(0, 0)
		self:CallOnRemove("remove_nak_reverse_whine", function()
			if self.nak_snd_reverse_whine then self.nak_snd_reverse_whine:Stop() end
		end)
	end
end

--TODO: need to rethink how kill vehicle code should work, it is very messy

sound.Add({
    name = "NAKGTASAFire",
    channel = CHAN_STATIC,
    volume = 0.8,
    level = 70,
    pitch = {95, 110},
    sound = "gtasa/sfx/fire_loop.wav"
})
sound.Add({
    name = "NAKGTASAFireEng",
    channel = CHAN_STATIC,
    volume = 0.4,
    level = 72,
    pitch = {95, 110},
    sound = "gtasa/sfx/engine_damaged_loop.wav"
})

-- //prolly not good upsidedown damage timer thing stuffs
function NAK.TweakKillVehicle(self)
    net.Start("nak_tweaks_flipped_fire")
		net.WriteEntity(self)
    net.Broadcast()

    self:EmitSound("NAKGTASAFire")
    if self:EngineActive() then self:EmitSound("NAKGTASAFireEng") end

    self:CallOnRemove("NAKGTASAFireSoundRemove", function()
        self:StopSound("NAKGTASAFire")
        self:StopSound("NAKGTASAFireEng")
    end)

    timer.Create("GTASAKillVeh_" .. self:EntIndex(), math.random(4, 5), 1,function()
        if not IsValid(self) then return end
        self:ExplodeVehicle()
    end)
end