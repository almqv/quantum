--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

GM.Name = "Quantum Framework"
GM.Author = "AlmTech"
GM.Email = "elias@almtech.se"
GM.Website = "N/A"

Quantum = {}
Quantum.Version = "v0.3-alpha"

Quantum.EmptyFunction = function() end

include( "engine/sh_debug.lua" ) -- add the debug functions and stuff

include( "settings/sh_settings.lua" )


Quantum.IntCode = {
	SET_ITEM = 0,
	DROP_ITEM = 1,
	USE_ITEM = 2,
	EAT_ITEM = 3,
	EQUIP_ITEM = 4,
	DESTROY_ITEM = 5,
	UPDATE = 6,
	BIT_SIZE = 3
}

function Quantum.calculateNeededBits( n ) return math.ceil( math.log( n, 2 ) ) end

function Quantum.WriteIntcode( intcode ) net.WriteInt( intcode, Quantum.IntCode.BIT_SIZE ) end