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
		self:SetNoDraw( true )
		self:SetRenderMode( RENDERMODE_NONE )
		self:GetPhysicsObject():EnableMotion(true)
		self:GetPhysicsObject():Wake()
		self:SetCollisionGroup( COLLISION_GROUP_DEBRIS ) 

		self.RemoveDis = GetConVar("sv_simfphys_gib_lifetime"):GetFloat()

		self.RemoveTimer = CurTime() + self.RemoveDis
		
		--//Color support
		self:SetColor(self.Car:GetColor())
		self:SetSkin(self.Car:GetSkin())
		self.PrxyClr = self.Car:GetProxyColor()
		self.DoNotDuplicate = true
		
		if game.SinglePlayer() then
			if ProxyColor then self:SetProxyColor(self.PrxyClr) end
			self:SetRenderMode( RENDERMODE_TRANSALPHA )
			self:SetNoDraw( false )
		else
			timer.Simple( 0.01, function() 
				if !IsValid(self) then return end 
				if ProxyColor then self:SetProxyColor(self.PrxyClr) end
				self:SetRenderMode( RENDERMODE_TRANSALPHA )
				self:SetNoDraw( false )
			end )
		end
		--//End
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