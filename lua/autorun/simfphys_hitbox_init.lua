version_MAJOR = 1
version_MINOR = 0
version_PATCH = 0
version_TAG = "alpha"
print(
    (((((("simphys hitboxes " .. tostring(version_MAJOR)) .. ".") .. tostring(version_MINOR)) .. ".") .. tostring(version_PATCH)) .. "-") .. tostring(version_TAG)
)
AddCSLuaFile()
function addCSLuaFile(filename)
    if SERVER then
        AddCSLuaFile(filename)
    else
        include(filename)
    end
end
addCSLuaFile("hitbox/cl_hitbox_renderer.lua")
if SERVER then
    include("hitbox/sv_networking.lua")
    include("hitbox/sv_hitbox.lua")
end
