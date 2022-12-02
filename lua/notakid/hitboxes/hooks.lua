local function SpawnGib(self, GibModel, GibOffset, BDGroup)
    if (GibModel) then
        local offset = GibOffset or Vector(0, 0, 0)
        local TheGib = ents.Create("gmod_simf_gtasa_nofire_gib")
        TheGib:SetModel(GibModel)
        TheGib:SetPos(self:LocalToWorld(offset))
        TheGib:SetAngles(self:GetAngles())
        TheGib:SetColor(self:GetColor())
        TheGib:SetSkin(self:GetSkin())

        local group = self:GetBodygroup(BDGroup)
		TheGib:SetBodygroup(0, group )

        if ProxyColor then
            TheGib:SetProxyColor(self:GetProxyColor())
        end
        TheGib:Spawn()
        TheGib:Activate()
        TheGib:SetOwner(self)
        --make the gibs remove with the car
        self:CallOnRemove(
            "NAKKillGibsOnRemove" .. TheGib:EntIndex(),
            function(self)
                if !self.destroyed then
                    if IsValid(TheGib) then
                        TheGib:Remove()
                    end
                elseif IsValid(self.Gib) then
                    if IsValid(TheGib) then
                        self.Gib:DeleteOnRemove(TheGib)
                    end
                end
            end
        )
    end
end

local function AddBDGroup(self, BDGroup, broken)
    if !broken then
        if istable(BDGroup) then
            for BD in pairs(BDGroup) do
                self:SetBodygroup(BDGroup[BD], (self:GetBodygroup(BDGroup[BD]) + 1))
            end
        else
            self:SetBodygroup(BDGroup, (self:GetBodygroup(BDGroup) + 1))
        end
    else
        if istable(BDGroup) then
            for BD in pairs(BDGroup) do
                self:SetBodygroup(BDGroup[BD], (self:GetBodygroupCount(BDGroup[BD]) - 1))
            end
        else
            self:SetBodygroup(BDGroup, (self:GetBodygroupCount(BDGroup) - 1))
        end
    end
end

local function SharedDamage(self, damagePos, dmgAmount, type)
    local localDamagePos = self:WorldToLocal(damagePos)
    for id in pairs(self.NAKHitboxes) do
        local HBInfo = self.NAKHitboxes
        if localDamagePos:WithinAABox(HBInfo[id].OBBMin, HBInfo[id].OBBMax) then

            --explode from collision (gas tank)
            if HBInfo[id].TypeFlag == 2 then 
                self:ExplodeVehicle()
                break
            end

            --take damage with bit of random
            dmgAmount = dmgAmount * math.random(0.6, 0.9)
            HBInfo[id].CurHealth = math.Clamp((HBInfo[id].CurHealth - dmgAmount), 0, HBInfo[id].Health)

            --90% health stage
            if HBInfo[id].Stage == 0 then
                if HBInfo[id].CurHealth < HBInfo[id].Health * 0.9 then
                    AddBDGroup(self, HBInfo[id].BDGroup)
                    HBInfo[id].Stage = 1
                end
            end

            --Break off stage
            if HBInfo[id].Stage == 1 then
                if HBInfo[id].CurHealth < 1 then
                    HBInfo[id].Stage = 2 --means broken

                    if HBInfo[id].TypeFlag == 1 then
                        self:EmitSound("Glass.BulletImpact")
                        net.Start("nak_glassbreak_fx")
                        net.WriteEntity(self)
                        net.WriteVector(HBInfo[id].ShatterPos)
                        net.Broadcast()
                        AddBDGroup(self, HBInfo[id].BDGroup, true)
                    else
						if HBInfo[id].GibModel then
							SpawnGib(self, HBInfo[id].GibModel, HBInfo[id].GibOffset, HBInfo[id].BDGroup)
						end
                        --timer delay so proxy colors can be networked
                        timer.Simple(
                            0.02,
                            function()
                                if !IsValid(self) then
                                    return
                                end
                                AddBDGroup(self, HBInfo[id].BDGroup, true)
                            end
                        )
                    end
                end
            end
            
        end
    end
end

--thank you Luna for pulling my hook changes- this is so much easier on my brain

--override physicscollide
hook.Add( "simfphysPhysicsCollide", "nak_hitboxes_physicscollide", function(self, data, physobj)
    if !self.NAKHitboxes then return end

    if (!data.HitEntity:IsNPC()) and (!data.HitEntity:IsNextBot()) and (!data.HitEntity:IsPlayer()) then
        local multiplier = 1
        if (!data.HitEntity:IsWorld()) then
            multiplier = (1 - data.HitObject:GetInvMass())
        end
        local damage = data.Speed * 0.1 * multiplier * simfphys.DamageMul
        SharedDamage(self, data.HitPos, damage)
    end
    return nil
end )

--override takedamage
hook.Add( "simfphysOnTakeDamage", "nak_hitboxes_takedamage", function(self, dmginfo )
    if !self.NAKHitboxes then return end

    local damage = dmginfo:GetDamage()
    SharedDamage(self, dmginfo:GetDamagePosition(), damage/10)
    return nil
end )

--reset bodygroups on repair
hook.Add( "simfphysOnRepaired", "nak_hitboxes_repair_bodygroups", function( self )
	if not self.RepairBodygroups then return end
	self:SetBodyGroups(self.RepairBodygroups)
	for id in pairs(self.NAKHitboxes) do
		self.NAKHitboxes[id].Stage = 0
		self.NAKHitboxes[id].CurHealth = self.NAKHitboxes[id].Health
	end
    return nil
end )