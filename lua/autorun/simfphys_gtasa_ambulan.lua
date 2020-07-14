local V = {
    Name = "Ambulance",
    Model = "models/gtasa/vehicles/ambulan/ambulan.mdl",
    Class = "gmod_sent_vehicle_fphysics_base",
    Category = "GTA:SA - Government",
    SpawnOffset = Vector(0, 0, 30),
    SpawnAngleOffset = 90,
    NAKGame = "GTA:SA",
    NAKType = "Government",

    Members = {
        Mass = 2600,

        GibModels = {
            "models/gtasa/vehicles/ambulan/chassis.mdl",
            -- "models/gtasa/vehicles/ambulan/bonnet_dam.mdl",
            -- "models/gtasa/vehicles/ambulan/bump_front_dam.mdl",
            -- "models/gtasa/vehicles/ambulan/door_lf_dam.mdl",
            -- "models/gtasa/vehicles/ambulan/door_lr_dam.mdl",
            -- "models/gtasa/vehicles/ambulan/door_rf_dam.mdl",
            -- "models/gtasa/vehicles/ambulan/door_rr_dam.mdl",
            "models/gtasa/vehicles/ambulan/wheel.mdl",
            "models/gtasa/vehicles/ambulan/wheel.mdl",
            "models/gtasa/vehicles/ambulan/wheel.mdl",
            "models/gtasa/vehicles/ambulan/wheel.mdl"
        },

        EnginePos = Vector(93.97, 0, 4.10),

        LightsTable = "gtasa_ambulan",

        NAKHitboxes = {
            Hood = {
                OBBMin = Vector(69.4, 42, 19.6),
                OBBMax = Vector(120, -42, -8.4),
                BDGroup = 1,
                GibModel = "models/gtasa/vehicles/ambulan/bonnet_dam.mdl",
                GibOffset = Vector(69.45, 0, 18.10),
                Health = 160
            },
            BumperF = {
                OBBMin = Vector(94.4, 42, 5),
                OBBMax = Vector(120, -42, -27.6),
                BDGroup = 2,
                GibModel = "models/gtasa/vehicles/ambulan/bump_front_dam.mdl",
                GibOffset = Vector(96.72, -39.63, -12.67),
                Health = 120
            },
            DoorDF = {
                OBBMin = Vector(20, 46, 17),
                OBBMax = Vector(62, 27, -25),
                BDGroup = 3,
                GibModel = "models/gtasa/vehicles/ambulan/door_lf_dam.mdl",
                GibOffset = Vector(61.01, 41.65, 3.48),
                Health = 100
            },
            DoorPF = {
                OBBMax = Vector(20, -46, 17),
                OBBMin = Vector(62, -27, -25),
                BDGroup = 5,
                GibModel = "models/gtasa/vehicles/ambulan/door_rf_dam.mdl",
                GibOffset = Vector(61.01, -41.65, 3.48),
                Health = 100
            },
            DoorDR = {
                OBBMin = Vector(-145, -2, 53),
                OBBMax = Vector(-128, 32, -13),
                BDGroup = 4,
                GibModel = "models/gtasa/vehicles/ambulan/door_lr_dam.mdl",
                GibOffset = Vector(-134.85, 31.42, 14.78),
                Health = 100
            },
            DoorPR = {
                OBBMax = Vector(-145, 2, 53),
                OBBMin = Vector(-128, -32, -13),
                BDGroup = 6,
                GibModel = "models/gtasa/vehicles/ambulan/door_rr_dam.mdl",
                GibOffset = Vector(-134.85, -31.42, 14.78),
                Health = 100
            },
            Windsheild = {
                OBBMin = Vector(48, 37, 42),
                OBBMax = Vector(69, -37, 19),
                BDGroup = 7,
                Health = 6,
                TypeFlag = 1,
                ShatterPos = Vector(59.66, 0, 29.70)
            },
            FuelCap = {
                OBBMin = Vector(-96, 40, -13),
                OBBMax = Vector(-107, 55, -2),
                TypeFlag = 2
            }
        },

        OnSpawn = function(ent)
            ent:SetBodyGroups("00000000" .. math.random(0, 1)) -- random unit number
            ent:NAKSimfGTASA() -- gtasa functions
            ent:NAKHitboxDmg() -- hitboxes
            ent:NAKSimfEMSRadio()

            if (ProxyColor) then
                local CarCols = {}
                CarCols[1] = {
                    Color(245, 245, 245), Color(132, 4, 16),
                    Color(245, 245, 245), Color(0, 0, 0), Color(131, 104, 229)
                }
                ent:SetProxyColor(CarCols[1])
            end
        end,

        OnTick = function(ent)
            if ent.horn then ent.horn:ChangePitch(95, 0) end
        end,

        CustomWheels = true,
        CustomSuspensionTravel = 1.5,

        CustomWheelModel = "models/gtasa/vehicles/ambulan/wheel.mdl",

        CustomWheelPosFL = Vector(81.84, 35.52, -24),
        CustomWheelPosFR = Vector(81.84, -35.52, -24),
        CustomWheelPosRL = Vector(-80.52, 37.63, -24),
        CustomWheelPosRR = Vector(-80.52, -37.63, -24),
        CustomWheelAngleOffset = Angle(0, 90, 0),

        CustomMassCenter = Vector(0, 0, 20),

        CustomSteerAngle = 45,

        SeatOffset = Vector(28, -16, 25),
        SeatPitch = 0,
        SeatYaw = 90,

        PassengerSeats = {
            {pos = Vector(35, -18, -10), ang = Angle(0, -90, 10)},
            {pos = Vector(-100, -31.4, -7), ang = Angle(0, 0, 10)},
            {pos = Vector(-100, 31.4, -7), ang = Angle(0, 180, 10)}
        },
        ExhaustPositions = {
            {pos = Vector(-141.16, -18.48, -29.43), ang = Angle(-90, 0, 0)}
        },
        Attachments = {
            {
                model = "models/gtasa/vehicles/ambulan/steering.mdl",
                color = Color(255, 255, 255, 255),
                pos = Vector(0, 0, 0),
                ang = Angle(0, 0, 0)
            }
        },

        StrengthenSuspension = true,

        FrontHeight = 10,
        FrontConstant = 50000,
        FrontDamping = 2500,
        FrontRelativeDamping = 350,

        RearHeight = 10,
        RearConstant = 50000,
        RearDamping = 2500,
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
        PeakTorque = 155,
        PowerbandStart = 2200,
        PowerbandEnd = 4500,
        Turbocharged = false,
        Supercharged = false,
        DoNotStall = false,

        FuelFillPos = Vector(-18.9, 51.31, -3.43),
        FuelType = FUELTYPE_DIESEL,
        FuelTankSize = 150,

        PowerBias = 0,

        EngineSoundPreset = -1,

        snd_pitch = 1,
        snd_idle = "gtasa/vehicles/130-131_idle.wav",

        snd_low = "gtasa/vehicles/130-131_cruise.wav",
        snd_low_revdown = "gtasa/vehicles/130-131_cruise_loop.wav",
        snd_low_pitch = 0.95,

        snd_mid = "gtasa/vehicles/130-131_gear_loop.wav",
        snd_mid_gearup = "gtasa/vehicles/130-131_gear.wav",
        snd_mid_pitch = 1.2,

        snd_horn = "gtasa/vehicles/horns/horn_008.wav",

        DifferentialGear = 0.22,
        Gears = {-0.14, 0, 0.15, 0.35, 0.5, 0.65, 0.85}
    }
}
list.Set("simfphys_vehicles", "sim_fphys_gtasa_ambulan", V)

