AddCSLuaFile()

ENT.Type            = "anim"

ENT.Spawnable       = false
ENT.AdminSpawnable  = false

if SERVER then
	
	function ENT:Initialize()
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		
		if not IsValid( self:GetPhysicsObject() ) then
			self.RemoveTimer = 0
			self:Remove()
			return
		end
		
		self:GetPhysicsObject():EnableMotion(true)
		self:GetPhysicsObject():Wake()
		self:SetCollisionGroup( COLLISION_GROUP_DEBRIS ) 
		self:SetRenderMode( RENDERMODE_TRANSALPHA )

		self.RemoveDis = GetConVar("sv_simfphys_gib_lifetime"):GetFloat()

		self.RemoveTimer = CurTime() + self.RemoveDis
	end

	function ENT:Think()	
		if self.RemoveTimer < CurTime() then
			if self.RemoveDis > 0 then
				self:Remove()
			end
		end
		
		self:NextThink( CurTime() + 0.2 )
		return true
	end

	function ENT:OnTakeDamage( dmginfo )
		self:TakePhysicsDamage( dmginfo )
	end

	function ENT:PhysicsCollide( data, physobj )
		if (data.Speed > 50 && data.DeltaTime > 0.8 ) then
			self:EmitSound( "gtasa/sfx/damage_hvy"..math.random(3,5)..".wav" )
		end
	end
end