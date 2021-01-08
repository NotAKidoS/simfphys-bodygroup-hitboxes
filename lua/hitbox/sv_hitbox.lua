function defaultOnCollide(hbox, ent, data, physobj)
    if (data.Speed > 50) and (data.DeltaTime > 0.8) then
        ent:EmitSound(
            ("gtasa/sfx/damage_hvy" .. tostring(
                math.random(1, 7)
            )) .. ".wav"
        )
    end
end
SHB = SHB or ({})
do
    function SHB.IsValidCollideEntity(ent)
        return true
    end
    function SHB.TakeDamage(ent, damagePos, damage, physical, dmginfo_or_data, physobj)
        if not ent.HitBoxes then
            error("SHB: why you trying to manage hitboxes on car without it?")
        end
        for hbox_key in pairs(ent.HitBoxes) do
            local hbox = ent.HitBoxes[hbox_key]
            if damagePos:WithinAABox(hbox.HBMin or hbox.OBBMin, hbox.HBMax or hbox.OBBMax) then
                if hbox.TypeFlag == 2 then
                    if ent.GetFuel and (ent:GetFuel() > 0) then
                        ent:ExplodeVehicle()
                    end
                    return
                end
                hbox.CurHealth = math.Clamp(hbox.CurHealth - damage, 0, hbox.Health)
                if hbox.Stage == 0 then
                    if hbox.CurHealth < (hbox.Health * 0.9) then
                        hbox.Stage = 1
                        if hbox.Bodygroup then
                            ent:SetBodygroup(
                                hbox.Bodygroup,
                                ent:GetBodygroup(hbox.Bodygroup) + 1
                            )
                        end
                        if hbox.OnHit then
                            hbox.OnHit(hbox, ent)
                        end
                        if physical then
                            hbox.OnPhysicsCollide(hbox, ent, dmginfo_or_data, physobj)
                        end
                    end
                elseif hbox.Stage == 1 then
                    if hbox.CurHealth < 1 then
                        hbox.Stage = 2
                        if hbox.Bodygroup then
                            ent:SetBodygroup(
                                hbox.Bodygroup,
                                ent:GetBodygroup(hbox.Bodygroup) + 1
                            )
                        end
                        if hbox.OnHit then
                            hbox.OnHit(hbox, ent)
                        end
                        if physical then
                            hbox.OnPhysicsCollide(hbox, ent, dmginfo_or_data, physobj)
                        end
                        if hbox.TypeFlag == 1 then
                            local damagePosWorld = ent:LocalToWorld(damagePos)
                            sound.Play("Glass.BulletImpact", damagePosWorld, 75, 100, 1)
                            local effectdata = EffectData()
                            effectdata:SetOrigin(damagePosWorld)
                            util.Effect("shb_glassbreak", effectdata)
                        else
                            if hbox.GibModel and hbox.GibOffset then
                                local gib = ents.Create("prop_physics")
                                gib:SetModel(hbox.GibModel)
                                gib:SetPos(
                                    ent:LocalToWorld(hbox.GibOffset)
                                )
                                gib:SetAngles(
                                    ent:GetAngles()
                                )
                                gib:Spawn()
                                gib:Activate()
                                ent:CallOnRemove(
                                    "simfphys_hitbox_gib_" .. tostring(hbox_key),
                                    function()
                                        if IsValid(ent.Gib) then
                                            ent.Gib:DeleteOnRemove(gib)
                                        else
                                            SafeRemoveEntity(gib)
                                        end
                                    end
                                )
                                gib:SetSkin(
                                    ent:GetSkin()
                                )
                                if _G.ProxyColor then
                                    timer.Simple(
                                        0,
                                        function()
                                            gib:SetProxyColor(
                                                ent:GetProxyColor()
                                            )
                                        end
                                    )
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    function SHB.Init(ent, hboxes)
        print("Initializing hitboxes")
        ent.HitBoxes = hboxes
        for hbox_key in pairs(ent.HitBoxes) do
            local hbox = ent.HitBoxes[hbox_key]
            if (hbox.OBBMin and hbox.OBBMax) and hbox.BDGroup then
                hbox.HBMax = hbox.OBBMax
                hbox.HBMin = hbox.OBBMin
                hbox.Bodygroup = hbox.BDGroup
                hbox.nakstyle = true
                hbox.Stages = {{bodygroups = {[hbox.Bodygroup] = 0}}, {bodygroups = {[hbox.Bodygroup] = 1}}, {bodygroups = {[hbox.Bodygroup] = 2}, gib = true}}
            end
            hbox.CurHealth = hbox.Health
            hbox.Stage = 0
            hbox.OnPhysicsCollide = hbox.OnPhysicsCollide or defaultOnCollide
        end
        local oldPhysicsCollide
        oldPhysicsCollide = ent.PhysicsCollide
        ent.PhysicsCollide = function(ent, data, physobj)
            if SHB.IsValidCollideEntity(ent) then
                local spd = (data.Speed + data.OurOldVelocity:Length()) + data.TheirOldVelocity:Length()
                local dmgmult = math.Round(spd / 30, 0)
                local damagePos = ent:WorldToLocal(data.HitPos)
                if data.DeltaTime > 0.2 then
                    SHB.TakeDamage(ent, damagePos, dmgmult, true, data, physobj)
                end
            end
            oldPhysicsCollide(ent, data, physobj)
        end
        local oldOnTakeDamage
        oldOnTakeDamage = ent.OnTakeDamage
        ent.OnTakeDamage = function(ent, dmginfo)
            SHB.TakeDamage(
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
        local oldOnDestoyed
        oldOnDestoyed = ent.OnDestroyed
        ent.OnDestroyed = function(car)
            for hbox_key in pairs(car.HitBoxes) do
                local hbox = car.HitBoxes[hbox_key]
                if (hbox.GibModel and hbox.GibOffset) and (not (hbox.Stage == 2)) then
                    if hbox.Bodygroup then
                        car.Gib:SetBodygroup(
                            hbox.Bodygroup,
                            car.Gib:GetBodygroup(hbox.Bodygroup) + 1
                        )
                    end
                    local gib = ents.Create("prop_physics")
                    gib:SetModel(hbox.GibModel)
                    gib:SetPos(
                        car.Gib:LocalToWorld(hbox.GibOffset)
                    )
                    gib:SetAngles(
                        car.Gib:GetAngles()
                    )
                    gib:SetColor(
                        car.Gib:GetColor()
                    )
                    gib:SetSkin(
                        car.Gib:GetSkin()
                    )
                    gib:SetVelocity(
                        car.Gib:GetVelocity()
                    )
                    gib:Spawn()
                    car.Gib:DeleteOnRemove(gib)
                    if _G.ProxyColor then
                        local proxycolor = ent:GetProxyColor()
                        timer.Simple(
                            0,
                            function()
                                gib:SetProxyColor(proxycolor)
                            end
                        )
                    end
                    hbox.Gib = gib
                end
                if hbox.OnDestroyed then
                    hbox.OnDestroyed(car, hbox)
                end
            end
            oldOnDestoyed(car)
        end
        if ent.OnRepaired then
            local oldOnRepaired
            oldOnRepaired = ent.OnRepaired
            ent.OnRepaired = function(car)
                for hbox_key in pairs(car.HitBoxes) do
                    local hbox = car.HitBoxes[hbox_key]
                    if hbox.OnRepair then
                        hbox.OnRepair(hbox, car)
                    end
                end
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
                                local oldSetDamaged
                                oldSetDamaged = wheel.SetDamaged
                                wheel.SetDamaged = function(wheel, value)
                                    if not value then
                                        if IsValid(ent) then
                                            for hbox_key in pairs(ent.HitBoxes) do
                                                local hbox = ent.HitBoxes[hbox_key]
                                                if hbox.OnRepair then
                                                    hbox.OnRepair(hbox, ent)
                                                end
                                            end
                                        end
                                    end
                                    oldSetDamaged(wheel, value)
                                end
                            end
                        end
                    end
                end
            )
        end
        net.Start("simfphys_hitbox")
        net.WriteEntity(ent)
        net.WriteUInt(
            table.Count(ent.HitBoxes),
            32
        )
        for hbox_key in pairs(ent.HitBoxes) do
            local hbox = ent.HitBoxes[hbox_key]
            PrintTable(hbox)
            if hbox.HBMin and hbox.HBMax then
                net.WriteVector(hbox.HBMin)
                net.WriteVector(hbox.HBMax)
            end
        end
        net.Broadcast()
    end
end
list.Set(
    "FLEX",
    "HitBoxes",
    function(ent, flex)
        SHB.Init(ent, flex)
    end
)
entMeta = FindMetaTable("Entity")
entMeta.NAKHitboxDmg = function(self)
    SHB.Init(self, self.NAKHitboxes)
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
