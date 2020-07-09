local V = {
	Name = "Baggage",
	Model = "models/gtasa/vehicles/baggage/baggage.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA:SA - Public Service",
	SpawnOffset = Vector(0,0,10),
	SpawnAngleOffset = 90,
	NAKGame = "GTA:SA",
	NAKType = "Public Service",
	
	Members = {
		Mass = 1000.0,
		
		GibModels = {
			"models/gtasa/vehicles/baggage/chassis.mdl",
			-- "models/gtasa/vehicles/baggage/bonnet_dam.mdl",
			-- "models/gtasa/vehicles/baggage/bump_front_dam.mdl",
			-- "models/gtasa/vehicles/baggage/bump_rear_dam.mdl",
			"models/gtasa/vehicles/baggage/wheel.mdl",
			"models/gtasa/vehicles/baggage/wheel.mdl",
			"models/gtasa/vehicles/baggage/wheel.mdl",
			"models/gtasa/vehicles/baggage/wheel.mdl",
		},
		
		EnginePos = Vector(44.8,0,14.92),
		
		LightsTable = "gtasa_baggage",
		
		Trailers = {
			output = Vector(-62.97,0,-5.83)
		},
		
        OnSpawn = function(ent)
		
			if (file.Exists( "sound/trailers/trailer_connected.mp3", "GAME" )) then  --checks if sound file exists. will exist if dangerkiddys trailer base is subscribed.
				if ent.GetCenterposition != nil then
					ent:SetCenterposition(Vector(-62.97,0,-5.83))  -- position of center ballsocket for tow hitch(trailer coupling)
					ent:SetTrailerCenterposition(Vector(0,0,0)) -- position of center ballsocket for trailer hook
				end
			end		
			
			local hitboxes = {}
			hitboxes.hood = {min = Vector(20,34.1,29), max = Vector(72,-34.1,-8), bdgroup = 1, gibmodel = "models/gtasa/vehicles/baggage/bonnet_dam.mdl", giboffset = Vector(29.78,0,25.31), health=120 }
			hitboxes.bumperf = {min = Vector(72,-34.1,-3), max = Vector(59,34.1,-18), bdgroup = 2, gibmodel = "models/gtasa/vehicles/baggage/bump_front_dam.mdl", giboffset = Vector(63.48,-24.93,-9.18), health=60 }
			hitboxes.bumperr = {min = Vector(-63,34.1,-3), max = Vector(-50,-34.1,-18), bdgroup = 3, gibmodel = "models/gtasa/vehicles/baggage/bump_rear_dam.mdl", giboffset = Vector(-57.31,24.93,-9.19), health=60 }
			
			hitboxes.gastank = {min = Vector(21,37.1,6), max = Vector(32,20.9,-5), explode=true }
			
			ent:SetBodyGroups("0000"..math.random(0,1)..math.random(0,1)..math.random(0,1) ) --sets headphones/toolbox/gas whatnot
			
			ent:NAKAddHitBoxes(hitboxes)
			ent:NAKSimfGTASA() -- function that'll do all the GTASA changes for you
			
			if ( ProxyColor ) then
				local CarCols = {}
				CarCols[1] = {Color(245,245,245)}
				ent:SetProxyColor( CarCols[1] )
			end
		end,	
		
		OnTick = function(ent)
			if ent.horn then
				ent.horn:ChangePitch( 110, 0 )
			end
		end,
		
		CustomWheels = true,
		CustomSuspensionTravel = 1.5,
			
		CustomWheelModel = "models/gtasa/vehicles/baggage/wheel.mdl",
		
		CustomWheelPosFL = Vector(48.62,23.12,-11),
		CustomWheelPosFR = Vector(48.62,-23.12,-11),	
		CustomWheelPosRL = Vector(-36.44,23.12,-11),
		CustomWheelPosRR = Vector(-36.44,-23.12,-11),
		CustomWheelAngleOffset = Angle(0,90,0),
		
		CustomMassCenter = Vector(0,0,0),		
		
		CustomSteerAngle = 45,
		
		SeatOffset = Vector(-28,-5,35),
		SeatPitch = 15,
		SeatYaw = 90,
		
		ExhaustPositions = {
			{
				pos = Vector(43.46,-9.65,35.11),
				ang = Angle(0,0,0),
			},
		},
		
		FrontHeight = 5,
		FrontConstant = 50000,
		FrontDamping = 1000,
		FrontRelativeDamping = 350,
		
		RearHeight = 5,
		RearConstant = 50000,
		RearDamping = 1000,
		RearRelativeDamping = 800,
		
		FastSteeringAngle = 25,
		SteeringFadeFastSpeed = 200,
		
		TurnSpeed = 2,
		
		MaxGrip = 75,
		Efficiency = 1,
		GripOffset = 0,
		BrakePower = 35.5,
		BulletProofTires = false,
		
		IdleRPM = 600,
		LimitRPM = 4000,
		PeakTorque = 75,
		PowerbandStart = 1700,
		PowerbandEnd = 3500,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,
		
		FuelFillPos = Vector(26.44,33.01,0.72),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 50,
		
		PowerBias = 1,
		
		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = "gtasa/vehicles/4-5_idle.wav",
		
		snd_low = "gtasa/vehicles/4-5_cruise.wav",
		snd_low_revdown = "gtasa/vehicles/4-5_cruise_loop.wav",
		snd_low_pitch = 0.95,
		
		snd_mid = "gtasa/vehicles/4-5_gear_loop.wav",
		snd_mid_gearup = "gtasa/vehicles/4-5_gear.wav",
		snd_mid_pitch = 1.2,
		
		snd_horn = "gtasa/vehicles/horns/horn_002.wav",
		
		DifferentialGear = 0.12,
		Gears = {-0.22,0,0.5,1}
	}
}
list.Set( "simfphys_vehicles", "sim_fphys_gtasa_baggage", V )

