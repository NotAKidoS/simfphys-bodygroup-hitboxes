local V = {
	Name = "Blista Compact",
	Model = "models/gtasa/vehicles/blistac/blistac.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA:SA - Coupes/Hatchbacks",
	SpawnOffset = Vector(0,0,10),
	SpawnAngleOffset = 90,
	NAKGame = "GTA:SA",
	NAKType = "Coupes/Hatchbacks",
	
	FLEX = {
		Trailers = {
			outputPos = Vector(-85,0,-9),
			outputType = "ballsocket",
		}
	},
	
	Members = {
		Mass = 1000,
		
		GibModels = {
			"models/gtasa/vehicles/blistac/chassis.mdl",
			"models/gtasa/vehicles/blistac/wheel.mdl",
			"models/gtasa/vehicles/blistac/wheel.mdl",
			"models/gtasa/vehicles/blistac/wheel.mdl",
			"models/gtasa/vehicles/blistac/wheel.mdl",
		},
		
		EnginePos = Vector(55.92,0,6.04),
		
		LightsTable = "gtasa_blistac",
		
		NAKHitboxes = {
			Hood = {
				OBBMin = Vector(90,42,-18), 
				OBBMax = Vector(33,-42,16), 
				BDGroup = { 1,10,11 },
				GibModel = "models/gtasa/vehicles/blistac/bonnet_dam.mdl", 
				GibOffset = Vector(27.86,0,10.69), 
				Health = 120 ,
			},
			Trunk = {
				OBBMin = Vector(-82,-42,-15), 
				OBBMax = Vector(-39,42,31), 
				BDGroup = {2, 12}, 
				GibModel = "models/gtasa/vehicles/blistac/boot_dam.mdl", 
				GibOffset = Vector(-39.75,0,28.84), 
				Health = 120 
			},

			BumperF = {
				OBBMin = Vector(92,42,-19), 
				OBBMax = Vector(61,-42,0), 
				BDGroup = 3, 
				GibModel = "models/gtasa/vehicles/blistac/bump_front_dam.mdl", 
				GibOffset = Vector(64.46,38.20,-1.93), 
				Health = 100 
			},
			BumperR = {
				OBBMin = Vector(-65,-42,0), 
				OBBMax = Vector(-83,42,-19), 
				BDGroup = 4, 
				GibModel = "models/gtasa/vehicles/blistac/bump_rear_dam.mdl", 
				GibOffset = Vector(-63.8,-38.57,-2.08), 
				Health = 100 
			},
			Door = {
				OBBMin = Vector(-34,44,28), 
				OBBMax = Vector(34,18,-18), 
				BDGroup = 5, 
				GibModel = "models/gtasa/vehicles/blistac/door_lf_dam.mdl", 
				GibOffset = Vector(30.34,37.67,-1.91), 
				Health = 100,
				
				Mirror = Vector(1,-1,1), --// Vector(-15,40,0) * Vector(1,-1,1) = Vector(-15,-40,0) || multiplies it!!
				BDGroup_2 = 6,
				GibModel_2 = "models/gtasa/vehicles/blistac/door_rf_dam.mdl"
			},
			Windsheild = {
				OBBMin = Vector(7,41,30), 
				OBBMax = Vector(33,-37,13),
				TypeFlag = 1, --//glass or window
				BDGroup = 7, 
				Health = 6, 
				ShatterPos=Vector(16.643,0,19.497) 
			},
			FuelCap = {
				OBBMin = Vector(-62,-47,10), 
				OBBMax = Vector(-74,-27,0), 
				TypeFlag = 2 --//gas tank 
			},
		},
			
		OnSpawn = function(ent)
			ent:SetBodyGroups("00000000002280" )
			
			ent:NAKSimfGTASA() -- function that'll do all the GTASA changes for you
			ent:NAKHitboxDmg() -- function that'll activate the hitboxes
			
			if ( ProxyColor ) then
				local CarCols = {}
				CarCols[1] = {Color(96,26,35),Color(88,88,83)}
				CarCols[2] = {Color(52,26,30),Color(88,88,83)}
				CarCols[3] = {Color(22,34,72),Color(158,164,171)}
				CarCols[4] = {Color(45,58,53),Color(159,157,148)}
				CarCols[5] = {Color(105,30,59),Color(105,30,59)}
				CarCols[6] = {Color(59,78,120),Color(59,78,120)}
				CarCols[7] = {Color(94,112,114),Color(214,218,214)}
				CarCols[8] = {Color(0,0,0),Color(0,0,0)}
				ent:SetProxyColor( CarCols[math.random(1,8)] )
			end
		end,
		
		OnTick = function(ent)
			if ent.horn then
				ent.horn:ChangePitch( 112, 0 )
			end
		end,
		
		CustomWheels = true,
		CustomSuspensionTravel = 1.5,
			
		CustomWheelModel = "models/gtasa/vehicles/blistac/wheel.mdl",
		
		CustomWheelPosFL = Vector(53.14,33.21,-12),
		CustomWheelPosFR = Vector(53.14,-33.21,-12),	
		CustomWheelPosRL = Vector(-51.51,33.21,-12),
		CustomWheelPosRR = Vector(-51.51,-33.21,-12),
		CustomWheelAngleOffset = Angle(0,90,0),
		
		CustomMassCenter = Vector(0,0,0),		
		
		CustomSteerAngle = 45,
		
		SeatOffset = Vector(-14,-19,17),
		SeatPitch = -8,
		SeatYaw = 90,
		
		PassengerSeats = {
			{
				pos = Vector(-5,-19,-15),
				ang = Angle(0,-90,20)
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-79.43,-20.39,-18.09),
				ang = Angle(-90,0,0),
			},
		},
		Attachments = {
			{
				model = "models/gtasa/vehicles/blistac/steering.mdl",
				color = Color(255,255,255,255),
				pos = Vector(0,0,0),
				ang = Angle(0,0,0)
			},
		},
		
		FrontHeight = 6,
		FrontConstant = 50000,
		FrontDamping = 750,
		FrontRelativeDamping = 800,
		
		RearHeight = 6,
		RearConstant = 50000,
		RearDamping = 750,
		RearRelativeDamping = 800,
		
		FastSteeringAngle = 25,
		SteeringFadeFastSpeed = 350,
		
		TurnSpeed = 4,
		
		MaxGrip = 43,
		Efficiency = 1,
		GripOffset = 0,
		BrakePower = 35,
		BulletProofTires = false,
		
		IdleRPM = 650,
		LimitRPM = 5500,
		PeakTorque = 200,
		PowerbandStart = 2000,
		PowerbandEnd = 5000,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,
		
		FuelFillPos = Vector(-68.61,-39.14,5.5),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 75,
		
		PowerBias = -1,
		
		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = "gtasa/vehicles/86-87_idle.wav",
		
		snd_low = "gtasa/vehicles/86-87_cruise.wav",
		snd_low_revdown = "gtasa/vehicles/86-87_cruise_loop.wav",
		snd_low_pitch = 1,
		
		snd_mid = "gtasa/vehicles/86-87_gear_loop.wav",
		snd_mid_gearup = "gtasa/vehicles/86-87_gear.wav",
		snd_mid_pitch = 0.95,
		
		snd_horn = "gtasa/vehicles/horns/horn_009.wav",
		
		DifferentialGear = 0.22,
		Gears = {-0.15,0,0.15,0.35,0.5,0.75,0.85}
	}
}
list.Set( "simfphys_vehicles", "sim_fphys_gtasa_blistac", V )

