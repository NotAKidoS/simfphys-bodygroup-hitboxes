local V = {
    Name = "Fire Truck",
    Model = "models/gtasa/vehicles/firetruk/firetruk.mdl",
    Class = "gmod_sent_vehicle_fphysics_base",
    Category = "GTA:SA - Government",
    SpawnOffset = Vector(0, 0, 30),
    SpawnAngleOffset = 90,
    NAKGame = "GTA:SA",
    NAKType = "Government",
    FLEX = {Trailers = {outputPos = Vector(-108, 0, -12)}},
    Members = {
        Mass = 6500.0,

        GibModels = {
            "models/gtasa/vehicles/firetruk/chassis.mdl",
            -- "models/gtasa/vehicles/firetruk/bump_front_dam.mdl",
            -- "models/gtasa/vehicles/firetruk/door_lf_dam.mdl",
            -- "models/gtasa/vehicles/firetruk/door_rf_dam.mdl",
            "models/gtasa/vehicles/firetruk/wheel.mdl",
            "models/gtasa/vehicles/firetruk/wheel.mdl",
            "models/gtasa/vehicles/firetruk/wheel.mdl",
            "models/gtasa/vehicles/firetruk/wheel.mdl"
        },

        EnginePos = Vector(146.06, 0, -2.94),

        LightsTable = "gtasa_firetruk",

        OnSpawn = function(ent)
            local hitboxes = {}
            hitboxes.bumperf = {
                min = Vector(170, 50, -14),
                max = Vector(130, -50, -34),
                bdgroup = 1,
                gibmodel = "models/gtasa/vehicles/firetruk/bump_front_dam.mdl",
                giboffset = Vector(134.55, -44.34, -18.44),
                health = 200
            }
            hitboxes.dfdoor = {
                min = Vector(138, 50, 45),
                max = Vector(98, 30, -31),
                bdgroup = 2,
                gibmodel = "models/gtasa/vehicles/firetruk/door_lf_dam.mdl",
                giboffset = Vector(134.55, 44.33, 9.49),
                health = 100
            }
            hitboxes.pfdoor = {
                max = Vector(138, -50, 45),
                min = Vector(98, -30, -31),
                bdgroup = 3,
                gibmodel = "models/gtasa/vehicles/firetruk/door_rf_dam.mdl",
                giboffset = Vector(134.55, -44.33, 9.49),
                health = 100
            }
            hitboxes.windowf = {
                min = Vector(133, 44, 42),
                max = Vector(153, -44, 15),
                bdgroup = 4,
                health = 6,
                glass = true,
                glasspos = Vector(142.4, 0, 28.89)
            }

            hitboxes.gastank = {
                min = Vector(-122, 44, -15),
                max = Vector(-139, 36, -25),
                explode = true
            }

            ent:SetBodyGroups("00000" .. math.random(0, 3)) -- sets random number

            ent:NAKAddHitBoxes(hitboxes)
            ent:NAKSimfGTASA() -- function that'll do all the GTASA changes for you

            ent:NAKSimfEMSRadio()

            if (ProxyColor) then
                local CarCols = {}
                CarCols[1] = {
                    Color(132, 4, 16), Color(245, 245, 245),
                    Color(245, 245, 245), Color(0, 0, 0), Color(245, 245, 245)
                }
                ent:SetProxyColor(CarCols[1])
            end
        end,

        OnTick = function(ent)
            if ent.horn then ent.horn:ChangePitch(90, 0) end
        end,

        CustomWheels = true,
        CustomSuspensionTravel = 1.5,

        CustomWheelModel = "models/gtasa/vehicles/firetruk/wheel.mdl",

        CustomWheelPosFL = Vector(90.6, 38.76, -30),
        CustomWheelPosFR = Vector(90.6, -38.76, -30),
        CustomWheelPosRL = Vector(-75.69, 38.76, -30),
        CustomWheelPosRR = Vector(-75.69, -38.76, -30),
        CustomWheelAngleOffset = Angle(0, 90, 0),

        CustomMassCenter = Vector(0, 0, 20),

        CustomSteerAngle = 45,

        SeatOffset = Vector(105, -22, 25),
        SeatPitch = 0,
        SeatYaw = 90,

        PassengerSeats = {{pos = Vector(112, -22, -7), ang = Angle(0, -90, 10)}},
        ExhaustPositions = {
            {pos = Vector(-141.16, -18.48, -29.43), ang = Angle(-90, 0, 0)}
        },
        Attachments = {
            {
                model = "models/gtasa/vehicles/firetruk/steering.mdl",
                color = Color(255, 255, 255, 255),
                pos = Vector(0, 0, 0),
                ang = Angle(0, 0, 0)
            }
        },

        StrengthenSuspension = true,

        FrontHeight = 10,
        FrontConstant = 50000,
        FrontDamping = 5000,
        FrontRelativeDamping = 350,

        RearHeight = 10,
        RearConstant = 50000,
        RearDamping = 5000,
        RearRelativeDamping = 800,

        FastSteeringAngle = 25,
        SteeringFadeFastSpeed = 350,

        TurnSpeed = 4,

        MaxGrip = 150,
        Efficiency = 1,
        GripOffset = -9,
        BrakePower = 60,
        BulletProofTires = false,

        IdleRPM = 600,
        LimitRPM = 5000,
        PeakTorque = 170,
        PowerbandStart = 1700,
        PowerbandEnd = 4500,
        Turbocharged = false,
        Supercharged = false,
        DoNotStall = false,

        FuelFillPos = Vector(-18.9, 51.31, -3.43),
        FuelType = FUELTYPE_DIESEL,
        FuelTankSize = 250,

        PowerBias = 0.8,

        EngineSoundPreset = -1,

        snd_pitch = 1,
        snd_idle = "gtasa/vehicles/77-78_idle.wav",

        snd_low = "gtasa/vehicles/77-78_cruise.wav",
        snd_low_revdown = "gtasa/vehicles/77-78_cruise_loop.wav",
        snd_low_pitch = 0.95,

        snd_mid = "gtasa/vehicles/77-78_gear_loop.wav",
        snd_mid_gearup = "gtasa/vehicles/77-78_gear.wav",
        snd_mid_pitch = 1.2,

        snd_horn = "gtasa/vehicles/horns/horn_005.wav",

        DifferentialGear = 0.15,
        Gears = {-0.14, 0, 0.15, 0.3, 0.5, 0.65, 0.85}
    }
}
list.Set("simfphys_vehicles", "sim_fphys_gtasa_firetruk", V)

