--[[
	 _            _  _          _    _
	| |__    ___ | || |  ___   | |_ | |__    ___  _ __  ___
	| '_ \  / _ \| || | / _ \  | __|| '_ \  / _ \| '__|/ _ \
	| | | ||  __/| || || (_) | | |_ | | | ||  __/| |  |  __/
	|_| |_| \___||_||_| \___/   \__||_| |_| \___||_|   \___|

	This base code is written by NotAKid (on steam). Prolly bad ik.

	Please do not redistribute this base code in your addons, contact me first.
	You probably don't want code written by a 16 year old with a smol brain anyways lol.

	Contact:
		NotAKid - Steam
		NotAKidoS#0792 - Discord 

	GitHub:
		https://github.com/NotAKidOnSteam/simfphys-bodygroup-hitboxes

	Disclaimer:
		This is by a kid with little knowledge on the Do's and Don'ts of GLUA, so please do not expect anything to be proper.
		This addon heavily relies on being able to override functions on Simfphys vehicles when spawned. May one day
		cause issues if Simfphys ever has a major update.

	That is all, thank you for reading. -NotAKidoS
--]]
local function loadshared(loadfile)
	AddCSLuaFile(loadfile)
	include(loadfile)
end
loadshared('notakid/gtasa/init.lua')
loadshared('notakid/hitboxes/init.lua')

hook.Add( "simfphysOnSpawn", "NAKSimfHitboxOnSpawn", function( ent )
	if NAK.GetHitboxes(ent) then NAK.AddHitboxes(ent) NAK.SimfGTASA(ent) end
end )

local HitboxList = {
	Hood = {
		OBBMin = Vector(-52, -35, 16),
		OBBMax = Vector(-101, 35, 9),
		TypeFlag = 0,
		BDGroup = 3,
		GibModel = "models/A31/GTADE/GTA3/Vehicles/Parts/Cartel_bonnet.mdl",
		GibOffset = Vector(-42, 0, 10),
		Health = 120
	},
	Trunk = {
		OBBMin = Vector(109.8,-35,14.8),
		OBBMax = Vector(102,35,-5),
		TypeFlag = 0,
		BDGroup = 2,
		GibModel = "models/A31/GTADE/GTA3/Vehicles/Parts/Cartel_boot.mdl",
		GibOffset = Vector(80, 0, 10),
		Health = 120
	},
	BumperF = {
		OBBMin = Vector(-89,-43,-6),
		OBBMax = Vector(-110,43,-23),
		TypeFlag = 0,
		BDGroup = 1,
		GibModel = "models/A31/GTADE/GTA3/Vehicles/Parts/Cartel_Bumpf.mdl",
		GibOffset = Vector(97, -34, -8),
		Health = 60
	},
	BumperR = {
		OBBMin = Vector(89,43,-5),
		OBBMax = Vector(110,-43,-24),
		TypeFlag = 0,
		BDGroup = 0,
		GibModel = "models/A31/GTADE/GTA3/Vehicles/Parts/Cartel_BumpR.mdl",
		GibOffset = Vector(97, 34, -8),
		Health = 60
	},
	FDoor = {
		OBBMin = Vector(2.6,43,-19),
		OBBMax = Vector(-48,33,24),
		TypeFlag = 0,
		BDGroup = 6,
		GibModel = "models/A31/GTADE/GTA3/Vehicles/Parts/Cartel_DOORLF.mdl",
		GibOffset = Vector(30, 40, 0),
		Health = 100,

		Mirror = Vector(1, -1, 1), -- // Vector(-15,40,0) * Vector(1,-1,1) = Vector(-15,-40,0) || multiplies it!!
		BDGroup_2 = 4,
		GibModel_2 = "models/A31/GTADE/GTA3/Vehicles/Parts/Cartel_DOORRF.mdl"
	},
	RDoor = {
		OBBMin = Vector(2.6,43,-19),
		OBBMax = Vector(46,33,24),
		TypeFlag = 0,
		BDGroup = 7,
		GibModel = "models/A31/GTADE/GTA3/Vehicles/Parts/Cartel_DOORLR.mdl",
		GibOffset = Vector(-15, 40, 0),
		Health = 100,

		Mirror = Vector(1, -1, 1), -- // Vector(-15,40,0) * Vector(1,-1,1) = Vector(-15,-40,0) || multiplies it!!
		BDGroup_2 = 5,
		GibModel_2 = "models/A31/GTADE/GTA3/Vehicles/Parts/Cartel_DOORRR.mdl"
	},
	Wings = {
		OBBMin = Vector(-52,-43.5,-6),
		OBBMax = Vector(-97,-35,12),
		TypeFlag = 0,
		BDGroup = 8,
		GibModel = "models/A31/GTADE/GTA3/Vehicles/Parts/Cartel_WINGLF.mdl",
		GibOffset = Vector(-15, 40, 0),
		Health = 100,

		Mirror = Vector(1, -1, 1), -- // Vector(-15,40,0) * Vector(1,-1,1) = Vector(-15,-40,0) || multiplies it!!
		BDGroup_2 = 9,
		GibModel_2 = "models/A31/GTADE/GTA3/Vehicles/Parts/Cartel_WINGRF.mdl"
	},
	Windsheild = {
		OBBMin = Vector(-30,-31,34),
		OBBMax = Vector(-51,34,16),
		TypeFlag = 1, -- //glass or window
		BDGroup = 10,
		Health = 6,
		ShatterPos = Vector(-43, 0, 24)
	},
}
list.Set("nak_simf_hitboxes", "sim_fphys_31GTADE3_Cartel1", HitboxList)