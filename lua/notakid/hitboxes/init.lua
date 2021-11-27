--[[
	Init file, sets things up for client and server
]]

AddCSLuaFile("notakid/hitboxes/client.lua")
AddCSLuaFile("notakid/hitboxes/shared.lua")
include("notakid/hitboxes/shared.lua")
if CLIENT then
    include("notakid/hitboxes/client.lua")
    return
end

--Rest of code is SERVER only
NAK = istable(NAK) and NAK or {}
util.AddNetworkString("nak_glassbreak_fx")

local function SpawnGibExploded(self, skin, Col, PxyClr, HBInfo)
    for id in SortedPairs(HBInfo) do
        if HBInfo[id].Stage == 2 then
            break
        end
        if (HBInfo[id].GibModel) then
            local offset = HBInfo[id].GibOffset or Vector(0, 0, 0)
            local TheExtraGibs = ents.Create("gmod_simf_gtasa_gib")
            TheExtraGibs:SetModel(HBInfo[id].GibModel)
            TheExtraGibs:SetPos(self:LocalToWorld(offset))
            TheExtraGibs:SetAngles(self:GetAngles())
            TheExtraGibs:SetColor(Col)
            TheExtraGibs:SetSkin(skin)
            if ProxyColor then
                TheExtraGibs:SetProxyColor(PxyClr)
            end
            TheExtraGibs:Spawn()
            TheExtraGibs:Activate()

            self.Gib:DeleteOnRemove(TheExtraGibs)

            local PhysObj = TheExtraGibs:GetPhysicsObject()
            if IsValid(PhysObj) then
                PhysObj:SetVelocityInstantaneous(
                    VectorRand() * 500 + self:GetVelocity() + Vector(0, 0, math.random(150, 250))
                )
                PhysObj:AddAngleVelocity(VectorRand())
            end
        end
    end
end

