--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

Quantum.ItemInfoDisplayMaxDistance = 200

Quantum.CharInfoDisplayDistance = 400

---- Item Variables ----

Quantum.Rarity = {
	None = { txt = "gnomerd the mvp", color = Color( 0, 0, 0, 120 ) },
	Trash = { txt = "Trash", color = Color( 120, 120, 120, 40 ) },
	Common = { txt = "Common", color = Color( 150, 150, 150, 40 ) },
	Rare = { txt = "Rare", color = Color( 48, 163, 230, 40 ) },
	Epic = { txt = "Epic", color = Color( 220, 90, 90, 40 ) },
	Legendary = { txt = "Legendary", color = Color( 235, 125, 52, 40 ) },
	Weapon = { txt = "Weapon", color = Color( 220, 90, 90, 40 ) }
}

Quantum.EquipSlots = {
	Head = 0,
	Chest = 1,
	Legs = 2,
	Boots = 3,
	Weapon = 4
}

---- Placeholders ----

Quantum.EmptyFunction = function() end

---- NETWORKING VARS DO NOT TOUCH ----

Quantum.IntCode = {
	SET_ITEM = 0, 
	DROP_ITEM = 1,
	USE_ITEM = 2,
	EAT_ITEM = 3,
	EQUIP_ITEM = 4,
	UNEQUIP_ITEM = 5,
	DESTROY_ITEM = 6, -- to be added
	UPDATE = 7,
	CRAFT_RECIPE = 8,
	BIT_SIZE = 5
}

function Quantum.calculateNeededBits( n ) return math.ceil( math.log( n, 2 ) ) end

function Quantum.WriteIntcode( intcode ) 
	net.WriteInt( intcode, Quantum.IntCode.BIT_SIZE ) 
end

function Quantum.PrintPlayer( pl )
	return "[" .. pl:Nick() .. "|" .. pl:SteamID() .. "]"
end

---- Node vars ----
Quantum.NodeType = {
	resource = "q_resource",
	npc = "q_npc"
}

Quantum.DefaultNodeHealth = 10

Quantum.DefaultNodeRespawnTimer = 30

---- Property vars ----

Quantum.DoorSounds = {
	Lock = "doors/default_locked.wav",
	Unlock = "doors/default_locked.wav"
}

Quantum.DefualtPropertyPrice = 5000

Quantum.DoorClasses = {
    ["func_door"] = true,
    ["func_door_rotating"] = true,
    ["prop_door_rotating"] = true,
    ["func_movelinear"] = true,
    ["prop_dynamic"] = true
}