--[[
	Shared file, stuff needed on both client and server
]]

NAK = istable(NAK) and NAK or {}
function NAK.GetHitboxes(self)
    local hblist = list.Get("nak_simf_hitboxes")
    local hbspawnlist = IsValid(self) and hblist[self:GetSpawn_List()] or false

    if hbspawnlist then
        local HBInfo = hbspawnlist[2] and hbspawnlist[1] or hbspawnlist
        local HBExtra = hbspawnlist[2] and hbspawnlist[2] or nil

        for id in pairs(HBInfo) do
            --Set current health, unless it is added by the mod maker
            HBInfo[id].CurHealth = HBInfo[id].CurHealth or HBInfo[id].Health
            HBInfo[id].Stage = 0
            --Mirror that hitbox!
            if HBInfo[id].Mirror then
                local MirrorAxis = HBInfo[id].Mirror
                HBInfo[id .. "_2"] = {}
                --The hitboxes bounds
                HBInfo[id .. "_2"].OBBMin = HBInfo[id].OBBMin * MirrorAxis
                HBInfo[id .. "_2"].OBBMax = HBInfo[id].OBBMax * MirrorAxis
                --Type of hitbox (normal, glass, gas tank)
                HBInfo[id .. "_2"].TypeFlag = HBInfo[id].TypeFlag
                --Gib model, offset, ect
                HBInfo[id .. "_2"].BDGroup = HBInfo[id].BDGroup_2
                HBInfo[id .. "_2"].GibModel = HBInfo[id].GibModel_2
                HBInfo[id .. "_2"].GibOffset = HBInfo[id].GibOffset * MirrorAxis
                --Health & stage
                HBInfo[id .. "_2"].Health = HBInfo[id].Health
                HBInfo[id .. "_2"].CurHealth = HBInfo[id].CurHealth
                HBInfo[id .. "_2"].Stage = HBInfo[id].Stage
            end
        end
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