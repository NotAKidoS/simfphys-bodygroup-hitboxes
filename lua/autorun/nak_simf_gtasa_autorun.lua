--[[
	 _            _  _          _    _
	| |__    ___ | || |  ___   | |_ | |__    ___  _ __  ___
	| '_ \  / _ \| || | / _ \  | __|| '_ \  / _ \| '__|/ _ \
	| | | ||  __/| || || (_) | | |_ | | | ||  __/| |  |  __/
	|_| |_| \___||_||_| \___/   \__||_| |_| \___||_|   \___|

	This base code is written by NotAKid (on steam). Prolly bad ik.

	Please do not redistribute this base code in your addons, contact me first.
	You probably don't want code written by a 16 year old with a smol brain anyways lol.

	Contact:
		NotAKid - Steam
		NotAKidoS#0792 - Discord 

	GitHub:
		https://github.com/NotAKidOnSteam/simfphys-bodygroup-hitboxes

	Disclaimer:
		This is by a kid with little knowledge on the Do's and Don'ts of GLUA, so please do not expect anything to be proper.
		I am at least trying to learn :>

		This addon heavily relies on being able to override functions on Simfphys vehicles when spawned. I can make it not need to override functions
		directly by adding them in the vehicles spawnlists, which may be better to do anyways, but for the sake of saving time and making things
		easy on Randy (the person that asked for the damage script) I have made it so the base will automatically do that once the vehicle is spawned.

	That is all, thank you for reading. -NotAKidoS													(i like writing blobs of text no one reads)
--]]


--//Loads all the base code, seperated like this to make things easy to read I guess...?
local loadfile = 'notakid/gtasa/init.lua'

AddCSLuaFile(loadfile)
include(loadfile)

--//Loads the hitbox damage script, added possibility for me to disable it later on outside the addon too.

NAKHBDVersion = NAKHBDVersion or 1

if NAKHBDVersion > 1 then return end

local loadfile = 'notakid/hitbox_damage_script.lua'

AddCSLuaFile(loadfile)
include(loadfile)

