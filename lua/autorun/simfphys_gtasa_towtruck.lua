local HitboxList = {
	hood = {
		OBBMin = Vector(43.36, 50, 30.54),
		OBBMax = Vector(121, -50, -10),
		BDGroup = 1,
		GibModel = "models/gtasa/vehicles/towtruck/bonnet_dam.mdl",
		GibOffset = Vector(44.6, 0, 27.3),
		Health = 160
	},
	bumperf = {
		OBBMin = Vector(95, 50, 20),
		OBBMax = Vector(121, -50, -15),
		BDGroup = 2,
		GibModel = "models/gtasa/vehicles/towtruck/bump_front_dam.mdl",
		GibOffset = Vector(108.98, -39.17, 1.94),
		Health = 100
	},
	dfdoor = {
		OBBMin = Vector(-9, 50, 25.74),
		OBBMax = Vector(55, 31.67, -12),
		BDGroup = 3,
		GibModel = "models/gtasa/vehicles/towtruck/door_lf_dam.mdl",
		GibOffset = Vector(44.37, 44.11, 20.34),
		Health = 100
	},
	pfdoor = {
		OBBMax = Vector(-9, -50, 25.74),
		OBBMin = Vector(55, -31.67, -12),
		BDGroup = 4,
		GibModel = "models/gtasa/vehicles/towtruck/door_rf_dam.mdl",
		GibOffset = Vector(44.37, -44.11, 20.34),
		Health = 100
	},
	windowf = {
		OBBMin = Vector(25.68, 36.65, 49.14),
		OBBMax = Vector(45.68, -36.65, 29.14),
		BDGroup = 5,
		Health = 6,
		ShatterPos = Vector(37.969, 0, 38.025),
		TypeFlag = 1
	},
	gastank = {
		OBBMin = Vector(-22.92, 50, 0.65),
		OBBMax = Vector(-14.69, 40, -7.3),
		TypeFlag = 2
	}
}
list.Set("nak_simf_hitboxes", "sim_fphys_gtasa_towtruck", HitboxList)

local V = {
    Name = "Towtruck",
    Model = "models/gtasa/vehicles/towtruck/towtruck.mdl",
    Class = "gmod_sent_vehicle_fphysics_base",
    Category = "GTA:SA - Public Service",
    SpawnOffset = Vector(0, 0, 20),
    SpawnAngleOffset = 90,
    NAKGame = "GTA:SA",
    NAKType = "Public Service",
    FLEX = {Trailers = {outputPos = Vector(-108, 0, -12)}},
    Members = {
        Mass = 3500,
        EnginePos = Vector(86.81, 0, 13.75),
        LightsTable = "gtasa_towtruck",
        GibModels = {
            "models/gtasa/vehicles/towtruck/chassis.mdl",
            "models/gtasa/vehicles/towtruck/wheel.mdl",
            "models/gtasa/vehicles/towtruck/wheel.mdl",
            "models/gtasa/vehicles/towtruck/wheel.mdl",
            "models/gtasa/vehicles/towtruck/wheel.mdl"
        },

        OnSpawn = function(ent)
            NAK.SimfGTASA(ent) -- function that'll do all the GTASA changes for you
			NAK.AddHitboxes(ent)

            if (ProxyColor) then
                local CarCols = {}
                CarCols[1] = {
                    Color(245, 245, 245), Color(245, 245, 245),
                    Color(245, 245, 245)
                }
                CarCols[2] = {
                    Color(115, 14, 26), Color(59, 78, 120), Color(245, 245, 245)
                }
                CarCols[3] = {
                    Color(123, 10, 42), Color(59, 78, 120), Color(245, 245, 245)
                }
                CarCols[4] = {
                    Color(105, 30, 59), Color(66, 31, 33), Color(245, 245, 245)
                }
                CarCols[5] = {
                    Color(37, 37, 39), Color(95, 10, 21), Color(245, 245, 245)
                }
                CarCols[6] = {
                    Color(25, 56, 38), Color(48, 79, 69), Color(245, 245, 245)
                }
                CarCols[7] = {
                    Color(77, 98, 104), Color(39, 47, 75), Color(245, 245, 245)
                }
                ProxyColor.RandFromTable(ent,CarCols,true)
            end
        end,

        OnTick = function(ent)
            local TowPos = ent:GetAttachment(ent:LookupAttachment("tow_hook"))

            if not ent.TowArmAng then ent.TowArmAng = 0 end

            if ent:GetFogLightsEnabled() then
                ent.TowArmAng = math.Clamp(ent.TowArmAng + 2, 0, 27)
            else
                ent.TowArmAng = math.Clamp(ent.TowArmAng - 2, 0, 27)
            end
            ent:SetPoseParameter("vehicle_towarm_move", ent.TowArmAng)
        end,

        CustomWheels = true,
        CustomSuspensionTravel = 1.5,

        CustomWheelModel = "models/gtasa/vehicles/towtruck/wheel.mdl",
        CustomWheelModel_R = "models/gtasa/vehicles/towtruck/wheel_wide.mdl",

        CustomWheelPosFL = Vector(77.08, 38.04, -14),
        CustomWheelPosFR = Vector(77.08, -38.04, -14),
        CustomWheelPosRL = Vector(-77.51, 40.82, -14),
        CustomWheelPosRR = Vector(-77.51, -40.82, -14),
        CustomWheelAngleOffset = Angle(0, 90, 0),

        CustomMassCenter = Vector(0, 0, 0),

        CustomSteerAngle = 45,

        SeatOffset = Vector(5, -18, 34),
        SeatPitch = 0,
        SeatYaw = 90,

        PassengerSeats = {{pos = Vector(15, -20, 0), ang = Angle(0, -90, 10)}},
        ExhaustPositions = {
            {pos = Vector(-104.32, -18.23, -17.41), ang = Angle(-90, 0, 0)}
        },
        Attachments = {
            {
                model = "models/gtasa/vehicles/towtruck/steering.mdl",
                color = Color(255, 255, 255, 255),
                pos = Vector(0, 0, 0),
                ang = Angle(0, 0, 0)
            }
        },

        StrengthenSuspension = true,

        FrontHeight = 10,
        FrontConstant = 50000,
        FrontDamping = 1500,
        FrontRelativeDamping = 350,

        RearHeight = 10,
        RearConstant = 50000,
        RearDamping = 1500,
        RearRelativeDamping = 800,

        FastSteeringAngle = 25,
        SteeringFadeFastSpeed = 350,

        TurnSpeed = 4,

        MaxGrip = 125,
        Efficiency = 1,
        GripOffset = 0,
        BrakePower = 60,
        BulletProofTires = false,

        IdleRPM = 800,
        LimitRPM = 5000,
        PeakTorque = 160,
        PowerbandStart = 2200,
        PowerbandEnd = 4500,
        Turbocharged = false,
        Supercharged = false,
        DoNotStall = false,

        FuelFillPos = Vector(-18.9, 51.31, -3.43),
        FuelType = FUELTYPE_DIESEL,
        FuelTankSize = 150,

        PowerBias = 1,

        EngineSoundPreset = -1,

        snd_pitch = 1,
        snd_idle = "gtasa/vehicles/130-131_idle.wav",

        snd_low = "gtasa/vehicles/130-131_cruise.wav",
        snd_low_revdown = "gtasa/vehicles/130-131_cruise_loop.wav",
        snd_low_pitch = 0.95,

        snd_mid = "gtasa/vehicles/130-131_gear_loop.wav",
        snd_mid_gearup = "gtasa/vehicles/130-131_gear.wav",
        snd_mid_pitch = 1.2,

        snd_horn = "gtasa/vehicles/horns/horn_005.wav",

        DifferentialGear = 0.18,
        Gears = {-0.13, 0, 0.15, 0.35, 0.5, 0.65, 0.85}
    }
}
list.Set("simfphys_vehicles", "sim_fphys_gtasa_towtruck", V)

