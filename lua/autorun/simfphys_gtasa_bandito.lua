local V = {
	Name = "Bandito",
	Model = "models/gtasa/vehicles/bandito/bandito.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "GTA:SA - Offroad",
	SpawnOffset = Vector(0,0,10),
	SpawnAngleOffset = 90,
	NAKGame = "GTA:SA",
	NAKType = "Offroad",
	
	Members = {
		Mass = 1500,
		
		GibModels = {
			"models/gtasa/vehicles/alpha/chassis.mdl",
			-- "models/gtasa/vehicles/alpha/bonnet_dam.mdl",
			-- "models/gtasa/vehicles/alpha/boot_dam.mdl",
			"models/gtasa/vehicles/alpha/bump_front_dam.mdl",
			-- "models/gtasa/vehicles/alpha/bump_rear_dam.mdl",
			-- "models/gtasa/vehicles/alpha/door_lf_dam.mdl",
			-- "models/gtasa/vehicles/alpha/door_rf_dam.mdl",
			-- //hmmmmm
			-- "models/gtasa/vehicles/bandito/wheel.mdl",
			-- "models/gtasa/vehicles/bandito/wheel.mdl",
			-- "models/gtasa/vehicles/bandito/wheel.mdl",
			-- "models/gtasa/vehicles/bandito/wheel.mdl",
		},
		
		EnginePos = Vector(56.34,0,4.46),
		
		LightsTable = "gtasa_bandito",
		
		OnSpawn = function(ent)
		
			if (file.Exists( "sound/trailers/trailer_connected.mp3", "GAME" )) then  --checks if sound file exists. will exist if dangerkiddys trailer base is subscribed.
				if ent.GetCenterposition != nil then
					ent:SetCenterposition(Vector(-100,0,-14))  -- position of center ballsocket for tow hitch(trailer coupling)
					ent:SetTrailerCenterposition(Vector(0,0,0)) -- position of center ballsocket for trailer hook
				end
			end		
			
			-- local hitboxes = {}
			-- hitboxes.hood = {max=Vector(32.817,-40,10), min=Vector(98,40,-22), bdgroup = 1, gibmodel = "models/gtasa/vehicles/alpha/bonnet_dam.mdl", giboffset = Vector(32,-2,8), health=180 }
			-- hitboxes.trunk = {max=Vector(-70.664,30.356,12), min=Vector(-105,-30.356,-20), bdgroup = 2, gibmodel = "models/gtasa/vehicles/alpha/boot_dam.mdl", giboffset = Vector(-72,0,13), health=160 }
			-- hitboxes.bumperf = {max=Vector(72.052,-42.048,-4), min=Vector(98,42.048,-24), bdgroup = 3, gibmodel = "models/gtasa/vehicles/alpha/bump_front_dam.mdl", giboffset = Vector(90,-34,-15), health=140 }
			-- hitboxes.bumperr = {min=Vector(-68.723,-41.032,-4), max=Vector(-106,41.032,-22), bdgroup = 4, gibmodel = "models/gtasa/vehicles/alpha/bump_rear_dam.mdl", giboffset = Vector(-87,34,-14), health=120 }
			-- hitboxes.dfdoor = {min=Vector(-34,43,8.499), max = Vector(34,34.991,-22), bdgroup = 5, gibmodel = "models/gtasa/vehicles/alpha/door_lf_dam.mdl", giboffset = Vector(29,38,-5.5), health=125 }
			-- hitboxes.pfdoor = {max=Vector(-34,-43,8.499), min = Vector(34,-34.991,-22), bdgroup = 6, gibmodel = "models/gtasa/vehicles/alpha/door_rf_dam.mdl", giboffset = Vector(29,-38.5,-5.5), health=125 }
			-- hitboxes.windowf = {min=Vector(33.734,32.611,8.056), max=Vector(3.52,-32.611,21.738), bdgroup = 7, health=6, glass=true, glasspos=Vector(19.286,0,15.077) }
			
			-- hitboxes.gastank = {min=Vector(-75.286,-40.8,1.014), max=Vector(-67.834,-38,7.337), explode=true }
			
			
			-- ent:NAKAddHitBoxes(hitboxes)
			ent:NAKSimfGTASA() -- function that'll do all the GTASA changes for you
			
			-- if ( ProxyColor ) then
				-- local CarCols = {}
				-- CarCols[1] = {Color(109,24,34)}
				-- CarCols[2] = {Color(171,152,143)}
				-- CarCols[3] = {Color(32,32,44)}
				-- CarCols[4] = {Color(123,10,42)}
				-- CarCols[5] = {Color(132,148,171)}
				-- CarCols[6] = {Color(93,27,32)}
				-- CarCols[7] = {Color(88,89,90)}
				-- CarCols[8] = {Color(100,100,100)}
				-- ent:SetProxyColor( CarCols[math.random(1,8)] )
			-- end
		end,
		
		OnTick = function(ent)
			ent:SetPoseParameter("vehicle_enginerpm", ent:GetRPM() * CurTime() )
		end,
		
		FrontWheelRadius = 9.5,
		RearWheelRadius = 11.5,


		-- CustomMassCenter = Vector(0,0,0),		
		
		SeatOffset = Vector(-8,-18,12),
		SeatPitch = 0,
		SeatYaw = 90,
		
		PassengerSeats = {
			{
				pos = Vector(0,-18,-20),
				ang = Angle(0,-90,20)
			},
		},
		ExhaustPositions = {
			{
				pos = Vector(-93.24,-20.44,-21.51),
				ang = Angle(-90,0,0),
			},
			{
				pos = Vector(-93.24,20.44,-21.51),
				ang = Angle(-90,0,0),
			},
		},
		-- Attachments = {
			-- {
				-- model = "models/gtasa/vehicles/alpha/steering.mdl",
				-- color = Color(255,255,255,255),
				-- pos = Vector(0,0,0),
				-- ang = Angle(0,0,0)
			-- },
		-- },
		
		FrontHeight = 7,
		FrontConstant = 50000,
		FrontDamping = 750,
		FrontRelativeDamping = 800,
		
		RearHeight = 7,
		RearConstant = 50000,
		RearDamping = 750,
		RearRelativeDamping = 800,
		
		FastSteeringAngle = 25,
		SteeringFadeFastSpeed = 350,
		
		TurnSpeed = 4,
		
		MaxGrip = 55,
		Efficiency = 1,
		GripOffset = 0,
		BrakePower = 35,
		BulletProofTires = false,
		
		IdleRPM = 850,
		LimitRPM = 6500,
		PeakTorque = 200,
		PowerbandStart = 2300,
		PowerbandEnd = 5500,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = false,
		
		FuelFillPos = Vector(-73.64,-40.32,4.21),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 75,
		
		PowerBias = 1,
		
		EngineSoundPreset = -1,

		snd_pitch = 1,
		snd_idle = "gtasa/vehicles/31-32_idle.wav",
		
		snd_low = "gtasa/vehicles/31-32_cruise.wav",
		snd_low_revdown = "gtasa/vehicles/31-32_cruise_loop.wav",
		snd_low_pitch = 1,
		
		snd_mid = "gtasa/vehicles/31-32_gear_loop.wav",
		snd_mid_gearup = "gtasa/vehicles/31-32_gear.wav",
		snd_mid_pitch = 1.05,
		
		snd_horn = "gtasa/vehicles/horns/horn_004.wav",
		
		DifferentialGear = 0.25,
		Gears = {-0.15,0,0.15,0.35,0.5,0.75,1}
	}
}
list.Set( "simfphys_vehicles", "sim_fphys_gtasa_bandito", V )

