--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

-- NPC Nodes --
Quantum.Node.Create( "generalvendor", {
	name = "General Goods Vendor",
	model = "models/kleiner.mdl",
	type = Quantum.NodeType.npc,

	voiceLines = {
		"vo/coast/odessa/nlo_cub_hello.wav",
		"vo/coast/odessa/male01/nlo_citizen_greet01.wav",
		"vo/coast/odessa/male01/nlo_citizen_greet02.wav",
		"vo/coast/odessa/male01/nlo_citizen_greet03.wav",
		"vo/coast/odessa/male01/nlo_citizen_greet04.wav"
	},

	damageSounds = {
		"vo/npc/male01/ow01.wav",
		"vo/npc/male01/ow02.wav",
		"vo/npc/male01/pain01.wav",
		"vo/npc/male01/pain02.wav",
		"vo/npc/male01/pain03.wav",
		"vo/npc/male01/pain04.wav",
		"vo/npc/male01/pain05.wav",
		"vo/npc/male01/pain06.wav",
		"vo/npc/male01/pain07.wav",
		"vo/npc/male01/pain08.wav",
		"vo/npc/male01/pain09.wav"
	},
} ) 

-- Resource Nodes --
local miningTools = { "tool_pickaxe" }

Quantum.Node.Create( "stone", {
	type = Quantum.NodeType.resource,
	canGather = true,
	name = "Stone",
	model = "models/props/cs_militia/militiarock05.mdl",
	toolids = miningTools,
	give = {
		{ item = "rock", amount = 1 },
		{ item = "rock", amount = 2 }
	},
	giveprobability = 1/2,
	health = 20,
	respawn = 10
} ) 

Quantum.Node.Create( "bigstone", {
	type = Quantum.NodeType.resource,
	canGather = true,
	name = "Big Stone",
	model = "models/props/cs_militia/militiarock03.mdl",
	toolids = miningTools,
	give = {
		{ item = "rock", amount = 1 },
		{ item = "rock", amount = 2 }
	},
	giveprobability = 3/4,
	health = 20,
	respawn = 10
} ) 