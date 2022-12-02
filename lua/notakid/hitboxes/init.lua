--[[
	Init file, sets things up for client and server
]]

AddCSLuaFile("notakid/hitboxes/client.lua")
AddCSLuaFile("notakid/hitboxes/shared.lua")
include("notakid/hitboxes/shared.lua")
if CLIENT then
    include("notakid/hitboxes/client.lua")
    return
else
    include("notakid/hitboxes/hooks.lua")
end

--Rest of code is SERVER only
util.AddNetworkString("nak_glassbreak_fx")

local function SpawnGibExploded(self, skin, Col, PxyClr, HBInfo)
    for id in SortedPairs(HBInfo) do
        if HBInfo[id].Stage == 2 then
            return
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
        local PxyClr = -1
        local HBInfo = self.NAKHitboxes
        if ProxyColor then
            PxyClr = self:GetProxyColor()
        end

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

--[[
	This bit of the code applies the altered functions above to the vehicle, and also sets any values we need for later
	CurHealth, Stage, and mirroring hitboxes is done here. Pretty much just a global stuff.
]]
function NAK.InitHitboxes(self)
    local HBInfo, HBExtra = NAK.GetHitboxes(self)
	if not HBInfo then return false end
	
    self.NAKHitboxes = HBInfo
    self.RepairBodygroups = self.RepairBodygroups and self.RepairBodygroups or "0000000000"
    --Override damages
    OverrideExplode(self)
end