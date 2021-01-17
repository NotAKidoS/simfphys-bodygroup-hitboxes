-- Lua Library inline imports
function __TS__TypeOf(value)
    local luaType = type(value)
    if luaType == "table" then
        return "object"
    elseif luaType == "nil" then
        return "undefined"
    else
        return luaType
    end
end

local ____exports = {}
local function defaultOnCollide(hbox, ent, data, physobj)
    if (data.Speed > 50) and (data.DeltaTime > 0.8) then
        ent:EmitSound(
            ("gtasa/sfx/damage_hvy" .. tostring(
                math.random(1, 7)
            )) .. ".wav"
        )
    end
end
local shb_debug
local function shb_debug_update()
    shb_debug = CreateConVar("shb_debug", "1", FCVAR_ARCHIVE, "send hitboxes to clients", 0, 1):GetBool()
end
shb_debug_update()
cvars.AddChangeCallback(
    "shb_debug",
    function()
        shb_debug_update()
    end
)
local shb_rgar
local function shb_rgar_update()
    shb_rgar = CreateConVar("shb_rgar", "0", FCVAR_ARCHIVE, "Remove gibs after repair?", 0, 1):GetBool()
end
shb_rgar_update()
cvars.AddChangeCallback(
    "shb_rgar",
    function()
        shb_rgar_update()
    end
)
local shb_gibsondestroy
local function shb_gibsondestroy_update()
    shb_gibsondestroy = CreateConVar("shb_gibsondestroy", "1", FCVAR_ARCHIVE, "Execute last stage on destroy?", 0, 1):GetBool()
