--written by NotAKidoS, code is shit but it works.
--If you would like to use this in your addon then you may go ahead and do so, 
--BUT rename the functions and convars. I dont want to update my addon and have it conflict.

--Id rather you set this addon as a requirment anyways so you get updates whenever gmod breaks the addon
--but i cant really stop you with text, i doubt you even read all of this.




local Entity = FindMetaTable( "Entity" )


if CLIENT then
	net.Receive("simfphys_gtasa_glassbreak_fx", function(length)
		local self = net.ReadEntity()
		local id = net.ReadString()
		if IsValid( self ) then
			local effectdata = EffectData()
			effectdata:SetOrigin( self:LocalToWorld(self.hbinfo[id].glasspos) )
			util.Effect( "simf_gtasa_glassbreak", effectdata )
		end
	end)
end

if SERVER then
	util.AddNetworkString("NAKSendSimfphysHitbox")
	util.AddNetworkString("simfphys_gtasa_glassbreak_fx")
end

function NAKSpawnGib(self, id)

	local hbinfo = self.hbinfo
	
	if hbinfo[id].curhealth < 0 then return end
	if hbinfo[id].broken then return end
	if hbinfo[id].glass then return end

	if (hbinfo[id].gibmodel) then
		local offset = hbinfo[id].giboffset and hbinfo[id].giboffset or Vector(0,0,0)
		local bprop = ents.Create( "gmod_simf_gtasa_gib" )
		bprop:SetModel( hbinfo[id].gibmodel )
		bprop:SetPos( self:LocalToWorld(offset) ) 
		bprop:SetAngles( self:GetAngles() )
		bprop.Car = self
		bprop:Spawn()
		bprop:Activate()
		hbinfo[id].broken = true
		self.Gib:DeleteOnRemove( bprop )

		local PhysObj = bprop:GetPhysicsObject()
		if IsValid( PhysObj ) then
			PhysObj:SetVelocityInstantaneous( VectorRand() * 500 + self:GetVelocity() + Vector(0,0,math.random(150,250)) )
			PhysObj:AddAngleVelocity( VectorRand() )
		end
	end
end

local function SpawnGib(self, id)

	local hbinfo = self.hbinfo
	if hbinfo[id].broken then return end
	hbinfo[id].broken = true
	
	if hbinfo[id].glass then
		self:EmitSound("Glass.BulletImpact")
		net.Start( "simfphys_gtasa_glassbreak_fx" )
			net.WriteEntity( self )
			net.WriteString( id )
		net.Broadcast()
	end

	if (hbinfo[id].gibmodel) then
		local offset = hbinfo[id].giboffset and hbinfo[id].giboffset or Vector(0,0,0)
		local bprop = ents.Create( "gmod_simf_gtasa_nofire_gib" )
		bprop:SetModel( hbinfo[id].gibmodel )
		bprop:SetPos( self:LocalToWorld(offset) ) 
		bprop:SetAngles( self:GetAngles() )
		bprop.Car = self
		bprop:Spawn()
		bprop:Activate()
		if !game.SinglePlayer() then
			timer.Simple( 0.1, function() 
				if !IsValid(bprop) then return end 
				if ProxyColor then bprop:SetProxyColor(self:GetProxyColor()) end
			end )
		end
		self:CallOnRemove("NAKKillGibsOnRemove" .. bprop:EntIndex(),function(self) 
			if !self.destroyed then if IsValid(bprop) then bprop:Remove() end
			elseif IsValid(self.Gib) then
				if IsValid(bprop) then
					self.Gib:DeleteOnRemove( bprop )
				end
			end 
		end)
	end
end






local function SharedDamage(self, damagePos, dmgAmount, type)
	
	local hbinfo = self.hbinfo
	
	local damagePos = self:WorldToLocal(self:NearestPoint( self:LocalToWorld(damagePos) ))
	
	for id in SortedPairs( hbinfo ) do
		-- print(id)
		-- print(damagePos:WithinAABox( hbinfo[id].min, hbinfo[id].max ))
		if damagePos:WithinAABox( hbinfo[id].min, hbinfo[id].max ) then
			
			-- if hbinfo[id].bdgroup then
				-- print("PART "..hbinfo[id].bdgroup.." WAS HIT")
			-- end
			
			if hbinfo[id].curhealth < 70%hbinfo[id].health && (self:GetBodygroup( hbinfo[id].bdgroup ) + 2) < (self:GetBodygroupCount( hbinfo[id].bdgroup ) ) then
				hbinfo[id].broken = false
				hbinfo[id].curhealth = hbinfo[id].health --if someone changes the bodygroup to new when it is damaged then fix it
			end
			
			
			if hbinfo[id].explode then
				self:ExplodeVehicle()
				return
			end
			
			hbinfo[id].curhealth = hbinfo[id].curhealth - dmgAmount
			
			
			if hbinfo[id].curhealth < 70%hbinfo[id].health then 
				if (self:GetBodygroup( hbinfo[id].bdgroup ) + 2) < (self:GetBodygroupCount( hbinfo[id].bdgroup ) ) then
					self:SetBodygroup( hbinfo[id].bdgroup, (self:GetBodygroup( hbinfo[id].bdgroup ) + 1) )
					if hbinfo[id].glass then
						self:EmitSound("gtasa/sfx/damage_light.wav")
					end
				end
			end
			
			if hbinfo[id].curhealth < 1 then 
				if (self:GetBodygroup( hbinfo[id].bdgroup ) + 1) < (self:GetBodygroupCount( hbinfo[id].bdgroup ) ) then
					if hbinfo[id].broken then return end
					SpawnGib(self, id)
					hbinfo[id].broken = true
				end
				if game.SinglePlayer() then
					self:SetBodygroup( hbinfo[id].bdgroup, (self:GetBodygroup( hbinfo[id].bdgroup ) + 1) )
				else
					timer.Simple( 0.01, function() 
						if !IsValid(self) then return end 
						self:SetBodygroup( hbinfo[id].bdgroup, (self:GetBodygroup( hbinfo[id].bdgroup ) + 1) )
					end )
				end
			end
		end
	end