local light_table = {
	L_HeadLampPos = Vector(64.25,23.52,1.61),
	L_HeadLampAng = Angle(17,0,0),
	R_HeadLampPos = Vector(64.25,-23.52,1.61),
	R_HeadLampAng = Angle(10,0,0),
	
	L_RearLampPos = Vector(-52.24,-26.33,4.42),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-52.24,-26.33,4.42),
	R_RearLampAng = Angle(25,180,0),
	
	Headlight_sprites = {
		{
			pos = Vector(64.25,23.52,1.61),
			material = "sprites/light_ignorez",
			size = 70,
			color = Color(255,238,200,255),
		},
		{
			pos = Vector(64.25,-23.52,1.61),
			material = "sprites/light_ignorez",
			size = 70,
			color = Color(255,238,200,255),
		},
	},
	
	Headlamp_sprites = {
		{pos = Vector(64.25,23.52,1.61),size = 100,material = "sprites/light_ignorez"},
		{pos = Vector(64.25,-23.52,1.61),size = 100,material = "sprites/light_ignorez"},
	},
	
	Rearlight_sprites = {
		{
			pos = Vector(-52.24,26.33,4.42),
			material = "sprites/light_ignorez",
			size = 60,
			color = Color(255,0,0,255),
		},
		{
			pos = Vector(-52.24,-26.33,4.42),
			material = "sprites/light_ignorez",
			size = 60,
			color = Color(255,0,0,255),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-52.24,26.33,4.42),
			material = "sprites/light_ignorez",
			size = 70,
			color = Color(255,0,0,255),
		},
		{
			pos = Vector(-52.24,-26.33,4.42),
			material = "sprites/light_ignorez",
			size = 70,
			color = Color(255,0,0,255),
		},
	},
	
	ems_sounds = {"common/null.wav"},
	ems_sprites = {
		{
			pos = Vector(-41,-18,42),
			material = "sprites/light_ignorez",
			size = 50,
			Colors = {
						Color(255,255,255,255),
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
						Color(0,0,0,0),
					},
			Speed = 0.065
		},
	},
	
	DelayOn = 0,
	DelayOff = 0,
	
	Turnsignal_sprites = {
		Left = {
			{
				pos = Vector(64.47,23,8.27),
				material = "sprites/light_ignorez",
				size = 60,
				color = Color(255,135,0,255),
			},
			{
				pos = Vector(-52.24,26.33,1.6),
				material = "sprites/light_ignorez",
				size = 60,
				color = Color(255,135,0,255),
			},
		},
		Right = {
			{
				pos = Vector(64.47,-23,8.27),
				material = "sprites/light_ignorez",
				size = 60,
				color = Color(255,135,0,255),
			},
			{
				pos = Vector(-52.24,-26.33,1.6),
				material = "sprites/light_ignorez",
				size = 60,
				color = Color(255,135,0,255),
			},
		},
	},
	
	SubMaterials = {
		off = {
			Base = {
				[3] = ""
			},
		},
		on_lowbeam = {
			Base = {
				[3] = "models/gtasa/vehicles/share/vehiclelightson128"
			},
		},
	}
}
list.Set( "simfphys_lights", "gtasa_baggage", light_table)