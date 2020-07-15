local V = {
    Name = "Blade",
    Model = "models/gtasa/vehicles/blade/blade.mdl",
    Class = "gmod_sent_vehicle_fphysics_base",
    Category = "GTA:SA - Lowriders",
    SpawnOffset = Vector(0, 0, 10),
    SpawnAngleOffset = 90,
    NAKGame = "GTA:SA",
    NAKType = "Lowriders",
    FLEX = {
        Trailers = {outputPos = Vector(-120, 0, -14), outputType = "ballsocket"}
    },
    Members = {
        Mass = 1500,

        GibModels = {
            "models/gtasa/vehicles/blade/chassis.mdl",
            "models/gtasa/vehicles/blade/wheel.mdl",
            "models/gtasa/vehicles/blade/wheel.mdl",
            "models/gtasa/vehicles/blade/wheel.mdl",
            "models/gtasa/vehicles/blade/wheel.mdl"
        },

        EnginePos = Vector(62.27, 0, 2.95),

        LightsTable = "gtasa_blade",

        NAKHitboxes = {
            hood = {
                OBBMax = Vector(35, -41, 10),
                OBBMin = Vector(97, 41, -24),
                BDGroup = 1,
                GibModel = "models/gtasa/vehicles/blade/bonnet_dam.mdl",
                GibOffset = Vector(31.72, 0, 6.15),
                Health = 450
            },
            trunk = {
                OBBMax = Vector(-75, 41, 10),
                OBBMin = Vector(-117, -41, -20),
                BDGroup = 2,
                GibModel = "models/gtasa/vehicles/blade/boot_dam.mdl",
                GibOffset = Vector(-76.86, 0, 6.98),
                Health = 400
            },
            bumperf = {
                OBBMax = Vector(79, -41, -4),
                OBBMin = Vector(97, 41, -24),
                BDGroup = 3,
                GibModel = "models/gtasa/vehicles/blade/bump_front_dam.mdl",
                GibOffset = Vector(91.32, 33.25, -12.53),
                Health = 400
            },
            bumperr = {
                OBBMin = Vector(-93, -41, -4),
                OBBMax = Vector(-118, 41, -24),
                BDGroup = 4,
                GibModel = "models/gtasa/vehicles/blade/bump_rear_dam.mdl",
                GibOffset = Vector(-106.75, 33.25, -13.67),
                Health = 420
            },
            dfdoor = {
                OBBMin = Vector(-24, 43, 10),
                OBBMax = Vector(32, 31, -22),
                BDGroup = 5,
                GibModel = "models/gtasa/vehicles/blade/door_lf_dam.mdl",
                GibOffset = Vector(30.52, 40.06, -4.53),
                Health = 250
            },
            pfdoor = {
                OBBMax = Vector(-24, -43, 10),
                OBBMin = Vector(32, -31, -22),
                BDGroup = 6,
                GibModel = "models/gtasa/vehicles/blade/door_rf_dam.mdl",
                GibOffset = Vector(30.52, -40.06, -4.53),
                Health = 250
            },
            windowf = {
                OBBMin = Vector(32, -37, 22),
                OBBMax = Vector(12, 37, 4),
                BDGroup = 7,
                Health = 6,
                TypeFlag = 1,
                ShatterPos = Vector(25.31, 0, 13)
            },

            gastank = {
                OBBMin = Vector(-68, 46, 7),
                OBBMax = Vector(-57, 26, -1),
                TypeFlag = 2
            }
        },

        OnSpawn = function(ent)
            ent:NAKSimfGTASA() -- function that'll do all the GTASA changes for you
            ent:NAKHitboxDmg() -- function that'll activate the hitboxes

            if (ProxyColor) then
                local CarCols = {}
                CarCols[1] = {Color(94, 112, 114)}
                CarCols[2] = {Color(93, 126, 141)}
                CarCols[3] = {Color(165, 169, 167)}
                CarCols[4] = {Color(66, 31, 33)}
                CarCols[5] = {Color(132, 148, 171)}
                CarCols[6] = {Color(45, 58, 53)}
                CarCols[7] = {Color(156, 141, 113)}
                CarCols[8] = {Color(111, 130, 151)}
                ent:SetProxyColor(CarCols[math.random(1, 8)])
            end
        end,

        OnTick = function(ent)
            if ent.horn then ent.horn:ChangePitch(120, 0) end
            if ((ent:GetThrottle() < 0.1) and (ent:GetRPM() > 3500) and
                not ent.throttledoff) then
                ent.throttledoff = true
                ent:EmitSound("gtasa/vehicles/39-40_throttleoff.wav")
            end
            if (ent:GetThrottle() > 0) then ent.throttledoff = false end
        end,

        CustomWheels = true,
        CustomSuspensionTravel = 1.5,

        CustomWheelModel = "models/gtasa/vehicles/blade/wheel.mdl",

        CustomWheelPosFL = Vector(64.59, 33.25, -13),
        CustomWheelPosFR = Vector(64.59, -33.25, -13),
        CustomWheelPosRL = Vector(-63.89, 33.25, -13),
        CustomWheelPosRR = Vector(-63.89, -33.25, -13),
        CustomWheelAngleOffset = Angle(0, 90, 0),

        CustomMassCenter = Vector(0, 0, 0),

        CustomSteerAngle = 45,

        SeatOffset = Vector(-12, -19, 10),
        SeatPitch = -10,
        SeatYaw = 90,

        PassengerSeats = {{pos = Vector(-3, -19, -22), ang = Angle(0, -90, 20)}},
        ExhaustPositions = {
            {pos = Vector(-109.71, 18.58, -19.77), ang = Angle(-90, 0, 0)},
            {pos = Vector(-109.71, -18.58, -19.77), ang = Angle(-90, 0, 0)}
        },
        Attachments = {
            {
                model = "models/gtasa/vehicles/blade/steering.mdl",
                color = Color(255, 255, 255, 255),
                pos = Vector(0, 0, 0),
                ang = Angle(0, 0, 0)
            }
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

        MaxGrip = 55,
        Efficiency = 1,
        GripOffset = 0,
        BrakePower = 35,
        BulletProofTires = false,

        IdleRPM = 650,
        LimitRPM = 6500,
        PeakTorque = 160,
        PowerbandStart = 2300,
        PowerbandEnd = 5500,
        Turbocharged = false,
        Supercharged = false,
        DoNotStall = false,

        FuelFillPos = Vector(-62.62, 39.45, 3.48),
        FuelType = FUELTYPE_PETROL,
        FuelTankSize = 75,

        PowerBias = 1,

        EngineSoundPreset = -1,

        snd_pitch = 1,
        snd_idle = "gtasa/vehicles/39-40_idle.wav",

        snd_low = "gtasa/vehicles/39-40_cruise.wav",
        snd_low_revdown = "gtasa/vehicles/39-40_cruise_loop.wav",
        snd_low_pitch = 1,

        snd_mid = "gtasa/vehicles/39-40_gear_loop.wav",
        snd_mid_gearup = "gtasa/vehicles/39-40_gear.wav",
        snd_mid_pitch = 1.05,

        snd_horn = "gtasa/vehicles/horns/horn_003.wav",

        DifferentialGear = 0.22,
        Gears = {-0.15, 0, 0.15, 0.35, 0.5, 0.75, 0.85}
    }
}
list.Set("simfphys_vehicles", "sim_fphys_gtasa_blade", V)

local light_table = {
    L_HeadLampPos = Vector(90.48, 25.95, -5),
    L_HeadLampAng = Angle(17, 0, 0),
    R_HeadLampPos = Vector(90.48, -25.95, -5),
    R_HeadLampAng = Angle(10, 0, 0),

    L_RearLampPos = Vector(-114.81, 31.84, -3.35),
    L_RearLampAng = Angle(25, 180, 0),
    R_RearLampPos = Vector(-114.81, -31.84, -3.35),
    R_RearLampAng = Angle(25, 180, 0),

    Headlight_sprites = {
        {
            pos = Vector(91.89, 19.84, -5),
            material = "sprites/light_ignorez",
            size = 70,
            color = Color(255, 238, 200, 255)
        }, {
            pos = Vector(91.89, -19.84, -5),
            material = "sprites/light_ignorez",
            size = 70,
            color = Color(255, 238, 200, 255)
        }, {
            pos = Vector(90.48, 25.95, -5),
            material = "sprites/light_ignorez",
            size = 60,
            color = Color(255, 238, 200, 255)
        }, {
            pos = Vector(90.48, -25.95, -5),
            material = "sprites/light_ignorez",
            size = 60,
            color = Color(255, 238, 200, 255)
        }, {
            pos = Vector(89.17, 31.94, -5),
            material = "sprites/light_ignorez",
            size = 70,
            color = Color(255, 238, 200, 255)
        }, {
            pos = Vector(89.17, -31.94, -5),
            material = "sprites/light_ignorez",
            size = 70,
            color = Color(255, 238, 200, 255)
        }
    },

    Headlamp_sprites = {
        {
            pos = Vector(90.48, 25.95, -5),
            size = 100,
            material = "sprites/light_ignorez"
        }, {
            pos = Vector(90.48, -25.95, -5),
            size = 100,
            material = "sprites/light_ignorez"
        }
    },

    Rearlight_sprites = {
        {
            pos = Vector(-114.81, 31.84, -3.35),
            material = "sprites/light_ignorez",
            size = 60,
            color = Color(255, 0, 0, 255)
        }, {
            pos = Vector(-114.81, -31.84, -3.35),
            material = "sprites/light_ignorez",
            size = 60,
            color = Color(255, 0, 0, 255)
        }
    },
    Brakelight_sprites = {
        {
            pos = Vector(-114.81, 31.84, -3.35),
            material = "sprites/light_ignorez",
            size = 70,
            color = Color(255, 0, 0, 255)
        }, {
            pos = Vector(-114.81, -31.84, -3.35),
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
                pos = Vector(-114.81, 31.84, -3.35),
                material = "sprites/light_ignorez",
                size = 60,
                color = Color(255, 0, 0, 255)
            }
        },
        Right = {
            {
                pos = Vector(-114.81, -31.84, -3.35),
                material = "sprites/light_ignorez",
                size = 60,
                color = Color(255, 0, 0, 255)
            }
        }
    },

    SubMaterials = {
        off = {Base = {[3] = ""}},
        on_lowbeam = {
            Base = {[3] = "models/gtasa/vehicles/share/vehiclelightson128"}
        }
    }

}
list.Set("simfphys_lights", "gtasa_blade", light_table)