end

local function OverrideTakeDamage(self,hbinfo)
	--store old function
	self._OnTakeDamage = self.OnTakeDamage

	--define new function
	self.OnTakeDamage  = function(ent, dmginfo) ---START OF FUNCTION
	
		local Damage = dmginfo:GetDamage() 
		local DamagePos = ent:WorldToLocal(dmginfo:GetDamagePosition()) 
		local Type = dmginfo:GetDamageType()

		SharedDamage(ent, DamagePos, Damage, Type)


		self:_OnTakeDamage(dmginfo)
		
	end
end


local function OverridePhysicsDamage(self,hbinfo)

	//store the old built in simfphys function
	self._PhysicsCollide = self.PhysicsCollide
	
	//override the old function to call our code first, then call the old stored one
	
	self.PhysicsCollide  = function(ent, data, physobj) ---START OF FUNCTION
	
		if (data.Speed > 50 && data.DeltaTime > 0.8 ) then
			self:EmitSound( "gtasa/sfx/damage_hvy"..math.random(1,7)..".wav" )
		end
	
		//dont do damage if hitting flesh (player walking into a vehicle)
		if IsValid( data.HitEntity ) then
			if data.HitEntity:IsNPC() or data.HitEntity:IsNextBot() or data.HitEntity:IsPlayer() then
				self:_PhysicsCollide(data, physobj) 
				return
			end
		end
	
		//dont let handheld tin cans hurt the car (the worlds mass is 0, so we make an exeption)
		if ( data.HitObject:GetMass() < 50) then
		
			if ( (data.Speed) > 1000 && data.DeltaTime > 0.2 ) then
				local damagePos = ent:WorldToLocal(data.HitPos)
				SharedDamage(ent, damagePos, data.Speed/12 )
			elseif data.HitEntity:IsWorld() && ( (data.Speed) > 60 && data.DeltaTime > 0.2 ) then
				local damagePos = ent:WorldToLocal(data.HitPos)
				SharedDamage(ent, damagePos, data.Speed/8 )
				-- print("world damage")
			end
			
		elseif ( (data.Speed) > 100 && data.DeltaTime > 0.2 ) then
			local damagePos = ent:WorldToLocal(data.HitPos)
			SharedDamage(ent, damagePos, data.Speed/12 )
		end
		
		//call original function so it can do its sparky thing
		self:_PhysicsCollide(data, physobj) 
	end
end


function Entity:NAKAddHitBoxes(hbinfo)

	self.hbinfo = hbinfo --assigns the hitbox info to the car as a variable


	for id in SortedPairs( hbinfo ) do
		if !hbinfo[id].health then
			hbinfo[id].health = 100
		end
		hbinfo[id].curhealth = hbinfo[id].health
	end
	
	
	OverrideTakeDamage(self,hbinfo)
	-- gun and physics damage is seperate mmmm
	OverridePhysicsDamage(self,hbinfo)
	
	--network stuff so clients can use the debug commands
	if SERVER then
		net.Start("NAKSendSimfphysHitbox")
		net.WriteEntity( self )
		net.WriteTable(hbinfo)
		net.Broadcast()
	end
end



if SERVER then return end

//network stuff for debug menu (possible server convar to disable, so clients cant enable on servers)
net.Receive("NAKSendSimfphysHitbox",function()
	local Entity = net.ReadEntity()
	local NetworkedTable = net.ReadTable()
	Entity.hbinfo = NetworkedTable
end)


//create client convars
CreateClientConVar( "nak_simf_hitboxes",  0, FCVAR_ARCHIVE_XBOX, "Debug Simfphys hitboxes for supported vehicles" )
CreateClientConVar( "nak_simf_hitboxes_filled",  0, FCVAR_ARCHIVE_XBOX, "Filled boxes instead of wireframe?" )
CreateClientConVar( "nak_simf_hitbox_color",  "255 255 255", FCVAR_ARCHIVE_XBOX, "Set a color for the box AS A STRING '255,255,255'" )
CreateClientConVar( "nak_simf_hitbox_alpha",  "200", FCVAR_ARCHIVE_XBOX, "Set the alpha of the hitbox" )

hook.Add( "PostDrawTranslucentRenderables", "nak_simf_hitboxes", function()
	if GetConVar("nak_simf_hitboxes"):GetInt() == 0 then return end
	for k, ent in pairs( ents.GetAll() ) do
		if ( ent:GetClass() == "gmod_sent_vehicle_fphysics_base" ) then
			if (!ent.hbinfo) then return end
			for id in SortedPairs( ent.hbinfo ) do
				local clcolor = util.StringToType( GetConVar("nak_simf_hitbox_color"):GetString(), "Vector" )
				local clalpha = GetConVar("nak_simf_hitbox_alpha"):GetFloat()
				local color = Color(clcolor.x,clcolor.y,clcolor.z,clalpha)	
				render.SetColorMaterial()
				if GetConVar("nak_simf_hitboxes_filled"):GetInt() == 0 then
					render.DrawWireframeBox( ent:GetPos(), ent:GetAngles(), ent.hbinfo[id].min, ent.hbinfo[id].max, color )
				else
					render.DrawBox( ent:GetPos(), ent:GetAngles(), ent.hbinfo[id].min, ent.hbinfo[id].max, color )
				end
			end
		end
	end
end )


