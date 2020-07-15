--[[

	This is the base for the damage script, I am trying my best to make it easy to use & usable for most things.
	Written by NotAKidoS
]] --
local NAK_CONVAR = {FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE}
CreateConVar("gtasa_physicdamagemultiplier", "1", NAK_CONVAR)
CreateConVar("gtasa_takedamagemultiplier", "1", NAK_CONVAR)

-- Client stuff
if CLIENT then
    net.Receive("simfphys_gtasa_glassbreak_fx", function(length)
        local self = net.ReadEntity()
        local ShatterPos = self:LocalToWorld(net.ReadVector())
        if IsValid(self) then
            local effectdata = EffectData()
            effectdata:SetOrigin(ShatterPos)
            util.Effect("simf_gtasa_glassbreak", effectdata)
        end
    end)
    net.Receive("nak_hitbox_cashed", function()
        local ent = net.ReadEntity()
        if IsValid(ent) then ent.NAKHitboxes = net.ReadTable() end
    end)
    local function initializeHitboxesRenderer()
        local nak_simf_hitboxes = CreateConVar("nak_simf_hitboxes", 0, {
            FCVAR_ARCHIVE, FCVAR_ARCHIVE_XBOX
        }, "Debug Simfphys hitboxes for supported vehicles", 0, 1)
        local nak_simf_hitboxes_filled =
            CreateConVar("nak_simf_hitbox_filled", 1,
                         {FCVAR_ARCHIVE, FCVAR_ARCHIVE_XBOX},
                         "Filled boxes?\nrequires nak_simf_hitbox_reload", 0, 1):GetBool()
        local nak_simf_hitboxes_wireframe =
            CreateConVar("nak_simf_hitbox_wireframe", 1,
                         {FCVAR_ARCHIVE, FCVAR_ARCHIVE_XBOX},
                         "Wireframe boxes?\nrequires nak_simf_hitbox_reload", 0,
                         1):GetBool()
        local veccolor = util.StringToType(
                             CreateConVar("nak_simf_hitbox_color",
                                          "255 255 255",
                                          {FCVAR_ARCHIVE, FCVAR_ARCHIVE_XBOX},
                                          "Set a color for the box AS A STRING '255,255,255'\nrequires nak_simf_hitbox_reload"):GetString(),
                             "Vector")
        local alpha = CreateConVar("nak_simf_hitbox_alpha", 100,
                                   {FCVAR_ARCHIVE, FCVAR_ARCHIVE_XBOX},
                                   "Set the alpha of the hitbox\nrequires nak_simf_hitbox_reload",
                                   0, 255):GetFloat()
        hook.Remove("PostDrawTranslucentRenderables", "nak_simf_hitboxes")
        hook.Remove("PostDrawOpaqueRenderables", "nak_simf_hitboxes")
        local color = Color(veccolor.x, veccolor.y, veccolor.z, alpha)
        if nak_simf_hitboxes_filled then
            hook.Add("PostDrawTranslucentRenderables", "nak_simf_hitboxes",
                     function()
                if nak_simf_hitboxes:GetBool() then
                    render.SetColorMaterial()
                    for k, ent in pairs(ents.FindByClass(
                                            "gmod_sent_vehicle_fphysics_base")) do -- WIKI: Gets all entities with the given class, supports wildcards. This works internally by iterating over ents.GetAll. Even if internally ents.GetAll is used, It is faster to use ents.FindByClass than ents.GetAll with a single class comparison.
                        local HBInfo = ent.NAKHitboxes
                        if HBInfo then
                            local entPos = ent:GetPos()
                            local entAngles = ent:GetAngles()
                            local key = nil
                            while true do
                                key = next(HBInfo, key)
                                if key == nil then
                                    break
                                end
                                render.DrawBox(entPos, entAngles,
                                               HBInfo[key].OBBMin,
                                               HBInfo[key].OBBMax, color, true)
                            end
                        end
                    end
                end
            end)
        end
        if nak_simf_hitboxes_wireframe then
            hook.Add("PostDrawOpaqueRenderables", "nak_simf_hitboxes",
                     function()
                if nak_simf_hitboxes:GetBool() then
                    render.SetColorMaterial()
                    for k, ent in pairs(ents.FindByClass(
                                            "gmod_sent_vehicle_fphysics_base")) do -- WIKI: Gets all entities with the given class, supports wildcards. This works internally by iterating over ents.GetAll. Even if internally ents.GetAll is used, It is faster to use ents.FindByClass than ents.GetAll with a single class comparison.
                        local HBInfo = ent.NAKHitboxes
                        if HBInfo then
                            local entPos = ent:GetPos()
                            local entAngles = ent:GetAngles()
                            local key = nil
                            while true do
                                key = next(HBInfo, key)
                                if key == nil then
                                    break
                                end
                                render.DrawWireframeBox(entPos, entAngles,
                                                        HBInfo[key].OBBMin,
                                                        HBInfo[key].OBBMax,
                                                        color, true)
                            end
                        end
                    end
                end
            end)
        end
    end
    initializeHitboxesRenderer()
    concommand.Add("nak_simf_hitbox_reload", initializeHitboxesRenderer, nil,
                   "updates settings for hitbox renderer")
