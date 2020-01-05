--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

if SERVER then -- SERVER VARS UNDER THIS LINE


end --

if CLIENT then -- SERVER VARS UNDER THIS LINE

	Quantum.Client.Cache = Quantum.Client.Cache || {}
	Quantum.Client.ResolutionScale = ScrH() / 1080
	Quantum.Client.ServerBannerPath = "gamemodes/" .. GM.FolderName .. "/gamemode/content/materials/quantum/server_banner.png" 

end --

-- SHARED VARS UNDER THIS LINE

Quantum.ItemInfoDisplayMaxDistance = 200

Quantum.CharInfoDisplayDistance = 400


Quantum.Rarity = {
	None = { txt = "gnomerd the mvp", color = Color( 0, 0, 0, 120 ) },
	Trash = { txt = "Trash", color = Color( 100, 100, 100, 40 ) },
	Common = { txt = "Common", color = Color( 250, 250, 250, 40 ) },
	Rare = { txt = "Rare", color = Color( 48, 163, 230, 40 ) },
	Epic = { txt = "Epic", color = Color( 220, 90, 90, 40 ) },
	Legendary = { txt = "Legendary", color = Color( 235, 125, 52, 40 ) }
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
	DESTROY_ITEM = 5,
	UPDATE = 6,
	BIT_SIZE = 3
}

function Quantum.calculateNeededBits( n ) return math.ceil( math.log( n, 2 ) ) end

function Quantum.WriteIntcode( intcode ) net.WriteInt( intcode, Quantum.IntCode.BIT_SIZE ) end