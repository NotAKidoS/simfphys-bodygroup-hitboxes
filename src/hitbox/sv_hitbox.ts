function defaultOnCollide(this: void, hbox: HitBox, ent: HitboxCar, data: CollisionData, physobj: PhysObj) {
	if (data.Speed > 50 && data.DeltaTime > 0.8) {
		// @todo use sound.Play
		ent.EmitSound("gtasa/sfx/damage_hvy" + math.random(1, 7) + ".wav")
	}
}

//#region ConVars

let shb_debug: boolean
function shb_debug_update(this: void) {
	shb_debug = CreateConVar("shb_debug", "1", FCVAR.FCVAR_ARCHIVE, "send hitboxes to clients", 0, 1).GetBool()
}
shb_debug_update()
cvars.AddChangeCallback("shb_debug", () => {
	shb_debug_update()
})

let shb_rgar: boolean
function shb_rgar_update(this: void) {
	shb_rgar = CreateConVar("shb_rgar", "0", FCVAR.FCVAR_ARCHIVE, "Remove gibs after repair?", 0, 1).GetBool()
}
shb_rgar_update()
cvars.AddChangeCallback("shb_rgar", () => {
	shb_rgar_update()
})

//@todo: better configuration

let shb_gibs: boolean
function shb_gibs_update(this: void) {
	shb_gibs = CreateConVar("shb_gibs", "1", FCVAR.FCVAR_ARCHIVE, "enable gibs?", 0, 1).GetBool()
}
shb_gibs_update()
cvars.AddChangeCallback("shb_gibs", () => {
	shb_gibs_update()
})

let shb_gibsondestroy: boolean
function shb_gibsondestroy_update(this: void) {
	shb_gibsondestroy = CreateConVar("shb_gibsondestroy", "1", FCVAR.FCVAR_ARCHIVE, "Execute last stage on destroy?", 0, 1).GetBool()
}
shb_gibsondestroy_update()
cvars.AddChangeCallback("shb_gibsondestroy", () => {
	shb_gibsondestroy_update()
})

//#endregion

