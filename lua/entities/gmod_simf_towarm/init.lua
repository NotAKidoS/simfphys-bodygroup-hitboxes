AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')
-- ITS NAMED GMOD_NAK BECAUSE SIMFPHYS THIRD PERSON CAMERA COLLIDES WITH ANYTHING WITHOUT GMOD_
-- local collide = not c:StartWith( "prop_physics" ) and not c:StartWith( "prop_dynamic" ) and not c:StartWith( "prop_ragdoll" ) and not e:IsVehicle() and not c:StartWith( "gmod_" ) and not c:StartWith( "player" )
-- thats the bit of code on the simfphys github that adds the collision for the camera

function ENT:Initialize()
	self:SetModel("models/gtasa/vehicles/towtruck/towtruck_arm.mdl")
	self:PhysicsInit( SOLID_VPHYSICS )     
	-- self:SetMoveType( MOVETYPE_NONE )  
	-- self:SetSolid( SOLID_VPHYSICS )        
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	if self:GetPhysicsObject():IsValid() then
		self:GetPhysicsObject():Wake()
		self:GetPhysicsObject():SetMass(5000)
	end
	self.On = true
	
	self.towhook = ents.Create("gmod_simf_towhook")
	self.towhook:SetPos( self:LocalToWorld(Vector(-75.635,0,49.285) ) )
	self.towhook:SetAngles( self:GetAngles() )
	self.towhook:Spawn()
	self.towhook.towarm = self
	self.towhook:GetPhysicsObject():SetMass(10)
	self:DeleteOnRemove( self.towhook )
	self.towhook:MakePhysicsObjectAShadow(true,true)
	
end


function ENT:OnRemove()
	self:StopSound("Tow_truck_down")
end
	
function ENT:Think( entity )

	constraint.NoCollide( self, self.towhook, 0, 0 ) 
	constraint.NoCollide( self.Car, self.towhook, 0, 0 ) 

	if not self.parent:IsValid() then
		self:Remove()
		return
	end
	
	local MaxBack = 0
	local On = self.On
	local BackWards = self.Posi
	local Down = self.Down
	local IsOn = self.SoundOn
	local MakeSound = false
	if(On && tostring(self.On) != "nil")then
		if(BackWards > MaxBack)then
		BackWards = BackWards - 0.2
		self.Posi = BackWards
		MakeSound = true
		
		end
		if(BackWards < MaxBack + 1)then
			if(self.Down < 20)then
			self.Down = self.Down + 0.6
			Down = self.Down
			MakeSound = true
			end
		end



	end
	
	if(!On && tostring(self.On) != "nil")then
		if(self.Down > 0)then
		self.Down = self.Down - 0.6
		MakeSound = true
		end
		if(BackWards < 0)then
		self.Posi = self.Posi + 0.2
		MakeSound = true
		end
	end
	
	
	if(tostring(self.Car) == "Vehicle [NULL]")then
		self:Remove()
	end
	
	if(MakeSound && !self.SoundOn)then
		self.SoundOn = true
		self:EmitSound( "Tow_truck_down" )
	end
	if(!MakeSound && self.SoundOn)then
		self.SoundOn = false
		self:StopSound("Tow_truck_down")
	end
	
	
	if(tostring(self.Car) != "Vehicle [NULL]")then
		if(self.Down < 0)then
		self.Down = 0
		end
		
		-- print()
		
		self:GetPhysicsObject():UpdateShadow( self.Car:GetVelocity() / 33 + self.Car:GetPhysicsObject():LocalToWorld( Vector(-58.77,0,14.28) ), self.Car:GetAngles() + Angle(-self.Down),0)
	end
	
	-- self.towhook:GetPhysicsObject():UpdateShadow( self.Car:GetVelocity() / 33 + self:LocalToWorld(Vector(-76,0,50)),  self.Car:GetAngles(),0)
	
	self:NextThink( CurTime() )	
	return true
end


