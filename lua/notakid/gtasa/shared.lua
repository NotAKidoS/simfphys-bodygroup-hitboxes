--[[
	Part of the code is adapted from Neptune QTG's BTTF system vehicle addon.
	https://steamcommunity.com/sharedfiles/filedetails/?id=2135782690
	The part being the extra simfphys spawnmenu catagory. Unsure if it will be used though.

	Shared file, needed by both server and client
--]]

-- //Creates the config menu in the simfphys tab
local function createslider(x, y, sizex, sizey, label, command, parent, min,
                            max, default)
    local slider = vgui.Create("DNumSlider", parent)
    slider:SetPos(x, y)
    slider:SetSize(sizex, sizey)
    slider:SetText(label)
    slider:SetMin(min)
    slider:SetMax(max)
    slider:SetDecimals(2)
    slider:SetConVar(command)
    slider:SetValue(default)
    return slider
end
local function addhook(a, b, c) hook.Add(a, c or 'nak_gtasa_config', b) end
local function buildthemenu(self)

    local Background = vgui.Create('DShape', self.PropPanel)
    Background:SetType('Rect')
    Background:SetPos(20, 20)
    Background:SetColor(Color(0, 0, 0, 200))
    local y = 0

    if LocalPlayer():IsSuperAdmin() then

        y = y + 25
        local CheckBoxDamage = vgui.Create("DCheckBoxLabel", self.PropPanel)
        CheckBoxDamage:SetPos(25, y)
        CheckBoxDamage:SetText("Enable Damage")
        CheckBoxDamage:SetValue(GetConVar("sv_simfphys_enabledamage"):GetInt())
        CheckBoxDamage:SizeToContents()

        y = y + 18
        local DamageMul = vgui.Create("DNumSlider", self.PropPanel)
        DamageMul:SetPos(30, y)
        DamageMul:SetSize(345, 30)
        DamageMul:SetText("Physical Damage Multiplier")
        DamageMul:SetMin(0)
        DamageMul:SetMax(10)
        DamageMul:SetDecimals(3)
        DamageMul:SetValue(GetConVar("gtasa_physicdamagemultiplier"):GetFloat())

        y = y + 32
        local DamageMul = vgui.Create("DNumSlider", self.PropPanel)
        DamageMul:SetPos(30, y)
        DamageMul:SetSize(345, 30)
        DamageMul:SetText("Bullet Damage Multiplier")
        DamageMul:SetMin(0)
        DamageMul:SetMax(10)
        DamageMul:SetDecimals(3)
        DamageMul:SetValue(GetConVar("gtasa_takedamagemultiplier"):GetFloat())

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

addhook('SimfphysPopulateVehicles', function(pc, t, n)

    local node = t:AddNode('GTA:SA Config', 'icon16/wrench_orange.png')

    node.DoPopulate = function(self)
        if self.PropPanel then return end

        self.PropPanel = vgui.Create('ContentContainer', pc)
        self.PropPanel:SetVisible(false)
        self.PropPanel:SetTriggerSpawnlistChange(false)

        buildthemenu(self)
    end

    node.DoClick = function(self)
        self:DoPopulate()
        pc:SwitchPanel(self.PropPanel)
    end
end)