export namespace SHB {
	/** @deprecated */
	export enum TypeFlag {
		NONE = 0,
		GLASS = 1,
		EXPLOSIVE = 2
	}
	export function IsValidCollideEntity(this: void, ent: Entity) {
		return true//(!ent.IsNPC) && (!ent.IsPlayer()) && (!(ent as any).IsNextBot())
	}
	export function ChangeStage(this: void, ent: HitboxCar, hbox: HitBox, stage: number, damagePos?: Vector, destroyed?: boolean) {
		if (hbox.Stage != stage) {
			if (hbox.Stage != null) {
				const oldStage = hbox.Stages[hbox.Stage]
				if (typeof (oldStage.OnDeselected) == "function") {
					oldStage.OnDeselected(ent, hbox)
				}
			}
			hbox.Stage = stage
			const newStage = hbox.Stages[stage]
			if (typeof (newStage.OnSelected) == "function") {
				newStage.OnSelected(ent, hbox)
			}
			if (
				istable(newStage.Bodygroups)
				&& (destroyed == true ? shb_gibsondestroy : true)
			) {
				for (const bodygroupkey in newStage.Bodygroups) {
					if (typeof (bodygroupkey) == "number") {
						ent.SetBodygroup(bodygroupkey, newStage.Bodygroups[bodygroupkey])
						/*if (IsValid(ent.Gib)) {
							ent.Gib.SetBodygroup(bodygroupkey, newStage.Bodygroups[bodygroupkey])
						}*/
					} else if (typeof (bodygroupkey) == "string") {
						ent.SetBodygroup(ent.FindBodygroupByName(bodygroupkey), newStage.Bodygroups[bodygroupkey])
					} else {
						error("SHB: unknown type of bodygroupkey")
					}
				}
			}
			if (newStage.Gib && shb_gibs) {
				if (destroyed == true ? shb_gibsondestroy : true) {
					const gib = ents.Create("prop_physics")
					const parent = destroyed == true ? IsValid(ent.Gib) ? ent.Gib : ent : ent
					gib.SetModel(newStage.Gib.Model)
					gib.SetPos(newStage.Gib.PositionOffset ? parent.LocalToWorld(newStage.Gib.PositionOffset) : ent.GetPos())
					gib.SetAngles(parent.GetAngles())
					gib.SetSkin(parent.GetSkin())
					gib.SetVelocity(parent.GetVelocity())
					gib.Spawn()
					gib.Activate()
					if (destroyed == true && IsValid(ent.Gib)) {
						ent.Gib.DeleteOnRemove(gib)
					} else {
						ent.CallOnRemove("simfphys_hitbox_gib_" + tostring(hbox), () => {
							if (IsValid((ent as any).Gib) && IsValid(gib)) {
								((ent as any).Gib as Entity).DeleteOnRemove(gib)
							} else
								SafeRemoveEntity(gib)
						});
					}
					// @todo: provide way to extend simfphys hitbox functionality
					if (_G.ProxyColor) {
						const proxycolor = (ent as any).GetProxyColor()
						timer.Simple(0, () => {
							(gib as any).SetProxyColor(proxycolor);
						})
					}
					newStage.Gib.Entity = gib
				}
			}
			if (newStage.GlassBreakFX && damagePos) {
				const damagePosWorld = ent.LocalToWorld(damagePos)
				sound.Play("Glass.BulletImpact", damagePosWorld, 75, 100, 1)
				const effectdata = EffectData()
				effectdata.SetOrigin(damagePosWorld)
				util.Effect("shb_glassbreak", effectdata)
			}
			// kaboom?
			if (newStage.Explode && !destroyed) {
				// yes Ricko, kaboom!
				ent.ExplodeVehicle()
			}
		}
	}
	export function TakeDamage(this: void, ent: HitboxCar, damagePos: Vector, damage: number, physical: boolean, dmginfo_or_data: CTakeDamageInfo | CollisionData, physobj?: PhysObj) {
		if (!ent.HitBoxes) error("SHB: why you trying to manage hitboxes on car without it?")
		for (const hbox_key in ent.HitBoxes as table) {
			const hbox = ent.HitBoxes[hbox_key as any]
			if (damagePos.WithinAABox(hbox.HBMin, hbox.HBMax)) {

				if (physical && typeof (hbox.OnPhysicsCollide) == "function") {
					hbox.OnPhysicsCollide(hbox, ent, dmginfo_or_data as CollisionData, physobj as PhysObj)
				} else if (typeof (hbox.OnHit) == "function") {
					hbox.OnHit(hbox, ent, dmginfo_or_data as CTakeDamageInfo)
				}

				const currentStageNum = hbox.Stage
				hbox.Damage += damage

				// only one stage switch at a time
				if (true) {
					const newStageNum = currentStageNum + 1
					const newStage = hbox.Stages[newStageNum]

					if (newStage) {
						if ((newStage.Damage && newStage.Damage <= hbox.Damage) || !newStage.Damage) {
							SHB.ChangeStage(ent, hbox, newStageNum, damagePos)
						}
					}
				}
			}
		}
	}
	export function OnRepair(this: void, ent: HitboxCar) {
		if (!IsValid(ent)) return
		if (!ent.HitBoxes) return
		const hboxes = ent.HitBoxes

		for (const hbox_key in hboxes as table) {
			const hbox = hboxes[hbox_key as any]
			// Check if hitbox isn't damaged
			if (hbox.Stage > 0) {
				SHB.ChangeStage(ent, hbox, 0)
			}
			hbox.Damage = 0
			if (typeof (hbox.OnRepair) == "function") {
				hbox.OnRepair(hbox, ent)
			}
			for (const stage of hbox.Stages) {
				if (stage.Gib) {
					if (shb_rgar)
						if (stage.Gib.Entity)
							SafeRemoveEntity(stage.Gib.Entity)
					stage.Gib.Entity = undefined
				}
			}
		}
	}
	export function Init(this: void, ent: HitboxCar, hboxes: HitBox[]) {
		print("Initializing hitboxes")

		ent.HitBoxes = hboxes

		for (const hbox_key in ent.HitBoxes as table) {
			const hbox = ent.HitBoxes[hbox_key as any]

			// NotAKid's original code supports only 3 stage hitbox
			// to not rewrite all spawnlist, this code wraps original OBBMin && OBBMax && BDGroup

			if (hbox.OBBMin && hbox.OBBMax) {
				hbox.HBMax = hbox.OBBMax
				hbox.HBMin = hbox.OBBMin
				switch (hbox.TypeFlag) {
					/**@todo allow nil stage values? */
					case TypeFlag.GLASS:
						hbox.Stages = [
							{
								Bodygroups: (hbox.BDGroup ? {
									[hbox.BDGroup]: 0
								} : undefined)
							},
							{
								GlassBreakFX: true,
								Damage: hbox.Health ? hbox.Health * 0.1 : 0,
								Bodygroups: (hbox.BDGroup ? {
									[hbox.BDGroup]: 1
								} : undefined)
							}
						]
						if (hbox.BDGroup) {
							hbox.Stages[2] = {
								GlassBreakFX: true,
								Damage: hbox.Health ? hbox.Health : 0,
								Bodygroups: (hbox.BDGroup ? {
									[hbox.BDGroup]: 2
								} : undefined)
							}
						}
						break
					case TypeFlag.EXPLOSIVE:
						hbox.Stages = [
							{},
							{
								Explode: true
							}
						]
						break
					case TypeFlag.NONE:
					default:
						if (hbox.BDGroup) {
							hbox.Stages = [
								{
									Bodygroups: {
										[hbox.BDGroup]: 0
									}
								},
								{
									Bodygroups: {
										[hbox.BDGroup]: 1
									},
									Damage: hbox.Health ? hbox.Health * 0.1 : 0
								},
								{
									Bodygroups: {
										[hbox.BDGroup]: 2
									},
									Damage: hbox.Health ? hbox.Health : 0,
									Gib: {
										Model: hbox.GibModel as string,
										PositionOffset: hbox.GibOffset
									}
								}
							]
						}
						break
				}
				hbox.nak = true
			}
			hbox.CurHealth = hbox.Health
			hbox.Damage = 0

			// optimization: Precache gib models and sounds
			for (const stage_key in hbox.Stages as table) {
				const stage = (hbox.Stages as table)[stage_key]
				if (stage.Gib && stage.Gib.Model) {
					util.PrecacheModel(stage.Gib.Model)
				}
				if (stage.GlassBreakFX) {
					util.PrecacheSound("Glass.BulletImpact")
				}
			}

			SHB.ChangeStage(ent, hbox, 0)
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
				if (data.DeltaTime > 0.2) { // TODO: what is this for?
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
				switch (typeof (hbox.OnDestroyed)) {
					case "function":
						ChangeStage(car, hbox, hbox.Stages.length - 1, undefined, true)
						hbox.OnDestroyed(car, hbox)
						break
					case "number":
						ChangeStage(car, hbox, hbox.OnDestroyed, undefined, true)
						break
					default:
						ChangeStage(car, hbox, hbox.Stages.length - 1, undefined, true)
						break
				}
			}
			if (IsValid(ent.Gib))
				for (let i = 0; i < ent.GetNumBodyGroups(); i++) {
					ent.Gib.SetBodygroup(i, ent.GetBodygroup(i))
				}
			oldOnDestoyed(car)
		}
		//#region OnRepaired
		if (ent.OnRepaired) {
			const oldOnRepaired = ent.OnRepaired
			ent.OnRepaired = (car: HitboxCar) => {
				OnRepair(car)
				oldOnRepaired(car)
			}
		} else {
			// simfphys workaround
			// if luna still didn't updated simfphys
			timer.Simple(1, () => {
				if (IsValid(ent)) {
					if (istable(ent.Wheels)) {
						const wheel = ent.Wheels[0]
						if (IsValid(wheel)) { // so many checks lol
							const oldSetDamaged = wheel.SetDamaged
							wheel.SetDamaged = (wheel, value) => {
								if (!value) {
									OnRepair(ent)
								}
								oldSetDamaged(wheel, value)
							}
						}
					}
				}
			})
		}
		//#endregion
		if (shb_debug) {
			net.Start("simfphys_hitbox")
			net.WriteEntity(ent)
			net.WriteUInt(table.Count(ent.HitBoxes), 32)
			for (let hbox_key in ent.HitBoxes as table) {
				const hbox = ent.HitBoxes[hbox_key as any]
				if (hbox.HBMin && hbox.HBMax) {
					net.WriteVector(hbox.HBMin)
					net.WriteVector(hbox.HBMax)
				}
			}
			net.Broadcast()
		}
	}
}

_G.SHB = SHB

// :C
list.Set("FLEX", "HitBoxes", function (this: void, ent: HitboxCar, flex: HitBox[]) {
	SHB.Init(ent, flex)
})

const entMeta = FindMetaTable("Entity")

entMeta.NAKHitboxDmg = function (this: HitboxCar | any) {
	SHB.Init(this, this.NAKHitboxes)
}

// :(

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
