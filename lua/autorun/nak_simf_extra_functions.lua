--written by NotAKidoS, code is shit but it works.
--If you would like to use this in your addon then you may go ahead and do so, 
--BUT rename the functions and convars. I dont want to update my addon and have it conflict.

--Id rather you set this addon as a requirment anyways so you get updates whenever gmod breaks the addon
--but i cant really stop you with text, i doubt you even read all of this.

//THE REASON I AM STORING AND RUNNING THE OLD FUNCTIONS INSTEAD OF REPLACING THEM OUTRIGHT IN THE SPAWNLIST FILE IS BECAUSE IF LUNA UPDATES
//OR FIXES SOMETHING THEN THIS ADDON WILL HOPEFULLY NOT BREAK. 

//The VehicleExplode function needs to be replaced entirly though as I can not easily replace the entity it spawns, so that mayyyy
//break eventually, but I will try to implement some sort of way to not override it if it causes trouble.

sound.Add( {
	name = "NAKGTASAFire",
	channel = CHAN_STATIC,
	volume = 0.8,
	level = 70,
	pitch = {95, 110},
	sound = "gtasa/sfx/fire_loop.wav"
} )
sound.Add( {
	name = "NAKGTASAFireEng",
	channel = CHAN_STATIC,
	volume = 0.4,
	level = 72,
	pitch = {95, 110},
	sound = "gtasa/sfx/engine_damaged_loop.wav"
} )

if CLIENT then
	net.Receive("simf_dmgengine_sound", function(length)
		local self = net.ReadEntity()
		local snd = net.ReadString()
		if IsValid( self ) then
			self.DamageSnd = CreateSound(self, snd)
		end
	end)
	
	net.Receive("nakkillveh_fire", function(length)
		local self = net.ReadEntity()
		if IsValid( self ) then
			local delay = 0.1
			local nextOccurance = 0
			
			hook.Add( "Think", "nakkillveh_fire_" .. self:EntIndex(), function()
				local timeLeft = nextOccurance - CurTime()
				if timeLeft > 0 then return end
				if IsValid(self) then
					local effectdata = EffectData()
					effectdata:SetOrigin( self:GetEnginePos() + Vector(0,0,25) )
					effectdata:SetEntity( self )
					util.Effect( "simf_gtasa_fire", effectdata )
					nextOccurance = CurTime() + delay
				else
					hook.Remove( "Think", "nakkillveh_fire_" .. self:EntIndex() )
				end
			end )
		end
	end)
end

if SERVER then util.AddNetworkString( "simf_dmgengine_sound" ) end
if SERVER then util.AddNetworkString( "nakkillveh_fire" ) end



local Entity = FindMetaTable( "Entity" )

function Entity:NAKDmgEngineSnd(snd)
	net.Start( "simf_dmgengine_sound" )
		net.WriteEntity( self )
		net.WriteString( snd )
	net.Broadcast()
end

function Entity:NAKSimfSkidSounds(wheelsnds)

	if wheelsnds == nil then 
		wheelsnds = {}
		wheelsnds.snd_skid = "gtasa/sfx/tireskid.wav"
		wheelsnds.snd_skid_dirt = "gtasa/sfx/tire_dirt.wav"
		wheelsnds.snd_skid_grass = "gtasa/sfx/tire_grass.wav"
	end

	for i = 1, table.Count( self.Wheels ) do
		local Wheel = self.Wheels[i]
		Wheel.snd_skid = wheelsnds.snd_skid
		Wheel.snd_skid_dirt = wheelsnds.snd_skid_dirt
		Wheel.snd_skid_grass = wheelsnds.snd_skid_grass
	end

end


function Entity:NAKSimfEngineStart(snd)

	//--store the old built in simfphys function
	self._StartEngine = self.StartEngine
	
	//--override the old function to call our code first, then call the old stored one
	
	self.StartEngine  = function(self) ---START OF FUNCTION

		if not self:CanStart() then return end
		
		if not self:EngineActive() then
			if not bIgnoreSettings then
				self.CurrentGear = 2
			end
			self:EmitSound( snd )
			if not self.IsInWater then
				self.EngineRPM = self:GetEngineData().IdleRPM
				self.EngineIsOn = 1
			else
				if self:GetDoNotStall() then
					self.EngineRPM = self:GetEngineData().IdleRPM
					self.EngineIsOn = 1
				end
			end
		end
	end

end

