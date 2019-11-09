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

    if( ply.isloaded ) then -- replace logic ( reversed )
        ply:Spectate( OBS_MODE_FIXED ) 
        Quantum.Net.OpenMenu( ply, "character", Quantum.Server.Char.GetPlayerChars( ply ) )
    else
        ply:UnSpectate() 
        setUpPlayer( ply )
    end

end