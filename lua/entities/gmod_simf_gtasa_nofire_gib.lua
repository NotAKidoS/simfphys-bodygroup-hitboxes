AddCSLuaFile()

ENT.Type = "anim"

ENT.Spawnable = false
ENT.AdminSpawnable = false

if SERVER then

    function ENT:Initialize()
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        if not IsValid(self:GetPhysicsObject()) then
            self.RemoveTimer = 0
            self:Remove()
            return
        end

        self:SetNoDraw(true)
        self:SetRenderMode(RENDERMODE_NONE)

        self:GetPhysicsObject():EnableMotion(true)
        self:GetPhysicsObject():Wake()
        self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)

        self.RemoveDis = GetConVar("sv_simfphys_gib_lifetime"):GetFloat()
        self.RemoveTimer = CurTime() + self.RemoveDis
        self.DoNotDuplicate = true

		timer.Simple(0.02, function()
			if not IsValid(self) then return end
			self:SetRenderMode(RENDERMODE_TRANSALPHA)
			self:SetNoDraw(false)
		end)
    end

    function ENT:Think()
        if self.RemoveTimer < CurTime() then
            if self.RemoveDis > 0 then self:Remove() end
        end

        self:NextThink(CurTime() + 0.2)
        return true
    end

    function ENT:OnTakeDamage(dmginfo) self:TakePhysicsDamage(dmginfo) end

    function ENT:PhysicsCollide(data, physobj)
        if (data.Speed > 50 and data.DeltaTime > 0.8) then
            self:EmitSound(self:GetOwner():GetNWString("31simf_snd_impact"))
        end
    end

end
