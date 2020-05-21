--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

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