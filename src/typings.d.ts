declare const _G: any

declare type HitBoxStage = {
	
}

declare type HitBox = {
	HBMin: Vector
	HBMax: Vector

	OBBMin: Vector
	OBBMax: Vector

	TypeFlag: TypeFlag

	CurHealth: number
	Health: number

	BDGroup: number
	Bodygroup: number

	Stage: number

	Stages: HitBoxStage[]

	GibOffset: Vector
	GibModel: string

	Gib: Entity

	nakstyle: boolean

	OnHit: (this: void, hbox: HitBox, ent: Entity) => void
	OnRepair: (this: void, hbox: HitBox, ent: Entity) => void
	OnPhysicsCollide: (this: void, hbox: HitBox, ent: HitboxCar, data: CollisionData, physobj: PhysObj) => void

	OnDestroyed: (this: void, ent: HitboxCar, hbox: HitBox) => void;
}
const enum TypeFlag {
	NONE = 0,
	GLASS = 1,
	EXPLOSIVE = 2
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
	Gib: Entity
}
type HitboxCar = Entity & HitBoxes & MissingMethods