end

if CLIENT then return end

util.AddNetworkString("NAKSendSimfphysHitbox")
util.AddNetworkString("simfphys_gtasa_glassbreak_fx")
util.AddNetworkString("nak_hitbox_cashed")

local function SpawnGib(self, GibModel, GibOffset)

    if (GibModel) then
        local offset = GibOffset or Vector(0, 0, 0)
        local TheGib = ents.Create("gmod_simf_gtasa_nofire_gib")
        TheGib:SetModel(GibModel)
        TheGib:SetPos(self:LocalToWorld(offset))
        TheGib:SetAngles(self:GetAngles())
        TheGib.Car = self
        TheGib:Spawn()
        TheGib:Activate()

        -- make the gibs remove with the car
        self:CallOnRemove("NAKKillGibsOnRemove" .. TheGib:EntIndex(),
                          function(self)
            if not self.destroyed then
                if IsValid(TheGib) then TheGib:Remove() end
            elseif IsValid(self.Gib) then
                if IsValid(TheGib) then
                    self.Gib:DeleteOnRemove(TheGib)
                end
            end
        end)
    end
end

local function AddBDGroup(self, BDGroup, broken)

    if not broken then
        if istable(BDGroup) then
            for BD in SortedPairs(BDGroup) do
                self:SetBodygroup(BDGroup[BD],
                                  (self:GetBodygroup(BDGroup[BD]) + 1))
            end
        else
            self:SetBodygroup(BDGroup, (self:GetBodygroup(BDGroup) + 1))
        end
    else
        if istable(BDGroup) then
            for BD in SortedPairs(BDGroup) do
                self:SetBodygroup(BDGroup[BD],
                                  (self:GetBodygroupCount(BDGroup[BD]) - 1))
            end
        else
            self:SetBodygroup(BDGroup, (self:GetBodygroupCount(BDGroup) - 1))
        end
    end
end

local function SharedDamage(self, damagePos, dmgAmount, type)

    for id in SortedPairs(self.NAKHitboxes) do
        local HBInfo = self.NAKHitboxes
        if damagePos:WithinAABox(HBInfo[id].OBBMin, HBInfo[id].OBBMax) then

            -- //Check for special damage areas
            if HBInfo[id].TypeFlag == 2 then -- Explode collisions
                self:ExplodeVehicle()
                break
            end

            dmgAmount = dmgAmount * math.random(0.6, 0.9)
            -- //Take damage
            HBInfo[id].CurHealth = math.Clamp(
                                       (HBInfo[id].CurHealth - dmgAmount), 0,
                                       HBInfo[id].Health)

            -- //90% health stage
            if HBInfo[id].Stage == 0 then
                if HBInfo[id].CurHealth < HBInfo[id].Health * 0.9 then
                    AddBDGroup(self, HBInfo[id].BDGroup)
                    HBInfo[id].Stage = 1
                end
            end
            -- //Break off stage
            if HBInfo[id].Stage == 1 then
                if HBInfo[id].CurHealth < 1 then
                    AddBDGroup(self, HBInfo[id].BDGroup, true)
                    HBInfo[id].Stage = 2 -- means broken

                    if HBInfo[id].TypeFlag == 1 then
                        self:EmitSound("Glass.BulletImpact")
                        net.Start("simfphys_gtasa_glassbreak_fx")
                        net.WriteEntity(self)
                        net.WriteVector(HBInfo[id].ShatterPos)
                        net.Broadcast()
                    else
                        SpawnGib(self, HBInfo[id].GibModel, HBInfo[id].GibOffset)
                    end
                end
            end

            -- print("Bodypanel "..id.." hit", HBInfo[id].CurHealth)
        end
    end
end

