const version_MAJOR = 1
const version_MINOR = 0
const version_PATCH = 0
const version_TAG = "alpha"


print("simphys hitboxes " + version_MAJOR + "." + version_MINOR + "." + version_PATCH + "-" + version_TAG)

AddCSLuaFile()

function addCSLuaFile(this: void, filename: string) {
	if (SERVER) {
		AddCSLuaFile(filename)
	} else {
		include(filename)
	}
}
addCSLuaFile("hitbox/cl_hitbox_renderer.lua")
if (SERVER) {
	include("hitbox/sv_networking.lua")
	include("hitbox/sv_hitbox.lua")
}
