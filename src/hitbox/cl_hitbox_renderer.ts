net.Receive("simfphys_hitbox", (len:number) => {
	const ent = net.ReadEntity() as any
	if (IsValid(ent)) {
		ent.HitBoxes = {}
		//ent.HitBoxes = net.ReadTable()
		const hboxcount = net.ReadUInt(32)
		print("count is ", hboxcount, "len is", len)
		for (let i = 0; i < hboxcount; i++) {
			let vec1 = net.ReadVector()
			let vec2 = net.ReadVector()

			if (isvector(vec1) && isvector(vec2)) {
				table.insert(ent.HitBoxes, { HBMin: vec1, HBMax: vec2 })
			} else {
			}
		}
		PrintTable(ent.HitBoxes)
	}
})
function HitboxRenderer(this: void) {
	const shb_hitbox_filled = CreateConVar("shb_filled", "0", FCVAR.FCVAR_ARCHIVE | FCVAR.FCVAR_ARCHIVE_XBOX, "Filled hitboxes?", 0, 1).GetBool()
	const shb_hitbox_wire = CreateConVar("shb_wire", "0", FCVAR.FCVAR_ARCHIVE | FCVAR.FCVAR_ARCHIVE_XBOX, "Wireframe hitboxes?", 0, 1).GetBool()
	const colorvector = util.StringToType(CreateConVar("shb_color", "255 255 255", FCVAR.FCVAR_ARCHIVE | FCVAR.FCVAR_ARCHIVE_XBOX, "Set a color for the box AS A STRING '255,255,255'").GetString(), "Vector")
	const alpha = CreateConVar("shb_alpha", "100", FCVAR.FCVAR_ARCHIVE | FCVAR.FCVAR_ARCHIVE_XBOX, "Set the alpha of the hitbox", 0, 255).GetFloat()
	const color = Color(colorvector.x, colorvector.y, colorvector.z, alpha) as Color
	hook.Remove("PostDrawTranslucentRenderables", "simfphys_hitbox")
	hook.Remove("PostDrawOpaqueRenderables", "simfphys_hitbox")
	if (shb_hitbox_filled) {
		hook.Add("PostDrawTranslucentRenderables", "simfphys_hitbox", () => {
			render.SetColorMaterial();
			(ents.FindByClass("gmod_sent_vehicle_fphysics_base") as HitboxCar[]).forEach((car: HitboxCar) => {
				if (car.HitBoxes) {
					const pos = car.GetPos()
					const angles = car.GetAngles()
					for (const hbox_key in car.HitBoxes as table) {
						const hbox = car.HitBoxes[hbox_key as any]
						render.DrawBox(pos, angles, hbox.HBMin, hbox.HBMax, color)
					}
				}
			})
		})
	}
	if (shb_hitbox_wire) {
		hook.Add("PostDrawOpaqueRenderables", "simfphys_hitbox", () => {
			render.SetColorMaterial();
			(ents.FindByClass("gmod_sent_vehicle_fphysics_base") as HitboxCar[]).forEach((car: HitboxCar) => {
				if (car.HitBoxes) {
					const pos = car.GetPos()
					const angles = car.GetAngles()
					for (const hbox_key in car.HitBoxes as table) {
						const hbox = car.HitBoxes[hbox_key as any]
						render.DrawWireframeBox(pos, angles, hbox.HBMin, hbox.HBMax, color, true)
					}
				}
			})
		})
	}
}

HitboxRenderer()

cvars.AddChangeCallback("shb_filled", HitboxRenderer)
cvars.AddChangeCallback("shb_wire", HitboxRenderer)
cvars.AddChangeCallback("shb_color", HitboxRenderer)
cvars.AddChangeCallback("shb_alpha", HitboxRenderer)
