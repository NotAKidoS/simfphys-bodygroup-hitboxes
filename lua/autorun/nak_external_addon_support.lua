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
	Gascap = {
		OBBMin = Vector(-26, -63, 0),
		OBBMax = Vector(-46, -73, 8),
		TypeFlag = 2
	}
})

list.Set("nak_simf_tweaks", "blade", {

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
	-- snd_reverse_beep = "gtasa/vehicles/reverse_gear.wav",

	--upside down explosion timer
	flipped_tick_check = true,
	
	--disables air control & vehicle flipping (waiting on simfphys update)
	disable_air_control = true,
})