local function SpawnGib(self, GibModel, GibOffset)
    if (GibModel) then
        local offset = GibOffset or Vector(0, 0, 0)
        local TheGib = ents.Create("gmod_simf_gtasa_nofire_gib")
        TheGib:SetModel(GibModel)
        TheGib:SetPos(self:LocalToWorld(offset))
        TheGib:SetAngles(self:GetAngles())
        TheGib:SetColor(self:GetColor())
        TheGib:SetSkin(self:GetSkin())
        if ProxyColor then
            TheGib:SetProxyColor(self:GetProxyColor())
        end
        TheGib:Spawn()
        TheGib:Activate()
        --make the gibs remove with the car
        self:CallOnRemove(
            "NAKKillGibsOnRemove" .. TheGib:EntIndex(),
            function(self)
                if not self.destroyed then
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

local function OverrideExplode(self)
    self.ExplodeVehicle = function(self)
        if not IsValid(self) then
            return
        end
        if self.destroyed then
            return
        end
        self.destroyed = true

        local ply = self.EntityOwner
        local skin = self:GetSkin()
        local Col = self:GetColor()
        local PxyClr = self:GetProxyColor()
        local HBInfo = self.NAKHitboxes
        -- Col.r = Col.r * 0.8
        -- Col.g = Col.g * 0.8
        -- Col.b = Col.b * 0.8

        if self.GibModels then
            local bprop = ents.Create("gmod_simf_gtasa_gib")
            bprop:SetModel(self.GibModels[1])
            bprop:SetPos(self:GetPos())
            bprop:SetAngles(self:GetAngles())
            bprop.MakeSound = true
            bprop:Spawn()
            bprop:Activate()
            bprop:GetPhysicsObject():SetVelocity(
                self:GetVelocity() + Vector(math.random(-5, 5), math.random(-5, 5), math.random(150, 250))
            )
            bprop:GetPhysicsObject():SetMass(self.Mass * 0.75)
            bprop.DoNotDuplicate = true
            bprop:SetColor(Col)
            bprop:SetSkin(skin)
            if ProxyColor then
                bprop:SetProxyColor(PxyClr)
            end

            self.Gib = bprop

            simfphys.SetOwner(ply, bprop)

            if IsValid(ply) then
                undo.Create("Gib")
                undo.SetPlayer(ply)
                undo.AddEntity(bprop)
                undo.SetCustomUndoText("Undone Gib")
                undo.Finish("Gib")
                ply:AddCleanup("Gibs", bprop)
            end

            for i = 2, table.Count(self.GibModels) do
                local prop = ents.Create("gmod_simf_gtasa_gib")
                prop:SetModel(self.GibModels[i])
                prop:SetPos(self:GetPos())
                prop:SetAngles(self:GetAngles())
                prop:SetOwner(bprop)
                prop:Spawn()
                prop:Activate()
                prop.DoNotDuplicate = true
                bprop:DeleteOnRemove(prop)
                local PhysObj = prop:GetPhysicsObject()
                if IsValid(PhysObj) then
                    PhysObj:SetVelocityInstantaneous(
                        VectorRand() * 500 + self:GetVelocity() + Vector(0, 0, math.random(150, 250))
                    )
                    PhysObj:AddAngleVelocity(VectorRand())
                end
                simfphys.SetOwner(ply, prop)
            end
        else
            local bprop = ents.Create("gmod_simf_gtasa_gib")
            bprop:SetModel(self:GetModel())
            bprop:SetPos(self:GetPos())
            bprop:SetAngles(self:GetAngles())
            bprop.MakeSound = true
            bprop:Spawn()
            bprop:Activate()
            bprop:GetPhysicsObject():SetVelocity(
                self:GetVelocity() + Vector(math.random(-5, 5), math.random(-5, 5), math.random(150, 250))
            )
            bprop:GetPhysicsObject():SetMass(self.Mass * 0.75)
            bprop.DoNotDuplicate = true
            bprop:SetColor(Col)
            bprop:SetSkin(skin)
            if ProxyColor then
                bprop:SetProxyColor(PxyClr)
            end

            self.Gib = bprop
            simfphys.SetOwner(ply, bprop)

            if IsValid(ply) then
                undo.Create("Gib")
                undo.SetPlayer(ply)
                undo.AddEntity(bprop)
                undo.SetCustomUndoText("Undone Gib")
                undo.Finish("Gib")
                ply:AddCleanup("Gibs", bprop)
            end

            if self.CustomWheels == true and not self.NoWheelGibs then
                for i = 1, table.Count(self.GhostWheels) do
                    local Wheel = self.GhostWheels[i]
                    if IsValid(Wheel) then
                        local prop = ents.Create("gmod_simf_gtasa_gib")
                        prop:SetModel(Wheel:GetModel())
                        prop:SetPos(Wheel:LocalToWorld(Vector(0, 0, 0)))
                        prop:SetAngles(Wheel:LocalToWorldAngles(Angle(0, 0, 0)))
                        prop:SetOwner(bprop)
                        if ProxyColor then
                            prop:SetProxyColor(Wheel:GetProxyColor())
                        end
                        prop:Spawn()
                        prop:Activate()
                        prop:GetPhysicsObject():SetVelocity(
                            self:GetVelocity() + Vector(math.random(-5, 5), math.random(-5, 5), math.random(0, 25))
                        )
                        prop:GetPhysicsObject():SetMass(20)
                        prop.DoNotDuplicate = true
                        bprop:DeleteOnRemove(prop)

                        simfphys.SetOwner(ply, prop)
                    end
                end
            end
        end

        -- // this bit spawns the gibs still on the car
        if self.NAKHitboxes then
            SpawnGibExploded(self, skin, Col, PxyClr, HBInfo)
        end

        local Driver = self:GetDriver()
        if IsValid(Driver) then
            if self.RemoteDriver ~= Driver then
                Driver:TakeDamage(
                    Driver:Health() + Driver:Armor(),
                    self.LastAttacker or Entity(0),
                    self.LastInflictor or Entity(0)
                )
            end
        end
        if self.PassengerSeats then
            for i = 1, table.Count(self.PassengerSeats) do
                local Passenger = self.pSeat[i]:GetDriver()
                if IsValid(Passenger) then
                    Passenger:TakeDamage(
                        Passenger:Health() + Passenger:Armor(),
                        self.LastAttacker or Entity(0),
                        self.LastInflictor or Entity(0)
                    )
                end
            end
        end
        self:Extinguish()
        self:OnDestroyed()
        self:Remove()
    end
end

local function AddBDGroup(self, BDGroup, broken)
    if not broken then
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
    for id in pairs(self.NAKHitboxes) do
        local HBInfo = self.NAKHitboxes
        if damagePos:WithinAABox(HBInfo[id].OBBMin, HBInfo[id].OBBMax) then
            if HBInfo[id].TypeFlag == 2 then --Explode collisions
                self:ExplodeVehicle()
                break
            end

            dmgAmount = dmgAmount * math.random(0.6, 0.9)
            --Take damage
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
                        SpawnGib(self, HBInfo[id].GibModel, HBInfo[id].GibOffset)
                        timer.Simple(
                            0.02,
                            function()
                                if not IsValid(self) then
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

local function OverrideTakeDamage(self)
    --store old function
    self.NAKOnTakeDamage = self.OnTakeDamage
    --define new function
    self.OnTakeDamage = function(ent, dmginfo)
        local Damage = dmginfo:GetDamage()
        local DamagePos = ent:WorldToLocal(dmginfo:GetDamagePosition())
        SharedDamage(ent, DamagePos, Damage)
        self:NAKOnTakeDamage(dmginfo)
    end
end

local function OverridePhysicsDamage(self)
    --store the old built in simfphys function
    self.NAKHBPhysicsCollide = self.PhysicsCollide
    --overwrite function and call stored one later
    self.PhysicsCollide = function(ent, data, physobj)
        if (data.Speed > 50 and data.DeltaTime > 0.8) then --The damage sounds from GTASA
            self:EmitSound("gtasa/sfx/damage_hvy" .. math.random(1, 7) .. ".wav")
        end
        --dont do damage if hitting flesh (player walking into a vehicle)
        --TODO: i think we need to dead (0.5, 0.3) of regular damage, bacause if human run into a car, car will get damage
        if (not data.HitEntity:IsNPC()) and (not data.HitEntity:IsNextBot()) and (not data.HitEntity:IsPlayer()) then
            local spd = data.Speed + data.OurOldVelocity:Length() + data.TheirOldVelocity:Length()
            local dmgmult = math.Round(spd / 30, 0)
            local damagePos = ent:WorldToLocal(data.HitPos)
            if (data.DeltaTime > 0.2) then
                SharedDamage(ent, damagePos, dmgmult)
            end
        end
        self:NAKHBPhysicsCollide(data, physobj)
    end
end

local function OverrideOnRepaired(self)
    self.OnRepaired = function(self)
        self:SetBodyGroups(self.RepairBodygroups)
        for id in pairs(self.NAKHitboxes) do
            self.NAKHitboxes[id].Stage = 0
            self.NAKHitboxes[id].CurHealth = self.NAKHitboxes[id].Health
        end
    end
end

--[[
	This bit of the code applies the altered functions above to the vehicle, and also sets any values we need for later
	CurHealth, Stage, and mirroring hitboxes is done here. Pretty much just a global stuff.
]]
function NAK.AddHitboxes(self, repairstring)
    local HBInfo = NAK.GetHitboxes(self)
    self.NAKHitboxes = HBInfo
    self.RepairBodygroups = repairstring and repairstring or "0000000000"
    --Override damages
    OverridePhysicsDamage(self)
    OverrideTakeDamage(self)
    OverrideOnRepaired(self)
    OverrideExplode(self)
end