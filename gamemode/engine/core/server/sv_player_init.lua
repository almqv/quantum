--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

Quantum.Server.Player = {}

local ply = FindMetaTable( "Player" )

function GM:PlayerSelectSpawn( ply )
	return -- return nothing because we dont wont the player to spawn anywhere
end

function GM:PlayerInitialSpawn( ply )
	ply.isloaded = false -- REMOVE THIS WHEN MYSQL DB IS ADDED
	ply.cache = {}
	-- load in all of the players characters and stuff from the MySQL DB
end

local function setUpPlayer( ply )
	local plchar = Quantum.Server.Char.GetCurrentCharacter( ply )

	if( plchar != nil ) then
		ply:SetModel( plchar.model )
	end
	
	if( ply:GetModel() ~= nil ) then
		ply:SetupHands()
	else
		Quantum.Error( Quantum.PrintPlayer( ply ) .. " doesn't have a valid model. Unable to set up hands!" )
	end
	local char = Quantum.Server.Char.GetCurrentCharacter( ply )
	local charnametxt = " spawned."
	if( char ~= nil ) then
		charnametxt = " spawned as '" .. char.name .. "'." 
	end

	-- set player speeds
	ply:SetWalkSpeed( Quantum.Server.Settings.PlayerSpeeds.walk )
	ply:SetRunSpeed( Quantum.Server.Settings.PlayerSpeeds.run )
	ply:SetCrouchedWalkSpeed( Quantum.Server.Settings.PlayerSpeeds.duck)
	ply:SetMaxSpeed( Quantum.Server.Settings.PlayerSpeeds.run )

	ply:SetFOV( 72 )

	ply:Give( "quantum_hands" )
	ply:SelectWeapon( "quantum_hands" )

	Quantum.Debug( Quantum.PrintPlayer( ply ) .. charnametxt  )
end

function GM:PlayerSpawn( ply )

	if( !ply:IsBot() ) then
		if( ply.isloaded == true ) then 
			ply:UnSpectate() 
			setUpPlayer( ply )
		else
			ply:SetPos( Vector( 0, 0, 0 ) )
			Quantum.Net.OpenMenu( ply, "main", { chars = Quantum.Server.Char.GetPlayerChars_cl( ply ) } ) -- make the player open the main menu
		end
	else
		if( !ply.isloaded ) then
			local selectedChar = table.Random( Quantum.Server.Settings.BotChars )
			ply.isbot = true
			ply.isloaded = true
			local botCharCount = table.Count(Quantum.Server.Char.GetPlayerChars( ply ))
			Quantum.Server.Char.Load( ply, botCharCount + 1, selectedChar )
			Quantum.Server.Char.SetCurrentCharacter( ply, botCharCount + 1 )
		else
			setUpPlayer( ply )
		end
	end
end