--[[
	Shared file, stuff needed on both client and server
]]

NAK = istable(NAK) and NAK or {}
function NAK.GetHitboxes(self)
	
	if self.NAKHitboxes then return self.NAKHitboxes end
	
    local hblist = list.Get("nak_simf_hitboxes")
    local hbspawnlist = IsValid(self) and hblist[self:GetSpawn_List()] or false

    if hbspawnlist then
        local HBInfo = hbspawnlist[2] and hbspawnlist[1] or hbspawnlist
		local HBMirror = {}
        local HBExtra = hbspawnlist[2] and hbspawnlist[2] or nil

        for id in pairs(HBInfo) do
            --Set current health, unless it is added by the mod maker
            HBInfo[id].CurHealth = HBInfo[id].CurHealth or HBInfo[id].Health
            HBInfo[id].Stage = 0
			
			if HBInfo[id].HitboxID then
			
				local HitboxID = HBInfo[id].HitboxID
				
				-- print( "HitboxID: " .. HitboxID )
				
				local BonePos, BoneAng =  self:GetBonePosition( self:GetHitBoxBone(HitboxID, 0) )
		 		local BoneHBMin, BoneHBMax = self:GetHitBoxBounds(HitboxID, 0)
				HBInfo[id].OBBMin = HBInfo[id].OBBMin and HBInfo[id].OBBMin or Vector(0,0,0)
				HBInfo[id].OBBMax = HBInfo[id].OBBMax and HBInfo[id].OBBMax or Vector(0,0,0)

				-- convert the bounds to worldspace
				BoneHBMin = LocalToWorld( BoneHBMin, Angle(), BonePos, BoneAng )
				BoneHBMax = LocalToWorld( BoneHBMax, Angle(), BonePos, BoneAng )
				-- convert to vehicles localspace
				BoneHBMin = WorldToLocal( BoneHBMin, Angle(), self:GetPos(), self:GetAngles() )
				BoneHBMax = WorldToLocal( BoneHBMax, Angle(), self:GetPos(), self:GetAngles() )
				
				
				HBInfo[id].OBBMin = BoneHBMax - HBInfo[id].OBBMin 
				HBInfo[id].OBBMax = BoneHBMin - HBInfo[id].OBBMax
			end
			
            --Mirror that hitbox!
            if HBInfo[id].Mirror then
                local MirrorAxis = HBInfo[id].Mirror
                HBMirror[id .. "_2"] = {}
                --The hitboxes bounds
                HBMirror[id .. "_2"].OBBMin = HBInfo[id].OBBMax * MirrorAxis
                HBMirror[id .. "_2"].OBBMax = HBInfo[id].OBBMin * MirrorAxis
                --Type of hitbox (normal, glass, gas tank)
                HBMirror[id .. "_2"].TypeFlag = HBInfo[id].TypeFlag
                --Gib model, offset, ect
                HBMirror[id .. "_2"].BDGroup = HBInfo[id].BDGroup_2
				if HBInfo[id].GibModel then
					HBMirror[id .. "_2"].GibModel = HBInfo[id].GibModel_2
					HBMirror[id .. "_2"].GibOffset = HBInfo[id].GibOffset * MirrorAxis
				end
                --Health & stage
                HBMirror[id .. "_2"].Health = HBInfo[id].Health
                HBMirror[id .. "_2"].CurHealth = HBInfo[id].CurHealth
                HBMirror[id .. "_2"].Stage = HBInfo[id].Stage
            end
        end
		
		table.Merge( HBInfo, HBMirror )
		
		-- print("Actual List:")
		-- for i=1, self:GetBoneCount()-1 do
			
			-- print( i, self:GetBoneName( i ) )
		-- end
		
        return HBInfo, HBExtra
    else
        return false
    end
end


-- Simfphys Menu Stuff

local function BuildMenu(self)

    local Background = vgui.Create('DShape', self.PropPanel)
    Background:SetType('Rect')
    Background:SetPos(20, 20)
    Background:SetColor(Color(0, 0, 0, 200))
    local y = 0

    if LocalPlayer():IsSuperAdmin() then

        y = y + 25
        local CheckBoxDamage = vgui.Create("DCheckBoxLabel", self.PropPanel)
        CheckBoxDamage:SetPos(25, y)
        CheckBoxDamage:SetText("Debug Hitboxes")
        CheckBoxDamage:SetValue(GetConVar("nak_simf_hitboxes"):GetBool())
        CheckBoxDamage:SizeToContents()

        -- y = y + 18
        -- local DamageMul = vgui.Create("DNumSlider", self.PropPanel)
        -- DamageMul:SetPos(30, y)
        -- DamageMul:SetSize(345, 30)
        -- DamageMul:SetText("Physical Damage Multiplier")
        -- DamageMul:SetMin(0)
        -- DamageMul:SetMax(10)
        -- DamageMul:SetDecimals(3)
        -- DamageMul:SetValue(GetConVar("gtasa_physicdamagemultiplier"):GetFloat())

        -- y = y + 32
        -- local DamageMul = vgui.Create("DNumSlider", self.PropPanel)
        -- DamageMul:SetPos(30, y)
        -- DamageMul:SetSize(345, 30)
        -- DamageMul:SetText("Bullet Damage Multiplier")
        -- DamageMul:SetMin(0)
        -- DamageMul:SetMax(10)
        -- DamageMul:SetDecimals(3)
        -- DamageMul:SetValue(GetConVar("gtasa_takedamagemultiplier"):GetFloat())

        y = y + 18
    else
        y = y + 25
        local Label = vgui.Create('DLabel', self.PropPanel)
        Label:SetPos(30, y)
        Label:SetText("Admin-Only Settings!")
        Label:SizeToContents()
    end

    Background:SetSize(350, y)
end

hook.Add("SimfphysPopulateVehicles", "nak_gtasa_config", function(pc, t, n)

    local node = t:AddNode("Hitbox Config", "icon16/wrench_orange.png")

    node.DoPopulate = function(self)
        if self.PropPanel then return end
		
        self.PropPanel = vgui.Create("ContentContainer", pc)
        self.PropPanel:SetVisible(false)
        self.PropPanel:SetTriggerSpawnlistChange(false)
		
        BuildMenu(self)
    end

    node.DoClick = function(self)
        self:DoPopulate()
        pc:SwitchPanel(self.PropPanel)
    end
end)