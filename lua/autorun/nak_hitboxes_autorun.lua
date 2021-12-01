--[[
	 _            _  _          _    _
	| |__    ___ | || |  ___   | |_ | |__    ___  _ __  ___
	| '_ \  / _ \| || | / _ \  | __|| '_ \  / _ \| '__|/ _ \
	| | | ||  __/| || || (_) | | |_ | | | ||  __/| |  |  __/
	|_| |_| \___||_||_| \___/   \__||_| |_| \___||_|   \___|

	This base code is written by NotAKid (on steam). Prolly bad ik.

	Please do not redistribute this base code in your addons, contact me first.
	You probably don't want code written by a 16 year old with a smol brain anyways lol.

	Contact:
		NotAKid - Steam
		NotAKidoS#0792 - Discord 

	GitHub:
		https://github.com/NotAKidOnSteam/simfphys-bodygroup-hitboxes

	Disclaimer:
		This is by a kid with little knowledge on the Do's and Don'ts of GLUA, so please do not expect anything to be proper.
		This addon heavily relies on being able to override functions on Simfphys vehicles when spawned. May one day
		cause issues if Simfphys ever has a major update.

	That is all, thank you for reading. -NotAKidoS
--]]
local function loadshared(loadfile)
	AddCSLuaFile(loadfile)
	include(loadfile)
end
loadshared('notakid/tweaks/init.lua')
loadshared('notakid/hitboxes/init.lua')

--load hitboxes for any vehicle if it has a hitbox list
hook.Add( "simfphysOnSpawn", "nak_init_hitboxes", function( self )
	NAK.InitHitboxes(self)
	NAK.InitTweaks(self)
end )

--disable air control tweak
hook.Add( "simfphysAirControl", "nak_disable_aircontrol", function( self )

	-- if self.nak_disable_aircontrol then return false end
end )

--run tick tweak to check if vehicle is flipped over
hook.Add( "simfphysOnTick", "nak_reverse_whine", function( self, Time )
	if not self.nak_snd_reverse_whine then return end
	local Time = CurTime()
	--simfphys Think function handles the nexttick stuff
	if self.NextTick < Time then
		local Gear = self:GetGear()
		if Gear == 1 then
			self.nak_snd_reverse_whine:ChangeVolume(1,0.2)
			self.nak_snd_reverse_whine:ChangePitch(math.Clamp(self:GetRPM()/50,0,100),0.4)
		else
			self.nak_snd_reverse_whine:ChangePitch(0,0.8)
			self.nak_snd_reverse_whine:ChangeVolume(0,0.4)
		end
	end
end )

--run tick tweak to check if vehicle is flipped over
hook.Add( "simfphysOnTick", "nak_flipped_tick_check", function( self, Time )
	if not self.nak_flipped_tick_check then return end
	local Time = CurTime()
	--simfphys Think function handles the nexttick stuff
	if self.NextTick < Time then
		--have not touched this shit code in 2 years, idk how it works
		local CheckAngle = self:GetAngles():Up().z
		if CheckAngle < -0.7 then
			if !self.NAKMarkDeath then
				self.NAKMarkDeath = true
				timer.Create("GTASADanger_"..self:EntIndex(),math.random(3.5, 4.5),1,function()
					NAK.TweakKillVehicle(self)
				end)
			end
		elseif (timer.Exists("GTASADanger_"..self:EntIndex())) then
			timer.Remove("GTASADanger_"..self:EntIndex())
			self.NAKMarkDeath = false
		end
	end
end )