local light_table = {
	L_HeadLampPos = Vector(75.74,35.27,-0.85),
	L_HeadLampAng = Angle(17,0,0),
	R_HeadLampPos = Vector(75.74,-35.27,-0.85),
	R_HeadLampAng = Angle(10,0,0),
	
	L_RearLampPos = Vector(-91.71,30.5,2.81),
	L_RearLampAng = Angle(25,180,0),
	R_RearLampPos = Vector(-91.71,-30.5,2.81),
	R_RearLampAng = Angle(25,180,0),
	
	Headlight_sprites = {
		{
			pos = Vector(75.74,35.27,-0.85),
			material = "sprites/light_ignorez",
			size = 70,
			color = Color(255,238,200,255),
		},
		{
			pos = Vector(75.74,-35.27,-0.85),
			material = "sprites/light_ignorez",
			size = 70,
			color = Color(255,238,200,255),
		},
	},
	
	Headlamp_sprites = {
		{pos = Vector(75.74,35.27,-0.85),size = 100,material = "sprites/light_ignorez"},
		{pos = Vector(75.74,-35.27,-0.85),size = 100,material = "sprites/light_ignorez"},
	},
	
	Rearlight_sprites = {
		{
			pos = Vector(-91.71,30.5,2.81),
			material = "sprites/light_ignorez",
			size = 60,
			color = Color(255,0,0,255),
		},
		{
			pos = Vector(-91.71,-30.5,2.81),
			material = "sprites/light_ignorez",
			size = 60,
			color = Color(255,0,0,255),
		},
	},
	Brakelight_sprites = {
		{
			pos = Vector(-91.71,30.5,2.81),
			material = "sprites/light_ignorez",
			size = 70,
			color = Color(255,0,0,255),
		},
		{
			pos = Vector(-91.71,-30.5,2.81),
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
				pos = Vector(90,30.6,-15.3),
				material = "sprites/light_ignorez",
				size = 60,
				color = Color(255,135,0,255),
				OnBodyGroups = { 
					[3] = {0},
				}
			},
			{
				pos = Vector(-95.96,33.61,-10.78),
				material = "sprites/light_ignorez",
				size = 60,
				color = Color(255,135,0,255),
				OnBodyGroups = { 
					[4] = {0},
				}
			},
			{
				pos = Vector(-95.96,33.61,-10.78),
				material = "sprites/light_ignorez",
				size = 60,
				color = Color(255,135,0,255),
				OnBodyGroups = { 
					[4] = {1},
				}
			},
		},
		Right = {
			{
				pos = Vector(90,-30.6,-15.3),
				material = "sprites/light_ignorez",
				size = 60,
				color = Color(255,135,0,255),
				OnBodyGroups = { 
					[3] = {0},
				}
			},
			{
				pos = Vector(90,-30.6,-15.3),
				material = "sprites/light_ignorez",
				size = 60,
				color = Color(255,135,0,255),
				OnBodyGroups = { 
					[3] = {1},
				}
			},
			{
				pos = Vector(-95.96,-33.61,-10.78),
				material = "sprites/light_ignorez",
				size = 60,
				color = Color(255,135,0,255),
				OnBodyGroups = { 
					[4] = {0},
				}
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
list.Set( "simfphys_lights", "gtasa_bandito", light_table)