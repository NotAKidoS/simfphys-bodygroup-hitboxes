--[[
	Init file, sets things up for client and server
]]
sound.Add({
    name = "NAKGTASAFire",
    channel = CHAN_STATIC,
    volume = 0.8,
    level = 70,
    pitch = {95, 110},
    sound = "gtasa/sfx/fire_loop.wav"
})
sound.Add({
    name = "NAKGTASAFireEng",
    channel = CHAN_STATIC,
    volume = 0.4,
    level = 72,
    pitch = {95, 110},
    sound = "gtasa/sfx/engine_damaged_loop.wav"
})

AddCSLuaFile( "notakid/gtasa/client.lua" )
AddCSLuaFile( "notakid/gtasa/shared.lua" )
include( "notakid/gtasa/shared.lua" )
if CLIENT then
	include( "notakid/gtasa/client.lua" )
	return
end
--Rest of code is SERVER only
NAK = istable( NAK ) and NAK or {} 
util.AddNetworkString("nak_simf_gtasa_dmgsnd")
util.AddNetworkString("nak_gtasa_updsidedownfire")

-- //prolly not good upsidedown damage timer thing stuffs
local function KillVehicle(self)
    net.Start("nak_gtasa_updsidedownfire")
		net.WriteEntity(self)
    net.Broadcast()

    self:EmitSound("NAKGTASAFire")
    if self:EngineActive() then self:EmitSound("NAKGTASAFireEng") end

    self:CallOnRemove("NAKGTASAFireSoundRemove", function()
        self:StopSound("NAKGTASAFire")
        self:StopSound("NAKGTASAFireEng")
    end)

    timer.Create("GTASAKillVeh_" .. self:EntIndex(), math.random(4, 5), 1,function()
        if not IsValid(self) then return end
        self:ExplodeVehicle()
    end)
end
--Stuff that needs to run OnTick
local function GTASATickChecks(self)
	--store
    self.OldOnTick = self.OnTick 
	--override
    self.OnTick = function(self)
		local Time = CurTime()
		self:OldOnTick()
		--simfphys Think function handles the nexttick stuff
		if self.NextTick < Time then
			local CheckAngle = self:GetAngles():Up().z
			local Gear = self:GetGear()
			if CheckAngle < -0.7 then
				if !self.NAKMarkDeath then
					self.NAKMarkDeath = true
					timer.Create("GTASADanger_"..self:EntIndex(),math.random(3.5, 4.5),1,function()
						KillVehicle(self)
					end)
				end
			elseif (timer.Exists("GTASADanger_"..self:EntIndex())) then
				timer.Remove("GTASADanger_"..self:EntIndex())
				self.NAKMarkDeath = false
			end
			
			if Gear == 1 then
				self.ReverseSound:ChangeVolume(1,0.2)
				self.ReverseSound:ChangePitch(math.Clamp(self:GetRPM()/50,0,100),0.4)
			else
				self.ReverseSound:ChangePitch(0,0.8)
				self.ReverseSound:ChangeVolume(0,0.4)
			end
		end
	end
end
--EMS Radio for EMS vehicles, shitty implementation I think
local function PlayEMSRadio(self)
    if not IsValid(self) then return end
    local filter = RecipientFilter()
    if IsValid(self:GetDriver()) then filter:AddPlayer(self:GetDriver()) end
    if self.PassengerSeats then
        for i = 1, table.Count(self.PassengerSeats) do
            local Passenger = self.pSeat[i]:GetDriver()
            if IsValid(Passenger) then filter:AddPlayer(Passenger) end
        end
    end
    self.NAKEMSRadio = CreateSound(self,"gtasa/sfx/police_radio/police_radio"..math.random(1, 53) .. ".wav", filter)
    self.NAKEMSRadio:SetSoundLevel(100)
    self.NAKEMSRadio:PlayEx(2, 100)
    timer.Create("NAKGTASA_EMSRadio_" .. self:EntIndex(), math.random(20, 45),1, function() PlayEMSRadio(self) end)
end
--Custom skid sounds
local function GTASASkidSounds(self)
    for i = 1, #self.Wheels do
        local Wheel = self.Wheels[i]
        Wheel.snd_skid = "gtasa/sfx/tireskid.wav"
        Wheel.snd_skid_dirt = "gtasa/sfx/tire_dirt.wav"
        Wheel.snd_skid_grass = "gtasa/sfx/tire_grass.wav"
    end
end
--Start engine sound (lazy way)
local function GTAEngineStart(self)
    self.StartEngine = function(self, bIgnoreSettings)
        if not self:CanStart() then return end
        if not self:EngineActive() then
            if not bIgnoreSettings then self.CurrentGear = 2 end
            if not self.IsInWater or self:GetDoNotStall() then
                self:EmitSound("gtasa/sfx/engine_start.wav")
                self.EngineRPM = self:GetEngineData().IdleRPM
                self.EngineIsOn = 1
            end
        end
    end
end
--Main (global) functions to apply to vehicles
function NAK.GTASAEMSRadio(self)
    timer.Create("NAKGTASA_EMSRadio_"..self:EntIndex(), 1, 1,function() PlayEMSRadio(self) end)
end
--Trailer function thingie
function NAK.SimfTrailer(self)
    for i = 1, table.Count(self.Wheels) do self.Wheels[i].Use = nil end
    if self.TrailerUse then
        self.Use = nil
        self.Use = function() self:TrailerUse() end
    else
        self.Use = nil
    end
end
--Function that should be on most or all GTASA vehicles
function NAK.SimfGTASA(self)
    if not self.ReverseSound then
        self.ReverseSound = CreateSound(self, "gtasa/vehicles/reverse_gear.wav")
        self.ReverseSound:PlayEx(0, 0)
        self:CallOnRemove("GTASARevSound", function()
            if self.ReverseSound then self.ReverseSound:Stop() end
        end)
    end
	--replaces the wheel skid sounds
    GTASASkidSounds(self)
	--Custom engine start sound (lazy way)
	GTAEngineStart(self)
	--Upsidedown self destruct check
	GTASATickChecks(self)

	--Damaged Engine Sound
    net.Start("nak_simf_gtasa_dmgsnd")
    net.WriteEntity(self)
    net.WriteString("gtasa/sfx/engine_damaged_loop.wav")
    net.Broadcast()
end