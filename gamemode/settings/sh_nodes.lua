--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

local miningTools = { "tool_pickaxe" }

Quantum.Node.Create( "stone", {
	name = "Stone",
	model = "models/props/cs_militia/militiarock05.mdl",
	toolids = miningTools,
	give = {
		{ item = "test2", amount = 1 }
	},
	giveprobability = 1/2,
	health = 20,
	respawn = 10
} ) 

Quantum.Node.Create( "bigstone", {
	name = "Big Stone",
	model = "models/props/cs_militia/militiarock03.mdl",
	toolids = miningTools,
	give = {
		{ item = "test2", amount = 1 }
	},
	giveprobability = 3/4,
	health = 20,
	respawn = 10
} ) 