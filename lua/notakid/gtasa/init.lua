
--//Creates the sounds used by the addon.

sound.Add( {
	name = "NAKGTASAFire",
	channel = CHAN_STATIC,
	volume = 0.8,
	level = 70,
	pitch = {95, 110},
	sound = "gtasa/sfx/fire_loop.wav"
} )
sound.Add( {
	name = "NAKGTASAFireEng",
	channel = CHAN_STATIC,
	volume = 0.4,
	level = 72,
	pitch = {95, 110},
	sound = "gtasa/sfx/engine_damaged_loop.wav"
} )

--//Creates the config menu in the simfphys tab
--[[
	This part of the code is adapted from Neptune QTG's BTTF system vehicle addon.
	https://steamcommunity.com/sharedfiles/filedetails/?id=2135782690
--]]

local function addhook(a,b,c)
    hook.Add(a,c or 'nak_gtasa_config',b)
end

local function buildthemenu( self )
	local Background = vgui.Create('DShape',self.PropPanel)
	Background:SetType('Rect')
	Background:SetPos(20,20)
	Background:SetColor(Color(0,0,0,200))
	local y = 0
	
	if LocalPlayer():IsSuperAdmin() then
		y = y + 25
		local settime = vgui.Create('DCheckBoxLabel',self.PropPanel)
		settime:SetPos(25,y)
		settime:SetText('Set the time to the real time at the beginning of the game')
		settime:SetValue(0)
		settime:SizeToContents()
		
		y = y + 30
		local DermaButton = vgui.Create('DButton')
		DermaButton:SetParent(self.PropPanel)
		DermaButton:SetText('Apply')	
		DermaButton:SetPos(25,y-10)
		DermaButton:SetSize(340,25)
        DermaButton.DoClick = function()
			print("aaa")
		end
		
		y = y + 30
		local DermaButton = vgui.Create('DButton')
		DermaButton:SetParent(self.PropPanel)
		DermaButton:SetText('Reset')
		DermaButton:SetPos(25,y-10)
		DermaButton:SetSize(340,25)
		DermaButton.DoClick = function()
			print("aaa222")
		end
	else
		y = y + 25
		local Label = vgui.Create('DLabel',self.PropPanel)
		Label:SetPos(30,y)
		Label:SetText("whatthehell")
		Label:SizeToContents()
	end
	
	Background:SetSize(350,y)
end


addhook('SimfphysPopulateVehicles', function(pc,t,n)
    
    local node = t:AddNode('GTA:SA Config','icon16/wrench_orange.png')

	node.DoPopulate = function(self)
		if self.PropPanel then return end
		
		self.PropPanel = vgui.Create('ContentContainer',pc)
		self.PropPanel:SetVisible(false)
		self.PropPanel:SetTriggerSpawnlistChange(false)

		buildthemenu(self)
    end
    
	node.DoClick = function(self)
		self:DoPopulate()
		pc:SwitchPanel(self.PropPanel)
	end
end)

--//Client stuff
if CLIENT then
	CreateClientConVar( "nak_simf_hitboxes",  0, FCVAR_ARCHIVE_XBOX, "Debug Simfphys hitboxes for supported vehicles" )
	CreateClientConVar( "nak_simf_hitboxes_filled",  0, FCVAR_ARCHIVE_XBOX, "Filled boxes instead of wireframe?" )
	CreateClientConVar( "nak_simf_hitbox_color",  "255 255 255", FCVAR_ARCHIVE_XBOX, "Set a color for the box AS A STRING '255,255,255'" )
	CreateClientConVar( "nak_simf_hitbox_alpha",  "200", FCVAR_ARCHIVE_XBOX, "Set the alpha of the hitbox" )

	hook.Add( "PostDrawTranslucentRenderables", "nak_simf_hitboxes", function()
		if GetConVar("nak_simf_hitboxes"):GetInt() == 0 then return end
		for k, ent in pairs( ents.GetAll() ) do
			if ( ent:GetClass() == "gmod_sent_vehicle_fphysics_base" ) then
				if (!ent.hbinfo) then return end
				for id in SortedPairs( ent.hbinfo ) do
					local clcolor = util.StringToType( GetConVar("nak_simf_hitbox_color"):GetString(), "Vector" )
					local clalpha = GetConVar("nak_simf_hitbox_alpha"):GetFloat()
					local color = Color(clcolor.x,clcolor.y,clcolor.z,clalpha)	
					render.SetColorMaterial()
					if GetConVar("nak_simf_hitboxes_filled"):GetInt() == 0 then
						render.DrawWireframeBox( ent:GetPos(), ent:GetAngles(), ent.hbinfo[id].min, ent.hbinfo[id].max, color )
					else
						render.DrawBox( ent:GetPos(), ent:GetAngles(), ent.hbinfo[id].min, ent.hbinfo[id].max, color )
					end
				end
			end
		end
	end )

	net.Receive("simf_dmgengine_sound", function(length)
		local self = net.ReadEntity()
		local snd = net.ReadString()
		if IsValid( self ) then
			self.DamageSnd = CreateSound(self, snd)
		end
	end)
	
	net.Receive("nakkillveh_fire", function(length)
		local self = net.ReadEntity()
		if IsValid( self ) then
			local delay = 0.1
			local nextOccurance = 0
			
			hook.Add( "Think", "nakkillveh_fire_" .. self:EntIndex(), function()
				local timeLeft = nextOccurance - CurTime()
				if timeLeft > 0 then return end
				if IsValid(self) then
					local effectdata = EffectData()
					effectdata:SetOrigin( self:GetEnginePos() + Vector(0,0,25) )
					effectdata:SetEntity( self )
					util.Effect( "simf_gtasa_fire", effectdata )
					nextOccurance = CurTime() + delay
				else
					hook.Remove( "Think", "nakkillveh_fire_" .. self:EntIndex() )
				end
			end )
		end
	end)