local light_table = {
    L_HeadLampPos = Vector(110.8, 30.77, 13.37),
    L_HeadLampAng = Angle(17, 0, 0),
    R_HeadLampPos = Vector(110.8, -30.77, 13.37),
    R_HeadLampAng = Angle(10, 0, 0),

    L_RearLampPos = Vector(-110.7, 34.98, -5.71),
    L_RearLampAng = Angle(25, 180, 0),
    R_RearLampPos = Vector(-110.7, -34.98, -5.71),
    R_RearLampAng = Angle(25, 180, 0),

    Headlight_sprites = {
        {
            pos = Vector(110.8, 30.77, 13.37),
            material = "sprites/light_ignorez",
            size = 70,
            color = Color(255, 238, 200, 255)
        }, {
            pos = Vector(110.8, -30.77, 13.37),
            material = "sprites/light_ignorez",
            size = 70,
            color = Color(255, 238, 200, 255)
        }
    },

    Headlamp_sprites = {
        {
            pos = Vector(110.8, 30.77, 13.37),
            size = 100,
            material = "sprites/light_ignorez"
        }, {
            pos = Vector(110.8, -30.77, 13.37),
            size = 100,
            material = "sprites/light_ignorez"
        }
    },

    Rearlight_sprites = {
        {
            pos = Vector(-110.7, 34.98, -5.71),
            material = "sprites/light_ignorez",
            size = 60,
            color = Color(255, 0, 0, 255)
        }, {
            pos = Vector(-110.7, -34.98, -5.71),
            material = "sprites/light_ignorez",
            size = 60,
            color = Color(255, 0, 0, 255)
        }
    },
    Brakelight_sprites = {
        {
            pos = Vector(-110.7, 34.98, -5.71),
            material = "sprites/light_ignorez",
            size = 70,
            color = Color(255, 0, 0, 255)
        }, {
            pos = Vector(-110.7, -34.98, -5.71),
            material = "sprites/light_ignorez",
            size = 70,
            color = Color(255, 0, 0, 255)
        }
    },

    DelayOn = 0,
    DelayOff = 0,

    Turnsignal_sprites = {
        Left = {
            {
                pos = Vector(109.22, 30.77, 5.85),
                material = "sprites/light_ignorez",
                size = 70,
                color = Color(255, 135, 0, 255)
            }
        },
        Right = {
            {
                pos = Vector(109.22, -30.77, 5.85),
                material = "sprites/light_ignorez",
                size = 70,
                color = Color(255, 135, 0, 255)
            }
        }
    },

    SubMaterials = {
        off = {Base = {[7] = ""}},
        on_lowbeam = {
            Base = {[7] = "models/gtasa/vehicles/share/vehiclelightson128"}
        }
    }
}
list.Set("simfphys_lights", "gtasa_towtruck", light_table)
