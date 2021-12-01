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