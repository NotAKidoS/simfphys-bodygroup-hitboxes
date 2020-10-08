EFFECT.Init = function(self, data)
    local pos = data:GetOrigin()
    local emitter = ParticleEmitter(pos, false)
    do
        local i = 0
        while i < 60 do
            local particle = emitter:Add(
                "effects/fleck_tile" .. tostring(
                    math.random(1, 2)
                ),
                pos
            )
            local vel = VectorRand() * 200
            if particle then
                particle:SetVelocity(vel)
                particle:SetDieTime(
                    math.random(3, 5)
                )
                particle:SetAirResistance(10)
                particle:SetStartAlpha(150)
                particle:SetStartSize(2)
                particle:SetEndSize(0)
                particle:SetRoll(
                    math.random(-1, 1)
                )
                particle:SetColor(100, 100, 100)
                particle:SetGravity(
                    Vector(0, 0, -600)
                )
                particle:SetCollide(true)
                particle:SetBounce(0.3)
            else
                ErrorNoHalt("particle is nil, wtf???")
            end
            i = i + 1
        end
    end
    emitter:Finish()
end
EFFECT.Think = function() return false end
EFFECT.Render = function()
end
