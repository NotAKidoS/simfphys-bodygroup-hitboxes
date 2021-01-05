declare const _G: any

declare type HitBox = {
	HBMin: Vector
	HBMax: Vector

	OBBMin: Vector
	OBBMax: Vector

	TypeFlag: number

	CurHealth: number
	Health: number

	BDGroup: number
	bodygroup: number

	Stage: number

	GibOffset: Vector
	GibModel: string

	Gib: Entity

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
	GetFuel: (this: HitboxCar) => number
	Gib: Entity
}
type HitboxCar = Entity & HitBoxes & MissingMethods
