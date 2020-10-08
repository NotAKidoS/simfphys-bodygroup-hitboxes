# For Developers

# Adding Support to vehicle

you need to append vehicle's spawnlist

you need add

```lua
FLEX = {
	Trailers = {
		
	}
}
```
should look like
```lua
list.Set("simfphys_vehicles", "myvehicle", {
	Name = "My Car",
	Model = "models/path/to/model.mdl",
	Category = "My Category",
	SpawnOffset = Vector(0,0,0),
	SpawnAngleOffset = 0,
	FLEX = {
		Trailers = {
			-- #goto FLEX.Trailers params
		}
	},
	Members = {
		OnSpawn = function(ent)
			-- if you making trailer
			-- you need `ent:Lock()` here
		end,
		-- car configuration stuff here
	}
})
```

# FLEX.Trailers params

`inputPos`: Vector - input position of trailer/dolly

`inputType`: string | any - type of input ([ConnectionTypes](#ConnectionTypes))

`outputPos`: Vector - output position of truck/dolly

`outputType`: string | any - type of output ([ConnectionTypes](#ConnectionTypes))

# ConnectionTypes

**NOTE**: types can be of any type // more detailed info

`"axis"` for 

![pic](https://moscowteslaclub.ru/upload/resize_cache/iblock/7e3/1266_715_2/7e3c6ca47f35796b90b4cf44cbaa3c4e.jpg)

`"ballsocket"` for

![pic](https://hips.hearstapps.com/pop.h-cdn.co/assets/16/38/980x652/gallery-1474470091-pmx100116-utilitytrailers07.jpg?resize=480:*)

# Low Level API

## `Trailers.Init(ventitytable)`
Can be used to directly initializate trailer support,

it requires a table, exactly like [FLEX.Trailers params](#flextrailers-params), **BUT** with `ent` key, equal to target simfphys vehicle

# Systems

rules are:
* they should be in `lua/tr/systems`
* they should return a table object
* they can have [these methods](https://github.com/SupinePandora43/Trailers-Reborn/blob/b29960c47048b1543b94fa138a1aa3efbfea7af4/src/typings.d.ts#L29-L34)

## Functions

most of them doesn't require additional help, but anyways

### `HandleTruck`([`ventity: VEntity`](https://github.com/SupinePandora43/Trailers-Reborn/blob/b29960c47048b1543b94fa138a1aa3efbfea7af4/src/typings.d.ts#L9))

ventity - equals to `truckSpawnlist.FLEX.Trailers`, except it has `ent` entry reffering to entity, and [`connection`](https://github.com/SupinePandora43/Trailers-Reborn/blob/abfbd6264efd5150d1fb7842707753f8e4a65abd/src/typings.d.ts#L2)

### `Disconnect`([`ventity: VEntity`](https://github.com/SupinePandora43/Trailers-Reborn/blob/b29960c47048b1543b94fa138a1aa3efbfea7af4/src/typings.d.ts#L9))
ventity - equals to `truckSpawnlist.FLEX.Trailers`, except it has `ent` entry reffering to entity, and [`connection`](https://github.com/SupinePandora43/Trailers-Reborn/blob/abfbd6264efd5150d1fb7842707753f8e4a65abd/src/typings.d.ts#L2)

**Called before it get disconnected.**
BUT DON't called when trailer get removed etc...

```lua
local disconnecting_truck = ventity.ent
local disconnecting_trailer = ventity.connection.ent
```

## Examples

* [Base](https://github.com/SupinePandora43/Trailers-Reborn/blob/master/lua/TR/systems/base.lua) handles lights, turnlights, brakes...
* [NAKbaggageBoxSteer](https://github.com/NotAKidOnSteam/simfphys-bodygroup-hitboxes/blob/newer/lua/tr/systems/nak_baggagebox_steer.lua) steers nak's trailer for easier trailer movement

```lua
-- lua/tr/systems/example.lua
return {
	HandleTruck = function(ventity)
		print("Truck is "..ventity.ent)
		if ventity.connection then
			print("Trailer is "..ventity.connection.ent)
		end
	end,
	Disconnect = function(ventity)
		print("You're disconnecting trailer ("..ventity.connection.ent.."), from truck ("..ventity.ent..")")
	end
}
```
