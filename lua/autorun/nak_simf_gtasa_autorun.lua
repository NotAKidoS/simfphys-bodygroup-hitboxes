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
		This addon heavily relies on being able to override functions on Simfphys vehicles when spawned. May one day
		cause issues if Simfphys ever has a major update.

	That is all, thank you for reading. -NotAKidoS
--]]
local function loadshared(loadfile)
	AddCSLuaFile(loadfile)
	include(loadfile)
end
loadshared('notakid/gtasa/init.lua')
loadshared('notakid/hitboxes/init.lua')