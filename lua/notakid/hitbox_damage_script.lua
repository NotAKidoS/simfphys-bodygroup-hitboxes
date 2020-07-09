--[[

	This is the base for the damage script, I am trying my best to make it easy to use & usable for most things.
	Written by NotAKidoS
--]]

--//Client stuff
if CLIENT then
	net.Receive("simfphys_gtasa_glassbreak_fx", function(length)
		local self = net.ReadEntity()
		local ShatterPos = net.ReadVector()
		if IsValid( self ) then
			local effectdata = EffectData()
			effectdata:SetOrigin( self:LocalToWorld( ShatterPos ) )
			util.Effect( "simf_gtasa_glassbreak", effectdata )
		end
	end)
end

if CLIENT then return end

util.AddNetworkString("NAKSendSimfphysHitbox")
util.AddNetworkString("simfphys_gtasa_glassbreak_fx")


local function SpawnGib(self, GibModel, GibOffset)

	if (GibModel) then
		local offset = GibOffset or Vector(0,0,0)
		local TheGib = ents.Create( "gmod_simf_gtasa_nofire_gib" )
		TheGib:SetModel( GibModel )
		TheGib:SetPos( self:LocalToWorld( offset ) ) 
		TheGib:SetAngles( self:GetAngles() )
		TheGib.Car = self
		TheGib:Spawn()
		TheGib:Activate()
		
		--//make the gibs remove with the car
		self:CallOnRemove("NAKKillGibsOnRemove" .. TheGib:EntIndex(),function(self) 
			if !self.destroyed then if IsValid(TheGib) then TheGib:Remove() end
			elseif IsValid(self.Gib) then
				if IsValid(TheGib) then
					self.Gib:DeleteOnRemove( TheGib )
				end
			end 
		end)
	end
end




local function AddBDGroup(self, BDGroup)
	
	if istable(BDGroup) then
		for BD in SortedPairs( BDGroup ) do
			self:SetBodygroup( BDGroup[BD], (self:GetBodygroup( BDGroup[BD] ) + 1) )
		end
	else
		self:SetBodygroup( BDGroup, (self:GetBodygroup( BDGroup ) + 1) )
	end
end

local function SharedDamage(self, damagePos, dmgAmount, type)
	-- print("Vehicle Damaged")
	local HBInfo = self.NAKHitboxes
	for id in SortedPairs( HBInfo ) do
		if damagePos:WithinAABox( HBInfo[id].OBBMin, HBInfo[id].OBBMax ) then

			--//Check for special damage areas
			if HBInfo[id].TypeFlag == 2 then -- Explode collisions
				self:ExplodeVehicle()
				return
			end
			
			--//Take damage
			HBInfo[id].CurHealth = math.Clamp( (HBInfo[id].CurHealth - dmgAmount), 0, HBInfo[id].Health )
			print(HBInfo[id].CurHealth)
			
			--//70% health stage
			if HBInfo[id].Stage == 0 then
				if HBInfo[id].CurHealth < 70%HBInfo[id].Health then
					AddBDGroup(self, HBInfo[id].BDGroup)
					HBInfo[id].Stage = 1
				end
			end
			--//Break off stage
			if HBInfo[id].Stage == 1 then
				if HBInfo[id].CurHealth < 1 then
					AddBDGroup(self, HBInfo[id].BDGroup)
					HBInfo[id].Stage = 2 --means broken
					
					if HBInfo[id].TypeFlag == 1 then
						self:EmitSound("Glass.BulletImpact")
						net.Start( "simfphys_gtasa_glassbreak_fx" )
							net.WriteEntity( self )
							net.WriteVector( HBInfo[id].ShatterPos )
						net.Broadcast()
					else
						SpawnGib(self, HBInfo[id].GibModel, HBInfo[id].GibOffset)
					end
				end
			end

			print("Bodypanel "..id.." hit")
		end
	end
end

local function OverrideTakeDamage(self)
	--store old function
	self.NAKOnTakeDamage = self.OnTakeDamage
	--define new function
	self.OnTakeDamage  = function(ent, dmginfo) ---START OF FUNCTION
	
		local Damage = dmginfo:GetDamage() 
		local DamagePos = ent:WorldToLocal( dmginfo:GetDamagePosition() ) 
		local Type = dmginfo:GetDamageType()

		SharedDamage(ent, DamagePos, Damage, Type)

		self:NAKOnTakeDamage(dmginfo)
	end
end