local light_table = {
    L_HeadLampPos = Vector(157.01, 27.87, -5.26),
    L_HeadLampAng = Angle(17, 0, 0),
    R_HeadLampPos = Vector(157.01, -27.87, -5.26),
    R_HeadLampAng = Angle(10, 0, 0),

    L_RearLampPos = Vector(-131.98, 37, 8.49),
    L_RearLampAng = Angle(25, 180, 0),
    R_RearLampPos = Vector(-131.98, -37, 8.49),
    R_RearLampAng = Angle(25, 180, 0),

    Headlight_sprites = {
        {
            pos = Vector(157.01, 27.87, -5.26),
            material = "sprites/light_ignorez",
            size = 70,
            color = Color(255, 238, 200, 255)
        }, {
            pos = Vector(157.01, -27.87, -5.26),
            material = "sprites/light_ignorez",
            size = 70,
            color = Color(255, 238, 200, 255)
        }
    },

    Headlamp_sprites = {
        {
            pos = Vector(157.01, 27.87, -5.26),
            size = 100,
            material = "sprites/light_ignorez"
        }, {
            pos = Vector(157.01, -27.87, -5.26),
            size = 100,
            material = "sprites/light_ignorez"
        }
    },

    Rearlight_sprites = {
        {
            pos = Vector(-131.98, 37, 8.49),
            material = "sprites/light_ignorez",
            size = 60,
            color = Color(255, 0, 0, 255)
        }, {
            pos = Vector(-131.98, -37, 8.49),
            material = "sprites/light_ignorez",
            size = 60,
            color = Color(255, 0, 0, 255)
        }
    },
    Brakelight_sprites = {
        {
            pos = Vector(-131.98, 37, 8.49),
            material = "sprites/light_ignorez",
            size = 70,
            color = Color(255, 0, 0, 255)
        }, {
            pos = Vector(-131.98, -37, 8.49),
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
            pos = Vector(122, -25, 56),
            material = "sprites/light_ignorez",
            size = 90,
            Colors = {
                Color(255, 0, 0, 50), Color(255, 0, 0, 150),
                Color(255, 0, 0, 255), --
                Color(255, 0, 0, 150), Color(255, 0, 0, 50),
                Color(255, 0, 0, 0), Color(255, 0, 0, 0), Color(255, 0, 0, 0),
                --
                Color(255, 220, 0, 50), Color(255, 220, 0, 150),
                Color(255, 220, 0, 255), --
                Color(255, 220, 0, 150), Color(255, 220, 0, 50),
                Color(255, 220, 0, 0), Color(255, 220, 0, 0),
                Color(255, 220, 0, 0)
            },
            Speed = 0.065
        }, {
            pos = Vector(122, -8, 56),
            material = "sprites/light_ignorez",
            size = 90,
            Colors = {
                Color(255, 0, 0, 0), Color(255, 0, 0, 50),
                Color(255, 0, 0, 150), Color(255, 0, 0, 255), --
                Color(255, 0, 0, 150), Color(255, 0, 0, 50),
                Color(255, 0, 0, 0), Color(255, 0, 0, 0), --
                Color(255, 220, 0, 0), Color(255, 220, 0, 50),
                Color(255, 220, 0, 150), Color(255, 220, 0, 255), --
                Color(255, 220, 0, 150), Color(255, 220, 0, 50),
                Color(255, 220, 0, 0), Color(255, 220, 0, 0)
            },
            Speed = 0.065
        }, {
            pos = Vector(122, 8, 56),
            material = "sprites/light_ignorez",
            size = 90,
            Colors = {
                Color(255, 0, 0, 0), Color(255, 0, 0, 0), Color(255, 0, 0, 50),
                Color(255, 0, 0, 150), Color(255, 0, 0, 255), --
                Color(255, 0, 0, 150), Color(255, 0, 0, 50),
                Color(255, 0, 0, 0), --
                Color(255, 220, 0, 0), Color(255, 220, 0, 0),
                Color(255, 220, 0, 50), Color(255, 220, 0, 150),
                Color(255, 220, 0, 255), --
                Color(255, 220, 0, 150), Color(255, 220, 0, 50),
                Color(255, 220, 0, 0)
            },
            Speed = 0.065
        }, {
            pos = Vector(122, 25, 56),
            material = "sprites/light_ignorez",
            size = 90,
            Colors = {
                Color(255, 0, 0, 0), Color(255, 0, 0, 0), Color(255, 0, 0, 0),
                Color(255, 0, 0, 50), Color(255, 0, 0, 150),
                Color(255, 0, 0, 255), --
                Color(255, 0, 0, 150), Color(255, 0, 0, 50), --
                Color(255, 220, 0, 0), Color(255, 220, 0, 0),
                Color(255, 220, 0, 0), Color(255, 220, 0, 50),
                Color(255, 220, 0, 150), Color(255, 220, 0, 255), --
                Color(255, 220, 0, 150), Color(255, 220, 0, 50)
            },
            Speed = 0.065
        }
    },

    DelayOn = 0,
    DelayOff = 0,

    Turnsignal_sprites = {
        Left = {
            {
                pos = Vector(155, 31, 3),
                material = "sprites/light_ignorez",
                size = 60,
                color = Color(255, 135, 0, 255)
            }, {
                pos = Vector(-130, 38, 3),
                material = "sprites/light_ignorez",
                size = 60,
                color = Color(255, 135, 0, 255)
            }
        },
        Right = {
            {
                pos = Vector(155, -31, 3),
                material = "sprites/light_ignorez",
                size = 60,
                color = Color(255, 135, 0, 255)
            }, {
                pos = Vector(-130, -38, 3),
                material = "sprites/light_ignorez",
                size = 60,
                color = Color(255, 135, 0, 255)
            }
        }
    },

    SubMaterials = {
        off = {Base = {[10] = ""}},
        on_lowbeam = {
            Base = {[10] = "models/gtasa/vehicles/share/vehiclelightson128"}
        }
    }
}
list.Set("simfphys_lights", "gtasa_firetruk", light_table)
