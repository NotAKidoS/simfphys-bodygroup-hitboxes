-- Lua Library inline imports
function __TS__ArrayForEach(arr, callbackFn)
    do
        local i = 0
        while i < #arr do
            callbackFn(_G, arr[i + 1], i, arr)
            i = i + 1
        end
    end
end

net.Receive(
    "simfphys_hitbox",
    function(len)
        local ent = net.ReadEntity()
        if IsValid(ent) then
            ent.HitBoxes = {}
            local hboxcount = net.ReadUInt(32)
            print("count is ", hboxcount, "len is", len)
            do
                local i = 0
                while i < hboxcount do
                    local vec1 = net.ReadVector()
                    local vec2 = net.ReadVector()
                    if isvector(vec1) and isvector(vec2) then
                        table.insert(ent.HitBoxes, {HBMin = vec1, HBMax = vec2})
                    else
                    end
                    i = i + 1
                end
            end
            PrintTable(ent.HitBoxes)
        end
    end
)
function HitboxRenderer()
    local shb_hitbox_filled = CreateConVar(
        "shb_filled",
        "0",
        bit.bor(FCVAR_ARCHIVE, FCVAR_ARCHIVE_XBOX),
        "Filled hitboxes?",
        0,
        1
    ):GetBool()
    local shb_hitbox_wire = CreateConVar(
        "shb_wire",
        "0",
        bit.bor(FCVAR_ARCHIVE, FCVAR_ARCHIVE_XBOX),
        "Wireframe hitboxes?",
        0,
        1
    ):GetBool()
    local colorvector = util.StringToType(
        CreateConVar(
            "shb_color",
            "255 255 255",
            bit.bor(FCVAR_ARCHIVE, FCVAR_ARCHIVE_XBOX),
            "Set a color for the box AS A STRING '255,255,255'"
        ):GetString(),
        "Vector"
    )
    local alpha = CreateConVar(
        "shb_alpha",
        "100",
        bit.bor(FCVAR_ARCHIVE, FCVAR_ARCHIVE_XBOX),
        "Set the alpha of the hitbox",
        0,
        255
    ):GetFloat()
    local color = Color(colorvector.x, colorvector.y, colorvector.z, alpha)
    hook.Remove("PostDrawTranslucentRenderables", "simfphys_hitbox")
    hook.Remove("PostDrawOpaqueRenderables", "simfphys_hitbox")
    if shb_hitbox_filled then
        hook.Add(
            "PostDrawTranslucentRenderables",
            "simfphys_hitbox",
            function()
                render.SetColorMaterial()
                __TS__ArrayForEach(
                    ents.FindByClass("gmod_sent_vehicle_fphysics_base"),
                    function(____, car)
                        if car.HitBoxes then
                            local pos = car:GetPos()
                            local angles = car:GetAngles()
                            for hbox_key in pairs(car.HitBoxes) do
                                local hbox = car.HitBoxes[hbox_key]
                                render.DrawBox(pos, angles, hbox.HBMin, hbox.HBMax, color)
                            end
                        end
                    end
                )
            end
        )
    end
    if shb_hitbox_wire then
        hook.Add(
            "PostDrawOpaqueRenderables",
            "simfphys_hitbox",
            function()
                render.SetColorMaterial()
                __TS__ArrayForEach(
                    ents.FindByClass("gmod_sent_vehicle_fphysics_base"),
                    function(____, car)
                        if car.HitBoxes then
                            local pos = car:GetPos()
                            local angles = car:GetAngles()
                            for hbox_key in pairs(car.HitBoxes) do
                                local hbox = car.HitBoxes[hbox_key]
                                render.DrawWireframeBox(pos, angles, hbox.HBMin, hbox.HBMax, color, true)
                            end
                        end
                    end
                )
            end
        )
    end
end
HitboxRenderer()
cvars.AddChangeCallback("shb_filled", HitboxRenderer)
cvars.AddChangeCallback("shb_wire", HitboxRenderer)
cvars.AddChangeCallback("shb_color", HitboxRenderer)
cvars.AddChangeCallback("shb_alpha", HitboxRenderer)
