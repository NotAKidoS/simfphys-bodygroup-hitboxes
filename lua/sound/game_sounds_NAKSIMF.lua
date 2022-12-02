"NAK_GTASA.Fire"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.8"
	"soundlevel"	"SNDLVL_60dB"
	"pitch"			"95, 110"

	"GameData"
	{
		"Priority"	"Interesting"
	}

	"sound"		"gtasa/sfx/fire_loop.wav"
}

"NAK_GTASA.Damage"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.8"
	"soundlevel"	"SNDLVL_60dB"
	"pitch"			"95, 110"

	"GameData"
	{
		"Priority"	"Interesting"
	}

	"rnddmg"
	{
		"dmg"	"gtasa/sfx/damage_hvy1.wav"
		"dmg"	"gtasa/sfx/damage_hvy2.wav"
		"dmg"	"gtasa/sfx/damage_hvy3.wav"
		"dmg"	"gtasa/sfx/damage_hvy4.wav"
		"dmg"	"gtasa/sfx/damage_hvy5.wav"
		"dmg"	"gtasa/sfx/damage_hvy6.wav"
		"dmg"	"gtasa/sfx/damage_hvy7.wav"
	}
}

"NAK_GTASA.Explosion"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1"
	"soundlevel"	"SNDLVL_115dB"
	"pitch"			"95, 100"

	"GameData"
	{
		"Priority"	"Interesting"
	}

	"rndwave"
	{
		"wave"	"gtasa/sfx/explo_detail_1.wav"
		"wave"	"gtasa/sfx/explo_detail_2.wav"
	}
}