local light_table = {
    L_HeadLampPos = Vector(114.65, 27.74, 0.53),
    L_HeadLampAng = Angle(17, 0, 0),
    R_HeadLampPos = Vector(114.65, -27.74, 0.53),
    R_HeadLampAng = Angle(10, 0, 0),

    L_RearLampPos = Vector(-143.92, 38.33, -16.95),
    L_RearLampAng = Angle(25, 180, 0),
    R_RearLampPos = Vector(-143.92, -38.33, -16.95),
    R_RearLampAng = Angle(25, 180, 0),

    Headlight_sprites = {
        {
            pos = Vector(114.65, 27.74, 0.53),
            material = "sprites/light_ignorez",
            size = 70,
            color = Color(255, 238, 200, 255)
        }, {
            pos = Vector(114.65, -27.74, 0.53),
            material = "sprites/light_ignorez",
            size = 70,
            color = Color(255, 238, 200, 255)
        }
    },

    Headlamp_sprites = {
        {
            pos = Vector(114.65, 27.74, 0.53),
            size = 100,
            material = "sprites/light_ignorez"
        }, {
            pos = Vector(114.65, -27.74, 0.53),
            size = 100,
            material = "sprites/light_ignorez"
        }
    },

    Rearlight_sprites = {
        {
            pos = Vector(-143.92, 38.33, -16.95),
            material = "sprites/light_ignorez",
            size = 60,
            color = Color(255, 0, 0, 255)
        }, {
            pos = Vector(-143.92, -38.33, -16.95),
            material = "sprites/light_ignorez",
            size = 60,
            color = Color(255, 0, 0, 255)
        }
    },
    Brakelight_sprites = {
        {
            pos = Vector(-143.92, 38.33, -16.95),
            material = "sprites/light_ignorez",
            size = 70,
            color = Color(255, 0, 0, 255)
        }, {
            pos = Vector(-143.92, -38.33, -16.95),
            material = "sprites/light_ignorez",
            size = 70,
            color = Color(255, 0, 0, 255)
        }
    },

    ems_sounds = {
        "gtasa/vehicles/horns/siren_wail.wav",
        "gtasa/vehicles/horns/siren_yelp.wav"
    },

    ems_sprites = {

        {
            pos = Vector(33, -22, 50),
            material = "sprites/light_ignorez",
            size = 70,

            Colors = {
                Color(255, 0, 0, 50), Color(255, 0, 0, 150),
                Color(255, 0, 0, 255), --
                Color(255, 0, 0, 150), Color(255, 0, 0, 50),
                Color(255, 0, 0, 0), Color(255, 0, 0, 0), Color(255, 0, 0, 0),
                --
                Color(255, 255, 255, 50), Color(255, 255, 255, 150),
                Color(255, 255, 255, 255), --
                Color(255, 255, 255, 150), Color(255, 255, 255, 50),
                Color(255, 255, 255, 0), Color(255, 255, 255, 0),
                Color(255, 255, 255, 0)
            },
            Speed = 0.065
        }, {
            pos = Vector(33, -8, 50),
            material = "sprites/light_ignorez",
            size = 70,

            Colors = {
                Color(255, 0, 0, 0), Color(255, 0, 0, 50),
                Color(255, 0, 0, 150), Color(255, 0, 0, 255), --
                Color(255, 0, 0, 150), Color(255, 0, 0, 50),
                Color(255, 0, 0, 0), Color(255, 0, 0, 0), --
                Color(255, 255, 255, 0), Color(255, 255, 255, 50),
                Color(255, 255, 255, 150), Color(255, 255, 255, 255), --
                Color(255, 255, 255, 150), Color(255, 255, 255, 50),
                Color(255, 255, 255, 0), Color(255, 255, 255, 0)
            },
            Speed = 0.065
        }, {
            pos = Vector(33, 8, 50),
            material = "sprites/light_ignorez",
            size = 70,

            Colors = {
                Color(255, 0, 0, 0), Color(255, 0, 0, 0), Color(255, 0, 0, 50),
                Color(255, 0, 0, 150), Color(255, 0, 0, 255), --
                Color(255, 0, 0, 150), Color(255, 0, 0, 50),
                Color(255, 0, 0, 0), --
                Color(255, 255, 255, 0), Color(255, 255, 255, 0),
                Color(255, 255, 255, 50), Color(255, 255, 255, 150),
                Color(255, 255, 255, 255), --
                Color(255, 255, 255, 150), Color(255, 255, 255, 50),
                Color(255, 255, 255, 0)
            },
            Speed = 0.065
        }, {
            pos = Vector(33, 22, 50),
            material = "sprites/light_ignorez",
            size = 70,

            Colors = {
                Color(255, 0, 0, 0), Color(255, 0, 0, 0), Color(255, 0, 0, 0),
                Color(255, 0, 0, 50), Color(255, 0, 0, 150),
                Color(255, 0, 0, 255), --
                Color(255, 0, 0, 150), Color(255, 0, 0, 50), --
                Color(255, 255, 255, 0), Color(255, 255, 255, 0),
                Color(255, 255, 255, 0), Color(255, 255, 255, 50),
                Color(255, 255, 255, 150), Color(255, 255, 255, 255), --
                Color(255, 255, 255, 150), Color(255, 255, 255, 50)
            },
            Speed = 0.065
        }
    },

    DelayOn = 0,
    DelayOff = 0,

    Turnsignal_sprites = {
        Left = {
            {
                pos = Vector(109, 36.6, 1.3),
                material = "sprites/light_ignorez",
                size = 60,
                color = Color(255, 135, 0, 255)
            }, {
                pos = Vector(-143.92, 38.33, -16.95),
                material = "sprites/light_ignorez",
                size = 60,
                color = Color(255, 0, 0, 255)
            }
        },
        Right = {
            {
                pos = Vector(109, -36.6, 1.3),
                material = "sprites/light_ignorez",
                size = 60,
                color = Color(255, 135, 0, 255)
            }, {
                pos = Vector(-143.92, -38.33, -16.95),
                material = "sprites/light_ignorez",
                size = 60,
                color = Color(255, 0, 0, 255)
            }
        }
    },

    SubMaterials = {
        off = {Base = {[8] = ""}},
        on_lowbeam = {
            Base = {[8] = "models/gtasa/vehicles/share/vehiclelightson128"}
        }
    }
}
list.Set("simfphys_lights", "gtasa_ambulan", light_table)
