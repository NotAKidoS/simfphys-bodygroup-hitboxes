local V = {
    Name = "Admiral",
    Model = "models/gtasa/vehicles/admiral/admiral.mdl",
    Class = "gmod_sent_vehicle_fphysics_base",
    Category = "GTA:SA - Sedans/Wagons",
    SpawnOffset = Vector(0, 0, 20),
    SpawnAngleOffset = 90,
    NAKGame = "GTA:SA",
    NAKType = "Sedans/Wagons",

    Members = {
        Mass = 1650,

        GibModels = {
            "models/gtasa/vehicles/admiral/chassis.mdl",
            -- "models/gtasa/vehicles/admiral/bonnet_dam.mdl",
            -- "models/gtasa/vehicles/admiral/boot_dam.mdl",
            -- "models/gtasa/vehicles/admiral/bump_front_dam.mdl",
            -- "models/gtasa/vehicles/admiral/bump_rear_dam.mdl",
            -- "models/gtasa/vehicles/admiral/door_lf_dam.mdl",
            -- "models/gtasa/vehicles/admiral/door_lr_dam.mdl",
            -- "models/gtasa/vehicles/admiral/door_rf_dam.mdl",
            -- "models/gtasa/vehicles/admiral/door_rr_dam.mdl",
            "models/gtasa/vehicles/admiral/wheel.mdl",
            "models/gtasa/vehicles/admiral/wheel.mdl",
            "models/gtasa/vehicles/admiral/wheel.mdl",
            "models/gtasa/vehicles/admiral/wheel.mdl"
        },

        EnginePos = Vector(69.4, 0, 8.22),

        LightsTable = "gtasa_admiral",

        NAKHitboxes = {
            Hood = {
                OBBMin = Vector(36.187, -38, -8),
                OBBMax = Vector(100, 38, 11.006),
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
                OBBMax = Vector(-13.111, 34.092, 8.405),
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
                OBBMax = Vector(-48.503, 34.092, 8.405),
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
        },

        OnSpawn = function(ent)
            ent:NAKSimfGTASA() -- function that'll do all the GTASA changes for you
            ent:NAKHitboxDmg() -- function that'll activate the hitboxes

            if (ProxyColor) then
                local CarCols = {}
                CarCols[1] = {Color(100, 100, 100)}
                CarCols[2] = {Color(90, 87, 82)}
                CarCols[3] = {Color(45, 58, 53)}
                CarCols[4] = {Color(109, 122, 136)}
                CarCols[5] = {Color(111, 103, 95)}
                CarCols[6] = {Color(95, 10, 21)}
                CarCols[7] = {Color(122, 117, 96)}
                ent:SetProxyColor(CarCols[math.random(1, 7)])
            end
        end,

        CustomWheels = true,
        CustomSuspensionTravel = 1.5,

        CustomWheelModel = "models/gtasa/vehicles/admiral/wheel.mdl",

        CustomWheelPosFL = Vector(64.17, 33.55, -17),
        CustomWheelPosFR = Vector(64.17, -33.55, -17),
        CustomWheelPosRL = Vector(-64.4, 33.55, -17),
        CustomWheelPosRR = Vector(-64.4, -33.55, -17),
        CustomWheelAngleOffset = Angle(0, 90, 0),

        CustomMassCenter = Vector(0, 0, 0),

        CustomSteerAngle = 45,

        SeatOffset = Vector(-8, -18, 15),
        SeatPitch = 0,
        SeatYaw = 90,

        PassengerSeats = {
            {pos = Vector(4, -20, -18), ang = Angle(0, -90, 20)},
            {pos = Vector(-30, 20, -18), ang = Angle(0, -90, 20)},
            {pos = Vector(-30, -20, -18), ang = Angle(0, -90, 20)}
        },
        ExhaustPositions = {
            {pos = Vector(-100, -17.85, -19.46), ang = Angle(-90, 0, 0)}
        },
        Attachments = {
            {
                model = "models/gtasa/vehicles/admiral/steering.mdl",
                color = Color(255, 255, 255, 255),
                pos = Vector(0, 0, 0),
                ang = Angle(0, 0, 0)
            }
        },

        FrontHeight = 7,
        FrontConstant = 50000,
        FrontDamping = 750,
        FrontRelativeDamping = 350,

        RearHeight = 7,
        RearConstant = 50000,
        RearDamping = 750,
        RearRelativeDamping = 800,

        FastSteeringAngle = 25,
        SteeringFadeFastSpeed = 350,

        TurnSpeed = 4,

        MaxGrip = 45,
        Efficiency = 1,
        GripOffset = 0,
        BrakePower = 42.5,
        BulletProofTires = false,

        IdleRPM = 800,
        LimitRPM = 5000,
        PeakTorque = 165,
        PowerbandStart = 2200,
        PowerbandEnd = 4500,
        Turbocharged = false,
        Supercharged = false,
        DoNotStall = false,

        FuelFillPos = Vector(-71.87, 38.35, 4.62),
        FuelType = FUELTYPE_PETROL,
        FuelTankSize = 90,

        PowerBias = -1,

        EngineSoundPreset = -1,

        snd_pitch = 1,
        snd_idle = "gtasa/vehicles/80-81_idle.wav",

        snd_low = "gtasa/vehicles/80-81_cruise.wav",
        snd_low_revdown = "gtasa/vehicles/80-81_cruise_loop.wav",
        snd_low_pitch = 0.95,

        snd_mid = "gtasa/vehicles/80-81_gear_loop.wav",
        snd_mid_gearup = "gtasa/vehicles/80-81_gear.wav",
        snd_mid_pitch = 1.1,

        snd_horn = "gtasa/vehicles/horns/horn_004.wav",

        DifferentialGear = 0.2,
        Gears = {-0.15, 0, 0.15, 0.35, 0.5, 0.75, 1}
    }
}
list.Set("simfphys_vehicles", "sim_fphys_gtasa_admiral", V)

local light_table = {
    L_HeadLampPos = Vector(89.57, 23.88, -2.31),
    L_HeadLampAng = Angle(17, 0, 0),
    R_HeadLampPos = Vector(89.57, -23.88, -2.31),
    R_HeadLampAng = Angle(10, 0, 0),

    L_RearLampPos = Vector(-105.55, 19.67, -2.46),
    L_RearLampAng = Angle(25, 180, 0),
    R_RearLampPos = Vector(-105.55, -19.67, -2.46),
    R_RearLampAng = Angle(25, 180, 0),

    Headlight_sprites = {
        {
            pos = Vector(89.57, 23.88, -2.31),
            material = "sprites/light_ignorez",
            size = 70,
            color = Color(255, 238, 200, 255)
        }, {
            pos = Vector(89.57, -23.88, -2.31),
            material = "sprites/light_ignorez",
            size = 70,
            color = Color(255, 238, 200, 255)
        }
    },

    Headlamp_sprites = {
        {
            pos = Vector(89.57, 23.88, -2.31),
            size = 100,
            material = "sprites/light_ignorez"
        }, {
            pos = Vector(89.57, -23.88, -2.31),
            size = 100,
            material = "sprites/light_ignorez"
        }
    },

    Rearlight_sprites = {
        {
            pos = Vector(-105.55, 19.67, -2.46),
            material = "sprites/light_ignorez",
            size = 60,
            color = Color(255, 0, 0, 255)
        }, {
            pos = Vector(-105.55, -19.67, -2.46),
            material = "sprites/light_ignorez",
            size = 60,
            color = Color(255, 0, 0, 255)
        }
    },
    Brakelight_sprites = {
        {
            pos = Vector(-105.32, 27.43, -2.46),
            material = "sprites/light_ignorez",
            size = 70,
            color = Color(255, 0, 0, 255)
        }, {
            pos = Vector(-105.32, -27.43, -2.46),
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
                pos = Vector(87.8, 34.9, -2.4),
                material = "sprites/light_ignorez",
                size = 60,
                color = Color(255, 135, 0, 255)
            }, {
                pos = Vector(-104.2, 36.9, -2.4),
                material = "sprites/light_ignorez",
                size = 60,
                color = Color(255, 135, 0, 255)
            }
        },
        Right = {
            {
                pos = Vector(87.8, -34.9, -2.4),
                material = "sprites/light_ignorez",
                size = 60,
                color = Color(255, 135, 0, 255)
            }, {
                pos = Vector(-104.2, -36.9, -2.4),
                material = "sprites/light_ignorez",
                size = 60,
                color = Color(255, 135, 0, 255)
            }
        }
    },

    SubMaterials = {
        off = {Base = {[4] = ""}},
        on_lowbeam = {
            Base = {[4] = "models/gtasa/vehicles/share/vehiclelightson128"}
        }
    }
}
list.Set("simfphys_lights", "gtasa_admiral", light_table)
