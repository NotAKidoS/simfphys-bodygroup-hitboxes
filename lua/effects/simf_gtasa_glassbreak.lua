-- written by NotAKidoS, code is shit but it works.
-- If you would like to use this in your addon then you may go ahead and do so,
-- BUT rename the functions and convars. I dont want to update my addon and have it conflict.
-- Id rather you set this addon as a requirment anyways so you get updates whenever gmod breaks the addon
-- but i cant really stop you with text, i doubt you even read all of this.
function EFFECT:Init(data)
    local Pos = data:GetOrigin()
    self:GlassBreak(Pos)
end

function EFFECT:GlassBreak(pos)
    local emitter = ParticleEmitter(pos, false)

    if emitter then

        for i = 0, 60 do
            local particle = emitter:Add(
                                 "effects/fleck_tile" .. math.random(1, 2), pos)
            local vel = VectorRand() * 200
            if particle then
                particle:SetVelocity(vel)
                particle:SetDieTime(math.Rand(3, 5))
                particle:SetAirResistance(10)
                particle:SetStartAlpha(150)
                particle:SetStartSize(5)
                particle:SetEndSize(2)
                particle:SetRoll(math.Rand(-1, 1))
                particle:SetColor(100, 100, 100)
                particle:SetGravity(Vector(0, 0, -600))
                particle:SetCollide(true)
                particle:SetBounce(0.3)
            end
        end

        emitter:Finish()
    end
end

function EFFECT:Think() return false end

function EFFECT:Render() end