function Entity:NAKSimfCustomExplode()


	//--store the old built in simfphys function
	-- self._ExplodeVehicle = self.ExplodeVehicle
	
	//--override the old function to call our code first, then call the old stored one
	
	self.ExplodeVehicle  = function(self) ---START OF FUNCTION
	
		if not IsValid( self ) then return end
		if self.destroyed then return end
		
		self.destroyed = true

		local ply = self.EntityOwner
		local skin = self:GetSkin()
		local Col = self:GetColor()
		local prxyClr
		if ProxyColor then
			prxyClr = self:GetProxyColor()
		end
		Col.r = Col.r * 0.8
		Col.g = Col.g * 0.8
		Col.b = Col.b * 0.8
		
		if self.GibModels then
			local bprop = ents.Create( "gmod_simf_gtasa_gib" )
			bprop:SetModel( self.GibModels[1] )
			bprop:SetPos( self:GetPos() )
			bprop:SetAngles( self:GetAngles() )
			bprop.MakeSound = true
			bprop.Car = self
			bprop:Spawn()
			bprop:Activate()
			bprop:GetPhysicsObject():SetVelocity( self:GetVelocity() + Vector(math.random(-5,5),math.random(-5,5),math.random(150,250)) ) 
			bprop:GetPhysicsObject():SetMass( self.Mass * 0.75 )
			bprop.DoNotDuplicate = true
			bprop:SetColor( Col )
			if ProxyColor then bprop:SetProxyColor(prxyClr) end
			bprop:SetSkin( skin )
			
			self.Gib = bprop
			
			simfphys.SetOwner( ply , bprop )
			
			if IsValid( ply ) then
				undo.Create( "Gib" )
				undo.SetPlayer( ply )
				undo.AddEntity( bprop )
				undo.SetCustomUndoText( "Undone Gib" )
				undo.Finish( "Gib" )
				ply:AddCleanup( "Gibs", bprop )
			end
			
			for i = 2, table.Count( self.GibModels ) do
				local prop = ents.Create( "gmod_simf_gtasa_gib" )
				prop:SetModel( self.GibModels[i] )			
				prop:SetPos( self:GetPos() )
				prop:SetAngles( self:GetAngles() )
				prop:SetOwner( bprop )
				prop.Car = self
				prop:Spawn()
				prop:Activate()
				bprop:DeleteOnRemove( prop )
				
				local PhysObj = prop:GetPhysicsObject()
				if IsValid( PhysObj ) then
					PhysObj:SetVelocityInstantaneous( VectorRand() * 500 + self:GetVelocity() + Vector(0,0,math.random(150,250)) )
					PhysObj:AddAngleVelocity( VectorRand() )
				end
				
				
				simfphys.SetOwner( ply , prop )
			end
		else
			
			local bprop = ents.Create( "gmod_simf_gtasa_gib" )
			bprop:SetModel( self:GetModel() )			
			bprop:SetPos( self:GetPos() )
			bprop:SetAngles( self:GetAngles() )
			bprop.MakeSound = true
			bprop.Car = self
			bprop:Spawn()
			bprop:Activate()
			bprop:GetPhysicsObject():SetVelocity( self:GetVelocity() + Vector(math.random(-5,5),math.random(-5,5),math.random(150,250)) ) 
			bprop:GetPhysicsObject():SetMass( self.Mass * 0.75 )
			
			self.Gib = bprop
			
			simfphys.SetOwner( ply , bprop )
			
			if IsValid( ply ) then
				undo.Create( "Gib" )
				undo.SetPlayer( ply )
				undo.AddEntity( bprop )
				undo.SetCustomUndoText( "Undone Gib" )
				undo.Finish( "Gib" )
				ply:AddCleanup( "Gibs", bprop )
			end
			
			if self.CustomWheels == true and not self.NoWheelGibs then
				for i = 1, table.Count( self.GhostWheels ) do
					local Wheel = self.GhostWheels[i]
					if IsValid(Wheel) then
						local prop = ents.Create( "gmod_sent_vehicle_fphysics_gib" )
						prop:SetModel( Wheel:GetModel() )			
						prop:SetPos( Wheel:LocalToWorld( Vector(0,0,0) ) )
						prop:SetAngles( Wheel:LocalToWorldAngles( Angle(0,0,0) ) )
						prop:SetOwner( bprop )
						prop:Spawn()
						prop:Activate()
						prop:GetPhysicsObject():SetVelocity( self:GetVelocity() + Vector(math.random(-5,5),math.random(-5,5),math.random(0,25)) )
						prop:GetPhysicsObject():SetMass( 20 )
						prop.DoNotDuplicate = true
						bprop:DeleteOnRemove( prop )
						
						simfphys.SetOwner( ply , prop )
					end
				end
			end
		end
		
		for id in SortedPairs( self.hbinfo ) do
			NAKSpawnGib(self, id)
		end
		

		local Driver = self:GetDriver()
		if IsValid( Driver ) then
			if self.RemoteDriver ~= Driver then
				Driver:TakeDamage( Driver:Health() + Driver:Armor(), self.LastAttacker or Entity(0), self.LastInflictor or Entity(0) )
			end
		end
		
		if self.PassengerSeats then
			for i = 1, table.Count( self.PassengerSeats ) do
				local Passenger = self.pSeat[i]:GetDriver()
				if IsValid( Passenger ) then
					Passenger:TakeDamage( Passenger:Health() + Passenger:Armor(), self.LastAttacker or Entity(0), self.LastInflictor or Entity(0) )
				end
			end
		end

		self:Extinguish() 
		
		self:OnDestroyed()
		
		self:Remove()
	end