end
shb_gibsondestroy_update()
cvars.AddChangeCallback(
    "shb_gibsondestroy",
    function()
        shb_gibsondestroy_update()
    end
)
____exports.SHB = {}
local SHB = ____exports.SHB
do
    SHB.TypeFlag = {}
    SHB.TypeFlag.NONE = 0
    SHB.TypeFlag[SHB.TypeFlag.NONE] = "NONE"
    SHB.TypeFlag.GLASS = 1
    SHB.TypeFlag[SHB.TypeFlag.GLASS] = "GLASS"
    SHB.TypeFlag.EXPLOSIVE = 2
    SHB.TypeFlag[SHB.TypeFlag.EXPLOSIVE] = "EXPLOSIVE"
    function SHB.IsValidCollideEntity(ent)
        return true
    end
    function SHB.ChangeStage(ent, hbox, stage, damagePos, destroyed)
        if hbox.Stage ~= stage then
            if hbox.Stage ~= nil then
                local oldStage = hbox.Stages[hbox.Stage + 1]
                if type(oldStage.OnDeselected) == "function" then
                    oldStage:OnDeselected(ent, hbox)
                end
            end
            hbox.Stage = stage
            local newStage = hbox.Stages[stage + 1]
            if type(newStage.OnSelected) == "function" then
                newStage:OnSelected(ent, hbox)
            end
            if istable(newStage.Bodygroups) then
                for bodygroupkey in pairs(newStage.Bodygroups) do
                    if type(bodygroupkey) == "number" then
                        ent:SetBodygroup(bodygroupkey, newStage.Bodygroups[bodygroupkey])
                    elseif type(bodygroupkey) == "string" then
                        ent:SetBodygroup(
                            ent:FindBodygroupByName(bodygroupkey),
                            newStage.Bodygroups[bodygroupkey]
                        )
                    else
                        error("SHB: unknown type of bodygroupkey")
                    end
                end
            end
            if newStage.Gib then
                if ((destroyed and (function() return shb_gibsondestroy end)) or (function() return true end))() then
                    local gib = ents.Create("prop_physics")
                    local parent = (destroyed and ((IsValid(ent.Gib) and ent.Gib) or ent)) or ent
                    gib:SetModel(newStage.Gib.Model)
                    gib:SetPos(
                        (newStage.Gib.PositionOffset and parent:LocalToWorld(newStage.Gib.PositionOffset)) or ent:GetPos()
                    )
                    gib:SetAngles(
                        parent:GetAngles()
                    )
                    gib:SetSkin(
                        parent:GetSkin()
                    )
                    gib:SetVelocity(
                        parent:GetVelocity()
                    )
                    gib:Spawn()
                    gib:Activate()
                    if destroyed then
                        ent.Gib:DeleteOnRemove(gib)
                    else
                        ent:CallOnRemove(
                            "simfphys_hitbox_gib_" .. tostring(
                                tostring(hbox)
                            ),
                            function()
                                if IsValid(ent.Gib) then
                                    ent.Gib:DeleteOnRemove(gib)
                                else
                                    SafeRemoveEntity(gib)
                                end
                            end
                        )
                    end
                    if _G.ProxyColor then
                        local proxycolor = parent:GetProxyColor()
                        timer.Simple(
                            0,
                            function()
                                gib:SetProxyColor(proxycolor)
                            end
                        )
                    end
                    hbox.Gib = gib
                end
            end
            if newStage.GlassBreakFX and damagePos then
                local damagePosWorld = ent:LocalToWorld(damagePos)
                sound.Play("Glass.BulletImpact", damagePosWorld, 75, 100, 1)
                local effectdata = EffectData()
                effectdata:SetOrigin(damagePosWorld)
                util.Effect("shb_glassbreak", effectdata)
            end
            if newStage.Explode and (not destroyed) then
                ent:ExplodeVehicle()
            end
        end
    end
    function SHB.TakeDamage(ent, damagePos, damage, physical, dmginfo_or_data, physobj)
        if not ent.HitBoxes then
            error("SHB: why you trying to manage hitboxes on car without it?")
        end
        for hbox_key in pairs(ent.HitBoxes) do
            local hbox = ent.HitBoxes[hbox_key]
            if damagePos:WithinAABox(hbox.HBMin, hbox.HBMax) then
                if physical and (type(hbox.OnPhysicsCollide) == "function") then
                    hbox.OnPhysicsCollide(hbox, ent, dmginfo_or_data, physobj)
                elseif type(hbox.OnHit) == "function" then
                    hbox.OnHit(hbox, ent, dmginfo_or_data)
                end
                local currentStageNum = hbox.Stage
                hbox.Damage = hbox.Damage + damage
                if true then
                    local newStageNum = currentStageNum + 1
                    local newStage = hbox.Stages[newStageNum + 1]
                    if newStage then
                        if (newStage.Damage and (newStage.Damage <= hbox.Damage)) or (not newStage.Damage) then
                            ____exports.SHB.ChangeStage(ent, hbox, newStageNum, damagePos)
                        end
                    end
                end
            end
        end
    end
    function SHB.OnRepair(ent)
        if not IsValid(ent) then
            return
        end
        if not ent.HitBoxes then
            return
        end
        local hboxes = ent.HitBoxes
        for hbox_key in pairs(hboxes) do
            local hbox = hboxes[hbox_key]
            if hbox.Stage > 0 then
                ____exports.SHB.ChangeStage(ent, hbox, 0)
            end
            hbox.Damage = 0
            if type(hbox.OnRepair) == "function" then
                hbox.OnRepair(hbox, ent)
            end
            if shb_rgar then
                SafeRemoveEntity(hbox.Gib)
            end
        end
    end
    function SHB.Init(ent, hboxes)
        print("Initializing hitboxes")
        print(
            debug.traceback()
        )
        ent.HitBoxes = hboxes
        for hbox_key in pairs(ent.HitBoxes) do
            local hbox = ent.HitBoxes[hbox_key]
            if hbox.OBBMin and hbox.OBBMax then
                hbox.HBMax = hbox.OBBMax
                hbox.HBMin = hbox.OBBMin
                local ____switch52 = hbox.TypeFlag
                if ____switch52 == SHB.TypeFlag.GLASS then
                    goto ____switch52_case_0
                elseif ____switch52 == SHB.TypeFlag.EXPLOSIVE then
                    goto ____switch52_case_1
                elseif ____switch52 == SHB.TypeFlag.NONE then
                    goto ____switch52_case_2
                end
                goto ____switch52_case_default
                ::____switch52_case_0::
                do
                    hbox.Stages = {{Bodygroups = (hbox.BDGroup and ({[hbox.BDGroup] = 0})) or nil}, {GlassBreakFX = true, Damage = (hbox.Health and (hbox.Health * 0.1)) or 0, Bodygroups = (hbox.BDGroup and ({[hbox.BDGroup] = 1})) or nil}}
                    if hbox.BDGroup then
                        hbox.Stages[3] = {GlassBreakFX = true, Damage = (hbox.Health and hbox.Health) or 0, Bodygroups = (hbox.BDGroup and ({[hbox.BDGroup] = 2})) or nil}
                    end
                    goto ____switch52_end
                end
                ::____switch52_case_1::
                do
                    hbox.Stages = {{}, {Explode = true}}
                    goto ____switch52_end
                end
                ::____switch52_case_2::
                do
                end
                ::____switch52_case_default::
                do
                    if hbox.BDGroup then
                        hbox.Stages = {{Bodygroups = {[hbox.BDGroup] = 0}}, {Bodygroups = {[hbox.BDGroup] = 1}, Damage = (hbox.Health and (hbox.Health * 0.1)) or 0}, {Bodygroups = {[hbox.BDGroup] = 2}, Damage = (hbox.Health and hbox.Health) or 0, Gib = {Model = hbox.GibModel, PositionOffset = hbox.GibOffset}}}
                    end
                    goto ____switch52_end
                end
                ::____switch52_end::
                hbox.nak = true
            end
            hbox.CurHealth = hbox.Health
            hbox.Damage = 0
            PrintTable(hbox)
            ____exports.SHB.ChangeStage(ent, hbox, 0)
            hbox.OnPhysicsCollide = hbox.OnPhysicsCollide or defaultOnCollide
        end
        local oldPhysicsCollide = ent.PhysicsCollide
        ent.PhysicsCollide = function(ent, data, physobj)
            if ____exports.SHB.IsValidCollideEntity(ent) then
                local spd = (data.Speed + data.OurOldVelocity:Length()) + data.TheirOldVelocity:Length()
                local dmgmult = math.Round(spd / 30, 0)
                local damagePos = ent:WorldToLocal(data.HitPos)
                if data.DeltaTime > 0.2 then
                    ____exports.SHB.TakeDamage(ent, damagePos, dmgmult, true, data, physobj)
                end
            end
            oldPhysicsCollide(ent, data, physobj)
        end
        local oldOnTakeDamage = ent.OnTakeDamage
        ent.OnTakeDamage = function(ent, dmginfo)
            ____exports.SHB.TakeDamage(
                ent,
                ent:WorldToLocal(
                    dmginfo:GetDamagePosition()
                ),
                dmginfo:GetDamage(),
                false,
                dmginfo
            )
            oldOnTakeDamage(ent, dmginfo)
        end
        local oldOnDestoyed = ent.OnDestroyed
        ent.OnDestroyed = function(car)
            for hbox_key in pairs(car.HitBoxes) do
                local hbox = car.HitBoxes[hbox_key]
                local ____switch61 = __TS__TypeOf(hbox.OnDestroyed)
                if ____switch61 == "function" then
                    goto ____switch61_case_0
                elseif ____switch61 == "number" then
                    goto ____switch61_case_1
                end
                goto ____switch61_case_default
                ::____switch61_case_0::
                do
                    hbox.Gib = nil
                    SHB.ChangeStage(car, hbox, #hbox.Stages - 1, nil, true)
                    hbox.OnDestroyed(car, hbox)
                    goto ____switch61_end
                end
                ::____switch61_case_1::
                do
                    SHB.ChangeStage(car, hbox, hbox.OnDestroyed, nil, true)
                    goto ____switch61_end
                end
                ::____switch61_case_default::
                do
                    SHB.ChangeStage(car, hbox, #hbox.Stages - 1, nil, true)
                    goto ____switch61_end
                end
                ::____switch61_end::
            end
            if IsValid(ent.Gib) then
                do
                    local i = 0
                    while i < ent:GetNumBodyGroups() do
                        ent.Gib:SetBodygroup(
                            i,
                            ent:GetBodygroup(i)
                        )
                        i = i + 1
                    end
                end
            end
            oldOnDestoyed(car)
        end
        if ent.OnRepaired then
            local oldOnRepaired = ent.OnRepaired
            ent.OnRepaired = function(car)
                SHB.OnRepair(car)
                oldOnRepaired(car)
            end
        else
            timer.Simple(
                1,
                function()
                    if IsValid(ent) then
                        if istable(ent.Wheels) then
                            local wheel = ent.Wheels[1]
                            if IsValid(wheel) then
                                local oldSetDamaged = wheel.SetDamaged
                                wheel.SetDamaged = function(wheel, value)
                                    if not value then
                                        SHB.OnRepair(ent)
                                    end
                                    oldSetDamaged(wheel, value)
                                end
                            end
                        end
                    end
                end
            )
        end
        if shb_debug then
            net.Start("simfphys_hitbox")
            net.WriteEntity(ent)
            net.WriteUInt(
                table.Count(ent.HitBoxes),
                32
            )
            for hbox_key in pairs(ent.HitBoxes) do
                local hbox = ent.HitBoxes[hbox_key]
                if hbox.HBMin and hbox.HBMax then
                    net.WriteVector(hbox.HBMin)
                    net.WriteVector(hbox.HBMax)
                end
            end
            net.Broadcast()
        end
    end
end
_G.SHB = ____exports.SHB
list.Set(
    "FLEX",
    "HitBoxes",
    function(ent, flex)
        ____exports.SHB.Init(ent, flex)
    end
)
local entMeta = FindMetaTable("Entity")
entMeta.NAKHitboxDmg = function(self)
    ____exports.SHB.Init(self, self.NAKHitboxes)
end
entMeta.NAKSimfEngineStart = ErrorNoHalt
entMeta.NAKSimfSkidSounds = ErrorNoHalt
entMeta.NAKDmgEngineSnd = ErrorNoHalt
entMeta.NAKKillVehicle = ErrorNoHalt
entMeta.NAKSimfFireTime = ErrorNoHalt
entMeta.NAKSimfTickStuff = ErrorNoHalt
entMeta.NAKSimfEMSRadio = ErrorNoHalt
entMeta.NAKSimfTrailer = ErrorNoHalt
entMeta.NAKSimfGTASA = ErrorNoHalt
print("sv_hit")
return ____exports
