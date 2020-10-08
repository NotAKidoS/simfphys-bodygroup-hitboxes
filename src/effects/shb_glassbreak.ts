EFFECT.Init = function (this: EffectHooks, data: CEffectData) {
	const pos = data.GetOrigin()
	const emitter = ParticleEmitter(pos, false)
	for (let i = 0; i < 60; i++) {
		const particle = emitter.Add("effects/fleck_tile" + math.random(1, 2), pos)
		const vel = (VectorRand() as any as number) * 200 as any as Vector
		if (particle) {
			particle.SetVelocity(vel)
			particle.SetDieTime(math.random(3, 5))
			particle.SetAirResistance(10)
			particle.SetStartAlpha(150)
			particle.SetStartSize(2)
			particle.SetEndSize(0)
			particle.SetRoll(math.random(-1, 1))
			particle.SetColor(100, 100, 100)
			particle.SetGravity(Vector(0, 0, -600)) // wat?
			particle.SetCollide(true)
			particle.SetBounce(0.3)
		} else {
			ErrorNoHalt("particle is nil, wtf???")
		}
	}
	emitter.Finish()
}
EFFECT.Think = () => false
EFFECT.Render = () => { }