end

function Entity:NAKKillVehicle()

	net.Start( "nakkillveh_fire" )
		net.WriteEntity( self )
	net.Broadcast()
	
	self:EmitSound( "NAKGTASAFire" )
	if self:EngineActive() then
		self:EmitSound( "NAKGTASAFireEng" )
	end
	self:CallOnRemove( "NAKGTASAFireSoundRemove", function() self:StopSound( "NAKGTASAFire" ) self:StopSound( "NAKGTASAFireEng" ) end)
	
	timer.Create( "GTASAKillVeh_" .. self:EntIndex(), math.random(4,5), 1, function()
		if !IsValid(self) then return end
		self:ExplodeVehicle()
	end)
end




function Entity:NAKSimfFireTime(Danger)

	if Danger then
		if !self.NAKUpsideDownDanger then
			self.NAKUpsideDownDanger = true
			timer.Create( "GTASADanger_" .. self:EntIndex(), math.random(3.5,4.5), 1, function()
				if !IsValid(self) then return end
				if !self.NAKUpsideDownDanger then return end
				self:NAKKillVehicle()
			end)
		end
	else
		self.NAKUpsideDownDanger = false
	end
	
end

function Entity:NAKSimfUpsideDownFire()

	//--store the old built in simfphys function
	self._OnTick = self.OnTick
	
	//--override the old function to call our code first, then call the old stored one
	
	self.OnTick  = function(self) ---START OF FUNCTION
	
		if self:GetAngles():Up().z < -0.7 then
			self:NAKSimfFireTime(true)
		else
			self:NAKSimfFireTime(false)
		end
		
		if self:GetGear() == 1 then
			self.ReverseSound:ChangeVolume( 1, 0.2 )
			self.ReverseSound:ChangePitch( math.Clamp(self:GetRPM()/50,0,100), 0.4 )
		elseif self.ReverseSound then
			self.ReverseSound:ChangePitch( 0, 0.8 )
			self.ReverseSound:ChangeVolume( 0, 0.4 )
		end
		
		self:_OnTick()
	end
	
	self:CallOnRemove( "RevSound", function() if self.ReverseSound then self.ReverseSound:Stop() end end)

end

local function NAKPlayEMSRadio(self)

	if !IsValid(self) then return end
	
	local filter = RecipientFilter()
	
	if IsValid(self:GetDriver()) then
		filter:AddPlayer( self:GetDriver() )
	end
	if self.PassengerSeats then
		for i = 1, table.Count( self.PassengerSeats ) do
			local Passenger = self.pSeat[i]:GetDriver()
			if IsValid(Passenger) then
				filter:AddPlayer( Passenger )
			end
		end
	end
	
	self.NAKEMSRadio = CreateSound(self, "gtasa/sfx/police_radio/police_radio"..math.random(1,53)..".wav", filter )
	self.NAKEMSRadio:SetSoundLevel( 100 )
	self.NAKEMSRadio:PlayEx( 2, 100 )
	timer.Create( "NAKGTASA_EMSRadio_" .. self:EntIndex(), math.random(20,45), 1, function()
		NAKPlayEMSRadio(self)
	end)
end

function Entity:NAKSimfEMSRadio()
	timer.Create( "NAKGTASA_EMSRadio_" .. self:EntIndex(), 1, 1, function()
		NAKPlayEMSRadio(self)
	end)
end




--MAIN GLOBAL FUNCTION TO APPLY MOST IF NOT ALL OF THESE TO ALL VEHICLES
--(i can update this function to apply to all vehicles using it)

function Entity:NAKSimfGTASA()

	if !self.ReverseSound then
		self.ReverseSound = CreateSound(self, "gtasa/vehicles/reverse_gear.wav")
		self.ReverseSound:PlayEx(0,0)
	end

	self:NAKSimfSkidSounds() -- replaces the wheel skid sounds
	self:NAKSimfEngineStart("gtasa/sfx/engine_start.wav")
	self:NAKSimfCustomExplode()
	self:NAKDmgEngineSnd("gtasa/sfx/engine_damaged_loop.wav")
	self:NAKSimfUpsideDownFire()

end