local function OverrideTakeDamage(self)
    -- store old function
    self.NAKOnTakeDamage = self.OnTakeDamage
    -- define new function
    self.OnTakeDamage = function(ent, dmginfo) ---START OF FUNCTION
        -- local DmgMultiplier = GetConVar( "gtasa_takedamagemultiplier" ):GetFloat()
        local Damage = dmginfo:GetDamage() -- * DmgMultiplier
        local DamagePos = ent:WorldToLocal(dmginfo:GetDamagePosition())
        -- local Type = dmginfo:GetDamageType()
        SharedDamage(ent, DamagePos, Damage)
        self:NAKOnTakeDamage(dmginfo)
    end
end

local function OverridePhysicsDamage(self)
    -- store the old built in simfphys function
    self.NAKHBPhysicsCollide = self.PhysicsCollide
    -- override the old function to call our code first, then call the old stored one
    self.PhysicsCollide = function(ent, data, physobj)
        -- The damage sounds from GTASA
        if (data.Speed > 50 and data.DeltaTime > 0.8) then
            self:EmitSound("gtasa/sfx/damage_hvy" .. math.random(1, 7) .. ".wav")
        end
        -- dont do damage if hitting flesh (player walking into a vehicle)
        -- TODO: i think we need to dead (0.5, 0.3) of regular damage, bacause if human run into a car, car will get damage
        if (not data.HitEntity:IsNPC()) and (not data.HitEntity:IsNextBot()) and
            (not data.HitEntity:IsPlayer()) then
            local spd = data.Speed + data.OurOldVelocity:Length() +
                            data.TheirOldVelocity:Length()
            local dmgmult = math.Round(spd / 30, 0)
            local damagePos = ent:WorldToLocal(data.HitPos)
            if (data.DeltaTime > 0.2) then
                PrintMessage(HUD_PRINTTALK, dmgmult)
                SharedDamage(ent, damagePos, dmgmult)
            end
        end
        self:NAKHBPhysicsCollide(data, physobj)
    end
end

function NAKSpawnGibs(self, prxyClr)

    local HBInfo = self.NAKHitboxes

    for id in SortedPairs(HBInfo) do

        if HBInfo[id].Stage == 2 then break end

        if (HBInfo[id].GibModel) then
            local offset = HBInfo[id].GibOffset or Vector(0, 0, 0)
            local TheExtraGibs = ents.Create("gmod_simf_gtasa_gib")
            TheExtraGibs:SetModel(HBInfo[id].GibModel)
            TheExtraGibs:SetPos(self:LocalToWorld(offset))
            TheExtraGibs:SetAngles(self:GetAngles())
            TheExtraGibs.Car = self
            TheExtraGibs:Spawn()
            TheExtraGibs:Activate()

            if (self.GetProxyColor) then
                TheExtraGibs:SetProxyColor(prxyClr)
            end

            self.Gib:DeleteOnRemove(TheExtraGibs)

            local PhysObj = TheExtraGibs:GetPhysicsObject()
            if IsValid(PhysObj) then
                PhysObj:SetVelocityInstantaneous(
                    VectorRand() * 500 + self:GetVelocity() +
                        Vector(0, 0, math.random(150, 250)))
                PhysObj:AddAngleVelocity(VectorRand())
            end
        end
    end
end

--[[
	This bit of the code applies the altered functions above to the vehicle, and also sets any values we need for later
	CurHealth, Stage, and mirroring hitboxes is done here.
--]]

local Entity = FindMetaTable("Entity")

-- //CUSTOM EXPLODE FUNCTIONNNN

