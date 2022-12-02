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
	--A31 & Tensor patch
	if TweakList.snd_explosion_sound then
		NAK.TweakExplosionSound(self, TweakList.snd_explosion_sound)
	end
	if TweakList.snd_collision then
		NAK.TweakImpactSounds(self, TweakList.snd_collision)
	end
	--replace wheel skid sounds
	if TweakList.snd_engine_damaged then
		NAK.TweakEngineDamaged(self, TweakList.snd_engine_damaged)
	end
	--replace wheel skid sounds
	if TweakList.skid_sounds then
		NAK.TweakSkid(self, TweakList.skid_sounds)
	end
	--add flipped vehicle check
	if TweakList.flipped_tick_check then
		self.nak_flipped_tick_check = true
	end
	--allow disabling aircontrol
	if TweakList.disable_air_control then
		self.nak_disable_aircontrol = true
	end
	--add reverse whine to vehicle
	if TweakList.snd_reverse_whine then
		NAK.TweakReverseWhine(self, TweakList.snd_reverse_whine)
	end
	--change ghost wheel model scale
	if TweakList.ghostwheel_scale then
		NAK.TweakGhostWheelScale(self, TweakList.ghostwheel_scale)
	end	
	--change wheel smoke color (why this not in simfphys by default..)ò
	if TweakList.tiresmoke_color then
		self:SetTireSmokeColor(TweakList.tiresmoke_color:ToVector())
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

--TENSOR and ALIEN patches
function NAK.TweakExplosionSound(self, snd_explosion_sound)
	self:SetNWString("31simf_snd_explosion", snd_explosion_sound)
end

function NAK.TweakFireSound(self, snd_fire)
	self.nak_snd_fire = snd_fire
end

function NAK.TweakImpactSounds(self, snd_collision)
	self.nak_snd_collision = true
	self.nak_snd_soft_impact = snd_collision.snd_soft_impact
	self.nak_snd_hard_impact = snd_collision.snd_hard_impact
	self.nak_snd_flesh_impact = snd_collision.snd_flesh_impact
end

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

--Custom wheel model scale
function NAK.TweakGhostWheelScale(self, gw_list)
	
	local slist = self:GetSpawn_List()
	local vlist = list.Get( "simfphys_vehicles" )
	
	if vlist[slist].Members.CustomWheels then
		--scale each wheel
		self.GhostWheels[1]:SetModelScale( gw_list.fl_scale[1], gw_list.fl_scale[2], gw_list.fl_scale[3] )
		self.GhostWheels[2]:SetModelScale( gw_list.fr_scale[1], gw_list.fr_scale[2], gw_list.fr_scale[3] )
		self.GhostWheels[3]:SetModelScale( gw_list.rl_scale[1], gw_list.rl_scale[2], gw_list.rl_scale[3] )
		self.GhostWheels[4]:SetModelScale( gw_list.rr_scale[1], gw_list.rr_scale[2], gw_list.rr_scale[3] )
		
		if self.CustomWheelPosML then
			self.GhostWheels[5]:SetModelScale( gw_list.ml_scale[1], gw_list.ml_scale[2], gw_list.ml_scale[3] )
			self.GhostWheels[6]:SetModelScale( gw_list.mr_scale[1], gw_list.mr_scale[2], gw_list.mr_scale[3] )
		end
	else
		print("NAKTweaks: Error, ghostwheel_scale defined when theres no CustomWheels!")
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

--prolly not good upsidedown damage timer thing stuffs
function NAK.TweakKillVehicle(self)
	if !IsValid(self) then return end

    net.Start("nak_tweaks_flipped_fire")
		net.WriteEntity(self)
    net.Broadcast()

    self:EmitSound("NAK_GTASA.Fire")
    if self:EngineActive() then self:EmitSound("NAKGTASAFireEng") end

    self:CallOnRemove("NAKGTASAFireSoundRemove", function()
        self:StopSound("NAK_GTASA.Fire")
        self:StopSound("NAKGTASAFireEng")
    end)

    timer.Create("GTASAKillVeh_" .. self:EntIndex(), math.random(4, 5), 1,function()
        if not IsValid(self) then return end
        self:ExplodeVehicle()
    end)
end