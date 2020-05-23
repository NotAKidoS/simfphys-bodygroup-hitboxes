AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')
-- ITS NAMED GMOD_NAK BECAUSE SIMFPHYS THIRD PERSON CAMERA COLLIDES WITH ANYTHING WITHOUT GMOD_
-- local collide = not c:StartWith( "prop_physics" ) and not c:StartWith( "prop_dynamic" ) and not c:StartWith( "prop_ragdoll" ) and not e:IsVehicle() and not c:StartWith( "gmod_" ) and not c:StartWith( "player" )
-- thats the bit of code on the simfphys github that adds the collision for the camera

function ENT:Initialize()
	self:SetModel("models/gtasa/vehicles/towtruck/towtruck_hook.mdl")
	self:PhysicsInit( SOLID_VPHYSICS )     
	-- self:SetMoveType( MOVETYPE_NONE )  
	self:SetSolid( SOLID_VPHYSICS )        
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	if self:GetPhysicsObject():IsValid() then
		self:GetPhysicsObject():Wake()
		self:GetPhysicsObject():SetMass(20)
	end
	
end