function Entity:NAKSimfCustomExplode()

    self.ExplodeVehicle = function(self) ---START OF FUNCTION

        if not IsValid(self) then return end
        if self.destroyed then return end

        self.destroyed = true

        local ply = self.EntityOwner
        local skin = self:GetSkin()
        local Col = self:GetColor()
        local prxyClr
        if (self.GetProxyColor) then prxyClr = self:GetProxyColor() end
        Col.r = Col.r * 0.8
        Col.g = Col.g * 0.8
        Col.b = Col.b * 0.8

        if self.GibModels then
            local bprop = ents.Create("gmod_simf_gtasa_gib")
            bprop:SetModel(self.GibModels[1])
            bprop:SetPos(self:GetPos())
            bprop:SetAngles(self:GetAngles())
            bprop.MakeSound = true
            bprop.Car = self
            bprop:Spawn()
            bprop:Activate()
            bprop:GetPhysicsObject():SetVelocity(
                self:GetVelocity() +
                    Vector(math.random(-5, 5), math.random(-5, 5),
                           math.random(150, 250)))
            bprop:GetPhysicsObject():SetMass(self.Mass * 0.75)
            bprop.DoNotDuplicate = true
            bprop:SetColor(Col)
            if (self.GetProxyColor) then bprop:SetProxyColor(prxyClr) end
            bprop:SetSkin(skin)

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
                prop.Car = self
                prop:Spawn()
                prop:Activate()
                bprop:DeleteOnRemove(prop)

                local PhysObj = prop:GetPhysicsObject()
                if IsValid(PhysObj) then
                    PhysObj:SetVelocityInstantaneous(
                        VectorRand() * 500 + self:GetVelocity() +
                            Vector(0, 0, math.random(150, 250)))
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
            bprop.Car = self
            bprop:Spawn()
            bprop:Activate()
            bprop:GetPhysicsObject():SetVelocity(
                self:GetVelocity() +
                    Vector(math.random(-5, 5), math.random(-5, 5),
                           math.random(150, 250)))
            bprop:GetPhysicsObject():SetMass(self.Mass * 0.75)
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
                        local prop = ents.Create(
                                         "gmod_sent_vehicle_fphysics_gib")
                        prop:SetModel(Wheel:GetModel())
                        prop:SetPos(Wheel:LocalToWorld(Vector(0, 0, 0)))
                        prop:SetAngles(Wheel:LocalToWorldAngles(Angle(0, 0, 0)))
                        prop:SetOwner(bprop)
                        prop:Spawn()
                        prop:Activate()
                        prop:GetPhysicsObject():SetVelocity(
                            self:GetVelocity() +
                                Vector(math.random(-5, 5), math.random(-5, 5),
                                       math.random(0, 25)))
                        prop:GetPhysicsObject():SetMass(20)
                        prop.DoNotDuplicate = true
                        bprop:DeleteOnRemove(prop)

                        simfphys.SetOwner(ply, prop)
                    end
                end
            end
        end
        -- // this bit spawns the gibs still on the car
        if self.NAKHitboxes then NAKSpawnGibs(self, prxyClr) end

        local Driver = self:GetDriver()
        if IsValid(Driver) then
            if self.RemoteDriver ~= Driver then
                Driver:TakeDamage(Driver:Health() + Driver:Armor(),
                                  self.LastAttacker or Entity(0),
                                  self.LastInflictor or Entity(0))
            end
        end
        if self.PassengerSeats then
            for i = 1, table.Count(self.PassengerSeats) do
                local Passenger = self.pSeat[i]:GetDriver()
                if IsValid(Passenger) then
                    Passenger:TakeDamage(Passenger:Health() + Passenger:Armor(),
                                         self.LastAttacker or Entity(0),
                                         self.LastInflictor or Entity(0))
                end
            end
        end
        self:Extinguish()
        self:OnDestroyed()
        self:Remove()
    end
end

function Entity:NAKHitboxDmg()

    -- //Mirrors any needed hitboxes
    for id in SortedPairs(self.NAKHitboxes) do
        -- //Set current health, unless it is added by the mod maker
        self.NAKHitboxes[id].CurHealth =
            self.NAKHitboxes[id].CurHealth or self.NAKHitboxes[id].Health
        self.NAKHitboxes[id].Stage = 0

        if self.NAKHitboxes[id].Mirror then
            print("MIRROR THIS " .. id)

            local MirrorAxis = self.NAKHitboxes[id].Mirror
            self.NAKHitboxes[id .. "_2"] = {}

            self.NAKHitboxes[id .. "_2"].OBBMin =
                self.NAKHitboxes[id].OBBMin * MirrorAxis
            self.NAKHitboxes[id .. "_2"].OBBMax =
                self.NAKHitboxes[id].OBBMax * MirrorAxis

            self.NAKHitboxes[id .. "_2"].TypeFlag =
                self.NAKHitboxes[id].TypeFlag

            self.NAKHitboxes[id .. "_2"].BDGroup =
                self.NAKHitboxes[id].BDGroup_2
            self.NAKHitboxes[id .. "_2"].GibModel =
                self.NAKHitboxes[id].GibModel_2
            self.NAKHitboxes[id .. "_2"].GibOffset =
                self.NAKHitboxes[id].GibOffset * MirrorAxis
            self.NAKHitboxes[id .. "_2"].Health = self.NAKHitboxes[id].Health

            -- //Mirror current health & stage
            self.NAKHitboxes[id .. "_2"].CurHealth =
                self.NAKHitboxes[id].CurHealth
            self.NAKHitboxes[id .. "_2"].Stage = self.NAKHitboxes[id].Stage
        end
    end
    net.Start("nak_hitbox_cashed")
    net.WriteEntity(self)
    net.WriteTable(self.NAKHitboxes)
    net.Broadcast()

    -- PrintTable(self.NAKHitboxes)

    OverridePhysicsDamage(self)
    OverrideTakeDamage(self)
    self:NAKSimfCustomExplode()
end