else --//server code
	util.AddNetworkString( "simf_dmgengine_sound" )
	util.AddNetworkString( "nakkillveh_fire" )
end



--[[
	FUNCTIONS AND STUFF OH OH OH OH OH OH OH OH OH OH OH OH OH O im bored
	
	meow
	
	spacing things out
--]]



local Entity = FindMetaTable( "Entity" )

function Entity:NAKDmgEngineSnd(snd) --//custom damaged engine sound needs to be networked to the client as its clientsided
	net.Start( "simf_dmgengine_sound" )
		net.WriteEntity( self )
		net.WriteString( snd )
	net.Broadcast()
end

function Entity:NAKSimfEngineStart(snd)
	self.StartEngine  = function(self)
		if not self:CanStart() then return end
		if not self:EngineActive() then
			if not bIgnoreSettings then
				self.CurrentGear = 2
			end
			if not self.IsInWater then
				self:EmitSound( snd )
				self.EngineRPM = self:GetEngineData().IdleRPM
				self.EngineIsOn = 1
			else
				if self:GetDoNotStall() then
					self.EngineRPM = self:GetEngineData().IdleRPM
					self.EngineIsOn = 1
					self:EmitSound( snd )
				end
			end
		end
	end
end

function Entity:NAKSimfSkidSounds(wheelsnds)

	if wheelsnds == nil then 
		wheelsnds = {}
		wheelsnds.snd_skid = "gtasa/sfx/tireskid.wav"
		wheelsnds.snd_skid_dirt = "gtasa/sfx/tire_dirt.wav"
		wheelsnds.snd_skid_grass = "gtasa/sfx/tire_grass.wav"
	end
	
	for i = 1, table.Count( self.Wheels ) do
		local Wheel = self.Wheels[i]
		Wheel.snd_skid = wheelsnds.snd_skid
		Wheel.snd_skid_dirt = wheelsnds.snd_skid_dirt
		Wheel.snd_skid_grass = wheelsnds.snd_skid_grass
	end
end

--//prolly not good upsidedown damage timer thing stuffs
function Entity:NAKKillVehicle()
	net.Start( "nakkillveh_fire" )
		net.WriteEntity( self )
	net.Broadcast()
	
	self:EmitSound( "NAKGTASAFire" )
	if self:EngineActive() then
		self:EmitSound( "NAKGTASAFireEng" )
	end
	self:CallOnRemove( "NAKGTASAFireSoundRemove", function() self:StopSound( "NAKGTASAFire" ) self:StopSound( "NAKGTASAFireEng" ) end)
	
	timer.Create( "GTASAKillVeh_" .. self:EntIndex(), math.random(4,5), 1, function()
		if !IsValid(self) then return end
		self:ExplodeVehicle()
	end)
end
function Entity:NAKSimfFireTime(Danger)
	if Danger then
		if !self.NAKUpsideDownDanger then
			self.NAKUpsideDownDanger = true
			timer.Create( "GTASADanger_" .. self:EntIndex(), math.random(3.5,4.5), 1, function()
				if !IsValid(self) then return end
				if !self.NAKUpsideDownDanger then return end
				self:NAKKillVehicle()
			end)
		end
	else
		self.NAKUpsideDownDanger = false
	end
end

function Entity:NAKSimfTickStuff()

	
	self.OnTick_UDF = self.OnTick --//store the old built in simfphys function
	
	self.OnTick  = function(self) --//override the old function to call our code first, then call the old stored one
	
		if self:GetAngles():Up().z < -0.7 then
			self:NAKSimfFireTime(true)
		else
			self:NAKSimfFireTime(false)
		end
		
		if self.NAKGTASAFireDamage == 1000 then
			self:NAKKillVehicle()
		end
		
		if self:GetGear() == 1 then
			self.ReverseSound:ChangeVolume( 1, 0.2 )
			self.ReverseSound:ChangePitch( math.Clamp(self:GetRPM()/50,0,100), 0.4 )
		elseif self.ReverseSound then
			self.ReverseSound:ChangePitch( 0, 0.8 )
			self.ReverseSound:ChangeVolume( 0, 0.4 )
		end
		
		self:OnTick_UDF()
	end
	
end

--MAIN GLOBAL FUNCTION TO APPLY MOST IF NOT ALL OF THESE TO ALL VEHICLES
--(i can update this function to apply to all vehicles using it)

function Entity:NAKSimfGTASA()

	if !self.ReverseSound then
		self.ReverseSound = CreateSound(self, "gtasa/vehicles/reverse_gear.wav")
		self.ReverseSound:PlayEx(0,0)
		self:CallOnRemove( "GTASARevSound", function() if self.ReverseSound then self.ReverseSound:Stop() end end)
	end

	self:NAKSimfSkidSounds() -- replaces the wheel skid sounds
	self:NAKSimfEngineStart("gtasa/sfx/engine_start.wav")
	-- self:NAKSimfCustomExplode()
	self:NAKDmgEngineSnd("gtasa/sfx/engine_damaged_loop.wav")
	self:NAKSimfTickStuff()
end











--//All done!
print("loaded")

