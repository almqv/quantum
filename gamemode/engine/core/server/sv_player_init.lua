--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

Quantum.Server.Player = {}

local ply = FindMetaTable( "Player" )

function GM:PlayerInitialSpawn( ply )
	ply.isloaded = false -- REMOVE THIS WHEN MYSQL DB IS ADDED
	ply.cache = {}
	-- load in all of the players characters and stuff from the MySQL DB
end

local function setUpPlayer( ply )
	if( ply:GetModel() ~= nil ) then
		ply:SetupHands()
	else
		Quantum.Error( tostring(ply) .. " doesn't have a valid model. Unable to set up hands!" )
	end
	local char = Quantum.Server.Char.GetCurrentCharacter( ply )
	local charnametxt = " spawned."
	if( char ~= nil ) then
		charnametxt = " spawned as '" .. char.name .. "'." 
	end
	Quantum.Debug( tostring( ply ) .. charnametxt  )
end

function GM:PlayerSpawn( ply )

	if( ply.isloaded == true ) then -- replace logic ( reversed )
		ply:UnSpectate() 
		setUpPlayer( ply )
	else
		ply:SetPos( Vector( -8936.411133, 8244.439453, 7744.031250 ) )
		Quantum.Net.OpenMenu( ply, "main", Quantum.Server.Char.GetPlayerChars_cl( ply ) ) -- make the player open the main menu
	end

end