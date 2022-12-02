--Biomi09 GTA:SA Blade
--https://steamcommunity.com/sharedfiles/filedetails/?id=1424438134
list.Set("nak_simf_hitboxes", "blade", {
	Hood = {
		OBBMin = Vector(-8, -2, 10),
		OBBMax = Vector(8, 0, -2),
		HitboxID = 13,
		TypeFlag = 0,
		BDGroup = 3,
		Health = 120
	},
	Trunk = {
		OBBMin = Vector(-10, 0, 10),
		OBBMax = Vector(10, 2, -2),
		HitboxID = 15,
		TypeFlag = 0,
		BDGroup = 4,
		Health = 120
	},
	BumperF = {
		OBBMin = Vector(-5, 10, -5),
		OBBMax = Vector(5, 8, 5),
		HitboxID = 17,
		TypeFlag = 0,
		BDGroup = 5,
		Health = 60
	},
	BumperR = {
		OBBMin = Vector(-2, -5, -5),
		OBBMax = Vector(2, 0, 5),
		HitboxID = 18,
		TypeFlag = 0,
		BDGroup = 6,
		Health = 60
	},
	Doors = {
		OBBMin = Vector(0, 0, 0),
		OBBMax = Vector(5, 2, 5),
		HitboxID = 10,
		TypeFlag = 0,
		BDGroup = 1,
		Health = 100,
		Mirror = Vector(-1, 1, 1),
		BDGroup_2 = 2,
	},
	Windsheild = {		
		OBBMin = Vector(-45, 42, 22),
		OBBMax = Vector(45, 12, 4),
		TypeFlag = 1,
		BDGroup = 7,
		Health = 6,
		ShatterPos = Vector(22.645, 0, 21.77)
	},
	GasTank = {
		OBBMin = Vector(-26, -63, 0),
		OBBMax = Vector(-46, -73, 8),
		TypeFlag = 2
	},
})

local tweaklist = {

	--engine start configuration
	snd_engine_start = "gtasa/sfx/engine_start.wav",
	
	--damaged engine sound configuration
	snd_engine_damaged = "gtasa/sfx/engine_damaged_loop.wav",
	
	--wheel skid configuration
	skid_sounds = {
		snd_skid = "gtasa/sfx/tireskid.wav",
		snd_skid_dirt = "gtasa/sfx/tire_dirt.wav",
		snd_skid_grass = "gtasa/sfx/tire_grass.wav",
	},
	
	--reverse whine configuration
	snd_reverse_whine = "gtasa/vehicles/reverse_gear.wav",
	
	--reverse beep
	snd_reverse_beep = "gtasa/vehicles/reverse_beep.wav",

	--upside down explosion timer
	flipped_tick_check = true,
	
	--disables air control & vehicle flipping (waiting on simfphys update)
	disable_air_control = true,
	
	--change default tiresmoke color (simfphys doesnt allow in spawnlist)
	-- tiresmoke_color = Color(255,0,0),
	
	--fire sound
	snd_fire = "NAK_GTASA.Fire",
	--explosion sound
	snd_explosion = "NAK_GTASA.Explosion",
	--collision sounds
	snd_collision = {
		snd_soft_impact = "NAK_GTASA.Damage",
		snd_hard_impact = "NAK_GTASA.Damage",
		snd_flesh_impact = "NAK_GTASA.Damage",
	},

	--[[
	
	--scale wheel model (only works when first spawned, might mess with dupes)
	--requires custom wheel models
	ghostwheel_scale = {
		--scale, deltatime 
		fl_scale = {0.86,0},
		fr_scale = {0.86,0},
		rl_scale = {0.86,0},
		rr_scale = {0.86,0},
		
		--optional (if have middle wheels)
		-- ml_scale = {0.86,0},
		-- mr_scale = {0.86,0},
	},
	
	--]]
}

list.Set("nak_simf_tweaks", "blade", tweaklist)
list.Set("nak_simf_tweaks", "sim_fphys_gtasa_admiral", tweaklist)

local HitboxList = {
	Hood = {
		OBBMin = Vector(36.187, -38, -8),
		OBBMax = Vector(100, 38, 11),
		TypeFlag = 0,
		BDGroup = 1,
		GibModel = "models/gtasa/vehicles/admiral/bonnet_dam.mdl",
		GibOffset = Vector(42, 0, 10),
		Health = 120
	},
	Trunk = {
		OBBMin = Vector(-108, -40, -8),
		OBBMax = Vector(-75.137, 40, 10),
		TypeFlag = 0,
		BDGroup = 2,
		GibModel = "models/gtasa/vehicles/admiral/boot_dam.mdl",
		GibOffset = Vector(-80, 0, 10),
		Health = 120
	},
	BumperF = {
		OBBMin = Vector(79.655, -42, -25),
		OBBMax = Vector(100, 42, -4),
		TypeFlag = 0,
		BDGroup = 3,
		GibModel = "models/gtasa/vehicles/admiral/bump_front_dam.mdl",
		GibOffset = Vector(97, -34, -8),
		Health = 60
	},
	BumperR = {
		OBBMin = Vector(-110, 39.112, -6),
		OBBMax = Vector(-96, -39.112, -20),
		TypeFlag = 0,
		BDGroup = 4,
		GibModel = "models/gtasa/vehicles/admiral/bump_rear_dam.mdl",
		GibOffset = Vector(-97, 34, -8),
		Health = 60
	},
	FDoor = {
		OBBMin = Vector(31.641, 40.466, -15.112),
		OBBMax = Vector(-13.111, 25, 32),
		TypeFlag = 0,
		BDGroup = 5,
		GibModel = "models/gtasa/vehicles/admiral/door_lf_dam.mdl",
		GibOffset = Vector(30, 40, 0),
		Health = 100,

		Mirror = Vector(1, -1, 1), -- // Vector(-15,40,0) * Vector(1,-1,1) = Vector(-15,-40,0) || multiplies it!!
		BDGroup_2 = 7,
		GibModel_2 = "models/gtasa/vehicles/admiral/door_rf_dam.mdl"
	},
	RDoor = {
		OBBMin = Vector(-13.975, 40.466, -15.112),
		OBBMax = Vector(-52.503, 25, 32),
		TypeFlag = 0,
		BDGroup = 6,
		GibModel = "models/gtasa/vehicles/admiral/door_lr_dam.mdl",
		GibOffset = Vector(-15, 40, 0),
		Health = 100,

		Mirror = Vector(1, -1, 1), -- // Vector(-15,40,0) * Vector(1,-1,1) = Vector(-15,-40,0) || multiplies it!!
		BDGroup_2 = 8,
		GibModel_2 = "models/gtasa/vehicles/admiral/door_rr_dam.mdl"
	},
	Windsheild = {
		OBBMin = Vector(38.901, 34.251, 9.725),
		OBBMax = Vector(10.353, -34.251, 27.39),
		TypeFlag = 1, -- //glass or window
		BDGroup = 9,
		Health = 6,
		ShatterPos = Vector(22.645, 0, 21.77)
	},
	Tank = {
		OBBMin = Vector(-69.348, 36, 7.3),
		OBBMax = Vector(-74.554, 39.024, 2.377),
		TypeFlag = 2 -- //gas tank
	}
}
list.Set("nak_simf_hitboxes", "sim_fphys_gtasa_admiral", HitboxList)