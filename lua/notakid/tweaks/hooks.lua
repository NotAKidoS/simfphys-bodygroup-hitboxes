--disable air control tweak
hook.Add( "simfphysAirControl", "nak_tweaks_disable_aircontrol", function( self )
	if self.nak_disable_aircontrol then 
		return true 
	end
end )

--run tick tweak to check if vehicle is flipped over
hook.Add( "simfphysOnTick", "nak_reverse_whine", function( self, Time )
	if not self.nak_snd_reverse_whine then return end
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
	return nil
end )

--run tick tweak to check if vehicle is flipped over
hook.Add( "simfphysOnTick", "nak_tweaks_flipped_tick_check", function( self, Time )
	if not self.nak_flipped_tick_check then return end
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
	return nil
end )

--custom collision sounds

local function Collide( pos , normal , snd )
	local effectdata = EffectData()
	effectdata:SetOrigin( pos - normal )
	effectdata:SetNormal( -normal )
	util.Effect( "stunstickimpact", effectdata, true, true )
	
	if snd then
		sound.Play( Sound( snd ), pos, 75)
	end
end

hook.Add( "simfphysPhysicsCollide", "nak_tweaks_collision_snds", function(self, data, physobj)
    if !self.nak_snd_collision then return end

	if IsValid( data.HitEntity ) then
		if data.HitEntity:IsNPC() or data.HitEntity:IsNextBot() or data.HitEntity:IsPlayer() then
			Collide( data.HitPos , data.HitNormal , self.nak_snd_flesh_impact )
			return
		end
	end
	
	if ( data.Speed > 60 && data.DeltaTime > 0.2 ) then
		
		local pos = data.HitPos
		
		if (data.Speed > 1000) then
			Collide( pos , data.HitNormal , self.nak_snd_hard_impact )
			self:HurtPlayers( 5 )
			self:TakeDamage( (data.Speed / 7) * simfphys.DamageMul, Entity(0), Entity(0) )
		else
			Collide( pos , data.HitNormal , self.nak_snd_soft_impact )
			
			if data.Speed > 250 then
				local hitent = data.HitEntity:IsPlayer()
				if not hitent then
					if simfphys.DamageMul > 1 then
						self:TakeDamage( (data.Speed / 28) * simfphys.DamageMul, Entity(0), Entity(0) )
					end
				end
			end
			
			if data.Speed > 500 then
				self:HurtPlayers( 2 )
				self:TakeDamage( (data.Speed / 14) * simfphys.DamageMul, Entity(0), Entity(0) )
			end
		end
	end
    return nil
end )