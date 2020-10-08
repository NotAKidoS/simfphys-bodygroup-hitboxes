function defaultOnCollide(this: void, hbox: HitBox, ent: HitboxCar, data: CollisionData, physobj: PhysObj) {
	if (data.Speed > 50 && data.DeltaTime > 0.8) {
		ent.EmitSound("gtasa/sfx/damage_hvy" + math.random(1, 7) + ".wav")
	}
}

namespace SHB {
	export function IsValidCollideEntity(this: void, ent: Entity) {
		return true//(!ent.IsNPC) && (!ent.IsPlayer()) && (!(ent as any).IsNextBot())
	}
	export function TakeDamage(this: void, ent: HitboxCar, damagePos: Vector, damage: number, physical: boolean, dmginfo_or_data: CTakeDamageInfo | CollisionData, physobj?: PhysObj) {
		if (!ent.HitBoxes) error("SHB: why you trying to manage hitboxes on car without it?")
		for (const hbox_key in ent.HitBoxes as table) {
			const hbox = ent.HitBoxes[hbox_key as any]
			if (damagePos.WithinAABox(hbox.HBMin || hbox.OBBMin, hbox.HBMax || hbox.OBBMax)) {
				// HitBox hitted
				if (hbox.TypeFlag == TypeFlag.EXPLOSIVE) {
					(ent as any).ExplodeVehicle()
					return
				}
				// compute health
				hbox.CurHealth = math.Clamp(hbox.CurHealth - damage, 0, hbox.Health)
				if (hbox.Stage == 0) {
					if (hbox.CurHealth < hbox.Health * 0.9) {
						hbox.Stage = 1
						if (hbox.bodygroup) {
							ent.SetBodygroup(hbox.bodygroup, (ent.GetBodygroup(hbox.bodygroup) + 1))
						}
						if (hbox.OnHit) {
							hbox.OnHit(hbox, ent)
						}
						if (physical) {
							hbox.OnPhysicsCollide(hbox, ent, dmginfo_or_data as CollisionData, physobj as PhysObj)
						}
					}
				} else if (hbox.Stage == 1) {
					if (hbox.CurHealth < 1) {
						hbox.Stage = 2
						if (hbox.bodygroup) {
							ent.SetBodygroup(hbox.bodygroup, (ent.GetBodygroup(hbox.bodygroup) + 1))
						}
						if (hbox.OnHit) {
							hbox.OnHit(hbox, ent)
						}
						if (physical) {
							hbox.OnPhysicsCollide(hbox, ent, dmginfo_or_data as CollisionData, physobj as PhysObj)
						}
						if (hbox.TypeFlag == 1) {
							ent.EmitSound("Glass.BulletImpact")
							const effectdata = EffectData()
							effectdata.SetOrigin(ent.LocalToWorld(damagePos))
							util.Effect("shb_glassbreak", effectdata)
						} else {
							if (hbox.GibModel && hbox.GibOffset) {
								const gib = ents.Create("prop_physics")
								gib.SetModel(hbox.GibModel)
								gib.SetPos(ent.LocalToWorld(hbox.GibOffset))
								gib.SetAngles(ent.GetAngles())
								gib.Spawn()
								gib.Activate()
								/*const oldOnDestroyed = ent.OnDestroyed
								ent.OnDestroyed = (ent: HitboxCar) => {
									if (IsValid(ent.Gib)) {
										ent.Gib.DeleteOnRemove(gib)
									}
									oldOnDestroyed(ent)
								}*/
								ent.CallOnRemove("simfphys_hitbox_gib_" + hbox_key, () => {
									if (IsValid((ent as any).Gib)) {
										((ent as any).Gib as Entity).DeleteOnRemove(gib)
									} else
										SafeRemoveEntity(gib)
								});
								gib.SetSkin(ent.GetSkin())
								if (_G.ProxyColor) {
									timer.Simple(0, () => {
										(gib as any).SetProxyColor((ent as any).GetProxyColor());
									})
								}
							}
						}
					}
				}
			}
		}
	}
	export function Init(this: void, ent: HitboxCar, hboxes: HitBox[]) {
		ent.HitBoxes = hboxes

		for (const hbox_key in ent.HitBoxes as table) {
			const hbox = ent.HitBoxes[hbox_key as any]
			hbox.HBMin = hbox.HBMin || hbox.OBBMin
			hbox.HBMax = hbox.HBMax || hbox.OBBMax

			hbox.bodygroup = hbox.BDGroup

			hbox.CurHealth = hbox.Health

			hbox.Stage = 0
			/*
			 * this way of setting default OnPhysicsCollide
			 * will not create new function each time
			 */
			hbox.OnPhysicsCollide = hbox.OnPhysicsCollide || defaultOnCollide
		}

		const oldPhysicsCollide = ent.PhysicsCollide
		ent.PhysicsCollide = function (this: void, ent, data, physobj) {
			if (SHB.IsValidCollideEntity(ent)) {
				const spd = data.Speed + data.OurOldVelocity.Length() + data.TheirOldVelocity.Length()
				const dmgmult = math.Round(spd / 30, 0)
				const damagePos = ent.WorldToLocal(data.HitPos)
				if (data.DeltaTime > 0.2) {
					SHB.TakeDamage(ent, damagePos, dmgmult, true, data, physobj)
				}
			}
			oldPhysicsCollide(ent, data, physobj)
		}
		const oldOnTakeDamage = ent.OnTakeDamage
		ent.OnTakeDamage = function (this: void, ent, dmginfo) {
			SHB.TakeDamage(ent, ent.WorldToLocal(dmginfo.GetDamagePosition()), dmginfo.GetDamage(), false, dmginfo)
			oldOnTakeDamage(ent, dmginfo)
		}

		const oldOnDestoyed = ent.OnDestroyed
		ent.OnDestroyed = (car: HitboxCar) => {
			for (const hbox_key in car.HitBoxes as table) {
				const hbox = car.HitBoxes[hbox_key as any]
				if (hbox.GibModel && hbox.GibOffset && !(hbox.Stage == 2)) {
					const gib = ents.Create("prop_physics")
					gib.SetModel(hbox.GibModel)
					gib.SetPos(car.Gib.LocalToWorld(hbox.GibOffset))
					gib.SetAngles(car.Gib.GetAngles())
					gib.SetColor(car.Gib.GetColor() as Color)
					gib.SetVelocity(car.Gib.GetVelocity())
					gib.Spawn()
					car.Gib.DeleteOnRemove(gib)
					if (_G.ProxyColor) {
						const proxycolor = (ent as any).GetProxyColor()
						timer.Simple(0, () => {
							(gib as any).SetProxyColor(proxycolor);
						})
					}
				}
			}
			oldOnDestoyed(car)
		}

		net.Start("simfphys_hitbox")
		net.WriteEntity(ent)
		net.WriteUInt(table.Count(ent.HitBoxes), 32)
		//net.WriteTable(ent.HitBoxes)
		for (let hbox_key in ent.HitBoxes as table) {
			const hbox = ent.HitBoxes[hbox_key as any]
			PrintTable(hbox)
			if (hbox.HBMin && hbox.HBMax) {
				net.WriteVector(hbox.HBMin)
				net.WriteVector(hbox.HBMax)
			}
		}
		net.Broadcast()
	}
}
// :C
list.Set("FLEX", "HitBoxes", function (this: void, ent: HitboxCar, flex: HitBox[]) {
	SHB.Init(ent, flex)
})

const entMeta = FindMetaTable("Entity")

entMeta.NAKHitboxDmg = function (this: HitboxCar | any) {
	SHB.Init(this, this.NAKHitboxes)
}

// :O

entMeta.NAKSimfEngineStart = ErrorNoHalt
entMeta.NAKSimfSkidSounds = ErrorNoHalt
entMeta.NAKDmgEngineSnd = ErrorNoHalt
entMeta.NAKKillVehicle = ErrorNoHalt
entMeta.NAKSimfFireTime = ErrorNoHalt
entMeta.NAKSimfTickStuff = ErrorNoHalt
entMeta.NAKSimfEMSRadio = ErrorNoHalt
entMeta.NAKSimfTrailer = ErrorNoHalt
entMeta.NAKSimfGTASA = ErrorNoHalt

print("sv_hit")