local light_table = {
	L_HeadLampPos = Vector(80.71,26.02,1.19),
	L_HeadLampAng = Angle(17,0,0),
	R_HeadLampPos = Vector(80.71,-26.02,1.19),
	R_HeadLampAng = Angle(10,0,0),
	
	L_RearLampPos = Vector(-79,28.02,2.72),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-79,-28.02,2.72),
	R_RearLampAng = Angle(25,180,0),
	
	Headlight_sprites = {
		{
			pos = Vector(80.71,26.02,1.19),
			material = "sprites/light_ignorez",
			size = 60,
			color = Color(255,238,200,255),
		},
		{
			pos = Vector(80.71,-26.02,1.19),
			material = "sprites/light_ignorez",
			size = 60,
			color = Color(255,238,200,255),
		},
	},
	
	Headlamp_sprites = {
		{pos = Vector(80.71,26.02,1.19),size = 100,material = "sprites/light_ignorez"},
		{pos = Vector(80.71,-26.02,1.19),size = 100,material = "sprites/light_ignorez"},
	},
	
	FogLight_sprites = {
		{
			pos = Vector(86.5,26,-6),
			material = "sprites/light_ignorez",
			size = 50,
			color = Color(255,238,200,255),
			OnBodyGroups = { 
					[3] = {0},
				}
		},
		{
			pos = Vector(86.5,-26,-6),
			material = "sprites/light_ignorez",
			size = 50,
			color = Color(255,238,200,255),
			OnBodyGroups = { 
					[3] = {0},
				}
		},
	},
	
	Rearlight_sprites = {
		{
			pos = Vector(-79,28.02,2.72),
			material = "sprites/light_ignorez",
			size = 60,
			color = Color(255,0,0,255),
		},
		{
			pos = Vector(-79,-28.02,2.72),
			material = "sprites/light_ignorez",
			size = 60,
			color = Color(255,0,0,255),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-79,23,2.72),
			material = "sprites/light_ignorez",
			size = 70,
			color = Color(255,0,0,255),
		},
		{
			pos = Vector(-79,-23,2.72),
			material = "sprites/light_ignorez",
			size = 70,
			color = Color(255,0,0,255),
		},
	},
	
	DelayOn = 0,
	DelayOff = 0,
	
	Turnsignal_sprites = {
		Left = {
			{
				pos = Vector(82,35,1),
				material = "sprites/light_ignorez",
				size = 60,
				color = Color(255,135,0,255),
			},
			{
				pos = Vector(-79,32,2.72),
				material = "sprites/light_ignorez",
				size = 60,
				color = Color(255,0,0,255),
			},
		},
		Right = {
			{
				pos = Vector(82,-35,1),
				material = "sprites/light_ignorez",
				size = 60,
				color = Color(255,135,0,255),
			},
			{
				pos = Vector(-79,-32,2.72),
				material = "sprites/light_ignorez",
				size = 60,
				color = Color(255,0,0,255),
			},
		},
	},
	
	SubMaterials = {
		off = {
			Base = {
				[4] = ""
			},
		},
		on_lowbeam = {
			Base = {
				[4] = "models/gtasa/vehicles/share/vehiclelightson128"
			},
		},
	}
	
}
list.Set( "simfphys_lights", "gtasa_blistac", light_table)