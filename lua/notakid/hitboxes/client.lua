--[[
	Client file, stuff only the client needs
	Supine optimized this a fuckton, used to drop to like 10 fps
]]

--Hook so the client can see hitboxes on vehicles
hook.Add( "OnEntityCreated", "NAKSimfCLHitbox", function(ent)
	if ent:GetClass() ~= "gmod_sent_vehicle_fphysics_base" then return end
	timer.Simple( 1, function()
		local HBInfo = NAK.GetHitboxes(ent)
		if HBInfo then
			ent.NAKHitboxes = HBInfo
		end
	end)
end)

--Networking related stuff below

net.Receive( "nak_glassbreak_fx", function(length)
	local self = net.ReadEntity()
	local ShatterPos = self:LocalToWorld(net.ReadVector())
	if IsValid(self) then
		local effectdata = EffectData()
		effectdata:SetOrigin(ShatterPos)
		util.Effect("simf_gtasa_glassbreak", effectdata)
	end
end)

local function initializeHitboxesRenderer()
    local nak_simf_hitboxes = CreateConVar( "nak_simf_hitboxes", 0, {FCVAR_ARCHIVE, FCVAR_ARCHIVE_XBOX}, "Debug Simfphys hitboxes for supported vehicles", 0, 1 )
    local nak_simf_hitboxes_filled = CreateConVar( "nak_simf_hitbox_filled", 1, {FCVAR_ARCHIVE, FCVAR_ARCHIVE_XBOX}, "Filled boxes?\nrequires nak_simf_hitbox_reload", 0, 1 ):GetBool()
    local nak_simf_hitboxes_wireframe = CreateConVar( "nak_simf_hitbox_wireframe", 1, {FCVAR_ARCHIVE, FCVAR_ARCHIVE_XBOX}, "Wireframe boxes?\nrequires nak_simf_hitbox_reload", 0, 1 ):GetBool()
    local veccolor = util.StringToType( CreateConVar( "nak_simf_hitbox_color", "255 255 255", {FCVAR_ARCHIVE, FCVAR_ARCHIVE_XBOX}, "Set a color for the box AS A STRING '255,255,255'\nrequires nak_simf_hitbox_reload" ):GetString(), "Vector" )
    local alpha = CreateConVar( "nak_simf_hitbox_alpha", 100, {FCVAR_ARCHIVE, FCVAR_ARCHIVE_XBOX}, "Set the alpha of the hitbox\nrequires nak_simf_hitbox_reload", 0, 255 ):GetFloat()
    
	hook.Remove("PostDrawTranslucentRenderables", "nak_simf_hitboxes")
    hook.Remove("PostDrawOpaqueRenderables", "nak_simf_hitboxes")
    
	local color = Color(veccolor.x, veccolor.y, veccolor.z, alpha)
    
	if nak_simf_hitboxes_filled then
        hook.Add( "PostDrawTranslucentRenderables", "nak_simf_hitboxes", function()
			if nak_simf_hitboxes:GetBool() then
				render.SetColorMaterial()
				--[[WIKI: 
				Gets all entities with the given class, supports wildcards. 
				This works internally by iterating over ents.GetAll. 
				Even if internally ents.GetAll is used, It is faster to use ents.FindByClass than ents.GetAll with a single class comparison.
				]]
				for k, ent in pairs(ents.FindByClass("gmod_sent_vehicle_fphysics_base")) do 
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
							render.DrawBox(entPos, entAngles, HBInfo[key].OBBMin, HBInfo[key].OBBMax, color, true)
						end
					end
				end
			end
		end)
    end
	
    if nak_simf_hitboxes_wireframe then
        hook.Add( "PostDrawOpaqueRenderables", "nak_simf_hitboxes", function()
			if nak_simf_hitboxes:GetBool() then
				render.SetColorMaterial()
				for k, ent in pairs(ents.FindByClass("gmod_sent_vehicle_fphysics_base")) do --WIKI: Gets all entities with the given class, supports wildcards. This works internally by iterating over ents.GetAll. Even if internally ents.GetAll is used, It is faster to use ents.FindByClass than ents.GetAll with a single class comparison.
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
							render.DrawWireframeBox(
								entPos,
								entAngles,
								HBInfo[key].OBBMin,
								HBInfo[key].OBBMax,
								color,
								true
							)
						end
					end
				end
			end
		end)
    end
end

initializeHitboxesRenderer()
concommand.Add("nak_simf_hitbox_reload", initializeHitboxesRenderer, nil, "updates settings for hitbox renderer")