--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

			Quantum.Server.Settings = {}

Quantum.Server.Settings.DeveloperMode = false

Quantum.Server.Settings.VoiceChatRange = 400

Quantum.Server.Settings.MaxHealth = 100

Quantum.Server.Settings.StarterMoney = 0

Quantum.Server.Settings.ItemDespawnTimer = 300

Quantum.Server.Settings.ItemPickupSound = "physics/cardboard/cardboard_box_impact_hard2.wav"

Quantum.Server.Settings.ItemsGatheredSpawnInWorld = true

Quantum.Server.Settings.InitSpawnLocation = { 
	pos = Vector( 2734.0334472656, 5066.060546875, 63.850269317627 ),
	ang = Angle( 3.2735850811005, -173.51545715332, 0 )
}

Quantum.Server.Settings.SpawnLocations = {

	["rp_truenorth_v1a_livin"] = {
		["Hospital"] = { pos = Vector( 13526.426758, 13088.842773, 125.031250 ), ang = Angle( 1, -115, 0 ) },
		
		["Lake"] = { pos = Vector( 10812, -8319, 5382 ), ang = Angle( 5, -40, 0 ) }
	},

	["rp_dunwood_eu"] = {
		["Hospital"] = { pos = Vector( -5102.2807617188, 10812.857421875, 256.03125 ), ang = Angle( 0, 40.045780181885, 0 ) }, 
		
		["Graveyard"] = { pos = Vector( 6220.7700195313, -12982.192382813, 248 ), ang = Angle( 0, -136.18241882324, 0 ) }
	},

	["RP_SouthSide"] = {
		["Hospital"] = { pos = Vector( 7586.4912109375, 5226.1508789063, 7.6475238800049 ), ang = Angle( 0, -127.80423736572, 0 ) }
	}

}

Quantum.Server.Settings.PlayerSpeeds = {
	walk = 180,
	run = 280,
	duck = 50
}

Quantum.Server.Settings.DamageScale = { -- The scale of the damage for each hitgroup 
	[HITGROUP_HEAD] = 10,
	[HITGROUP_CHEST] = 4,
	[HITGROUP_STOMACH] = 2,
	[HITGROUP_LEFTARM] = 1,
	[HITGROUP_RIGHTARM] = 1,
	[HITGROUP_LEFTLEG] = 1,
	[HITGROUP_RIGHTLEG] = 1
}

Quantum.Server.Settings.BotChars = {
	civ1 = {
		name = "John Doe",
		gender = "Male"
	},
	civ2 = {
		name = "Jane Doe",
		gender = "Female"
	}
}

Quantum.Server.Settings.PainSounds = {}
Quantum.Server.Settings.PainSounds.Male = {
	"vo/npc/male01/pain01.wav",
	"vo/npc/male01/pain02.wav",
	"vo/npc/male01/pain03.wav",
	"vo/npc/male01/pain04.wav",
	"vo/npc/male01/pain05.wav",
	"vo/npc/male01/pain06.wav",
	"vo/npc/male01/pain07.wav",
	"vo/npc/male01/pain08.wav",
	"vo/npc/male01/pain09.wav"
}

Quantum.Server.Settings.PainSounds.Female = {
	"vo/npc/female01/pain01.wav",
	"vo/npc/female01/pain02.wav",
	"vo/npc/female01/pain03.wav",
	"vo/npc/female01/pain04.wav",
	"vo/npc/female01/pain05.wav",
	"vo/npc/female01/pain06.wav",
	"vo/npc/female01/pain07.wav",
	"vo/npc/female01/pain08.wav",
	"vo/npc/female01/pain09.wav"
}

Quantum.Server.Settings.DamageHurtSoundRepeatChance = 90 -- %

Quantum.Server.Settings.IdlePainSounds = {}
Quantum.Server.Settings.IdlePainSounds.Male = {
	"vo/npc/male01/moan01.wav",
	"vo/npc/male01/moan02.wav",
	"vo/npc/male01/moan03.wav",
	"vo/npc/male01/moan04.wav",
	"vo/npc/male01/moan05.wav"
}

Quantum.Server.Settings.IdlePainSounds.Female = {
	"vo/npc/female01/moan01.wav",
	"vo/npc/female01/moan02.wav",
	"vo/npc/female01/moan03.wav",
	"vo/npc/female01/moan04.wav",
	"vo/npc/female01/moan05.wav"
}

--- Features to be added ---
Quantum.Server.Settings.MaxJobLevel = 250
Quantum.Server.Settings.MaxJobSlots = 2

Quantum.Server.Settings.MaxSkillLevel = 100



Quantum.Server.Settings.Licenses = {
	Driving = { title = "Driving License", desc = "This permits you to operate and pilot any motorized vehicle in a public area.", cost = 1000 }
}

Quantum.Server.Settings.Titles = {
	dev = "Developer,"
}