local function OverridePhysicsDamage(self,HBInfo)

	self.NAKHBPhysicsCollide = self.PhysicsCollide --//store the old built in simfphys function
	
	self.PhysicsCollide  = function(ent, data, physobj) --//override the old function to call our code first, then call the old stored one
		--//The damage sound from GTASA
		if (data.Speed > 50 && data.DeltaTime > 0.8 ) then
			self:EmitSound( "gtasa/sfx/damage_hvy"..math.random(1,7)..".wav" )
		end
		--//dont do damage if hitting flesh (player walking into a vehicle)
		if IsValid( data.HitEntity ) then
			if data.HitEntity:IsNPC() or data.HitEntity:IsNextBot() or data.HitEntity:IsPlayer() then
				self:NAKHBPhysicsCollide(data, physobj) 
				return
			end
		end
		
		local damagePos = ent:WorldToLocal( ent:NearestPoint( data.HitPos ) )
		
		--//dont let handheld tin cans hurt the car (the worlds mass is 0, so we make an exeption)
		if ( data.HitObject:GetMass() < 50) then
			if ( (data.Speed) > 1000 && data.DeltaTime > 0.2) && !data.HitEntity:IsWorld() then
				SharedDamage(ent, damagePos, data.Speed/10 )
			elseif data.HitEntity:IsWorld() && ( (data.Speed) > 60 && data.DeltaTime > 0.2 ) then
				SharedDamage(ent, damagePos, data.Speed/6 )
			end
		elseif ( (data.Speed) > 100 && data.DeltaTime > 0.2 ) then
			SharedDamage(ent, damagePos, data.Speed/10 )
		end
		--//call original function so it can do its sparky thing
		self:NAKHBPhysicsCollide(data, physobj) 
	end
end

function NAKSpawnGibs(self, prxyClr)

	local HBInfo = self.NAKHitboxes
	
	for id in SortedPairs( HBInfo ) do
		
		if HBInfo[id].Stage == 2 then break end
		
		if (HBInfo[id].GibModel) then
			local offset = HBInfo[id].GibOffset or Vector(0,0,0)
			local TheExtraGibs = ents.Create( "gmod_simf_gtasa_gib" )
			TheExtraGibs:SetModel( HBInfo[id].GibModel )
			TheExtraGibs:SetPos( self:LocalToWorld(offset) ) 
			TheExtraGibs:SetAngles( self:GetAngles() )
			TheExtraGibs.Car = self
			TheExtraGibs:Spawn()
			TheExtraGibs:Activate()
			
			if (self.GetProxyColor) then TheExtraGibs:SetProxyColor(prxyClr) end
			
			self.Gib:DeleteOnRemove( TheExtraGibs )

			local PhysObj = TheExtraGibs:GetPhysicsObject()
			if IsValid( PhysObj ) then
				PhysObj:SetVelocityInstantaneous( VectorRand() * 500 + self:GetVelocity() + Vector(0,0,math.random(150,250)) )
				PhysObj:AddAngleVelocity( VectorRand() )
			end
		end
	end
end


--[[
	This bit of the code applies the altered functions above to the vehicle, and also sets any values we need for later
	CurHealth, Stage, and mirroring hitboxes is done here.
--]]

local Entity = FindMetaTable( "Entity" )

--//CUSTOM EXPLODE FUNCTIONNNN

function Entity:NAKSimfCustomExplode()

	self.ExplodeVehicle  = function(self) ---START OF FUNCTION
	
		if not IsValid( self ) then return end
		if self.destroyed then return end
		
		self.destroyed = true

		local ply = self.EntityOwner
		local skin = self:GetSkin()
		local Col = self:GetColor()
		local prxyClr
		if (self.GetProxyColor) then
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
			if (self.GetProxyColor) then bprop:SetProxyColor(prxyClr) end
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
		--// this bit spawns the gibs still on the car
		if self.NAKHitboxes then
			NAKSpawnGibs(self, prxyClr)
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

function Entity:NAKHitboxDmg() 
	
	--//Mirrors any needed hitboxes
	for id in SortedPairs( self.NAKHitboxes ) do
		--//Set current health, unless it is added by the mod maker
		self.NAKHitboxes[id].CurHealth = self.NAKHitboxes[id].CurHealth or self.NAKHitboxes[id].Health
		self.NAKHitboxes[id].Stage = self.NAKHitboxes[id].Stage or 0
		
		if self.NAKHitboxes[id].Mirror then
			print("MIRROR THIS "..id)
			
			local MirrorAxis = self.NAKHitboxes[id].Mirror
			self.NAKHitboxes[id.."_2"] = {}
			
			self.NAKHitboxes[id.."_2"].OBBMin = self.NAKHitboxes[id].OBBMin * MirrorAxis
			self.NAKHitboxes[id.."_2"].OBBMax = self.NAKHitboxes[id].OBBMax * MirrorAxis
			
			self.NAKHitboxes[id.."_2"].TypeFlag = self.NAKHitboxes[id].TypeFlag
			
			self.NAKHitboxes[id.."_2"].BDGroup = self.NAKHitboxes[id].BDGroup_2
			self.NAKHitboxes[id.."_2"].GibModel = self.NAKHitboxes[id].GibModel_2
			self.NAKHitboxes[id.."_2"].GibOffset = self.NAKHitboxes[id].GibOffset * MirrorAxis
			self.NAKHitboxes[id.."_2"].Health = self.NAKHitboxes[id].Health
			
			--//Mirror current health & stage
			self.NAKHitboxes[id.."_2"].CurHealth = self.NAKHitboxes[id].CurHealth
			self.NAKHitboxes[id.."_2"].Stage = self.NAKHitboxes[id].Stage
		end
	end
	
	-- PrintTable(self.NAKHitboxes)
	
	OverridePhysicsDamage(self)
	OverrideTakeDamage(self)
	self:NAKSimfCustomExplode()
end