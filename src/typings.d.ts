declare const _G: any
declare type HitBoxStage = {
	Damage?: number = 0
	/** Bodygroups to change */
	Bodygroups?: table
	/** Explode vehicle when stage selected */
	Explode?: boolean
	/** Emit Glass break particle and sound when stage selected */
	GlassBreakFX?: boolean
	/** Gib */
	Gib?: {
		/** Gib Model */
		Model: string
		/** Gib Position Offset */
		PositionOffset?: Vector
		/** @todo Gib Angle Offset */
		AngleOffset?: Angle
	}
	OnSelected?: (this: HitBoxStage, ent: HitboxCar, hbox: HitBox) => void
	OnDeselected?: (this: HitBoxStage, ent: HitboxCar, hbox: HitBox) => void
}

declare type HitBox = {
	HBMin: Vector
	HBMax: Vector

	Damage: number

	Stage: number

	Stages: HitBoxStage[]

	/** TODO: make Gib a HitBoxStage's?*/
	Gib: Entity

	OnHit?: (this: void, hbox: HitBox, ent: Entity, dmginfo: CTakeDamageInfo) => void
	OnRepair?: (this: void, hbox: HitBox, ent: Entity) => void
	OnPhysicsCollide?: (this: void, hbox: HitBox, ent: HitboxCar, data: CollisionData, physobj: PhysObj) => void
	/** function - callback, number - stage to run */
	OnDestroyed: (this: void, ent: HitboxCar, hbox: HitBox) => void | number;

	/** nak stuff */
	nak: boolean = false

	/** @deprecated */
	CurHealth?: number
	/** @deprecated */
	Health?: number

	/** @deprecated */
	GibOffset?: Vector
	/** @deprecated */
	GibModel?: string

	/** @deprecated */
	OBBMin?: Vector
	/** @deprecated */
	OBBMax?: Vector

	/** @deprecated */
	TypeFlag?: TypeFlag
	/** @deprecated */
	BDGroup?: number
}
declare interface HitBoxes {
	HitBoxes: HitBox[]
}
declare type MissingMethods = {
	PhysicsCollide: (this: void, ent: HitboxCar, data: CollisionData, physobj: PhysObj) => void
	OnTakeDamage: (this: void, ent: HitboxCar, info: CTakeDamageInfo) => void
	OnDestroyed: (this: void, ent: HitboxCar) => void
	OnRepaired: (this: void, ent: HitboxCar) => void
	GetFuel: (this: HitboxCar) => number
	Wheels: HitboxCar[]
	SetDamaged: (this: void, ent: HitboxCar, value: boolean) => void
	ExplodeVehicle: (this: HitboxCar) => void
	Gib: Entity
}
type HitboxCar = Entity & HitBoxes & MissingMethods
