--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

Quantum.Server.Player = {}

local ply = FindMetaTable( "Player" )

function GM:PlayerInitialSpawn( ply )
    --ply.isloaded = true -- REMOVE THIS WHEN MYSQL DB IS ADDED
    
end

local function setUpPlayer( ply )
    
    Quantum.Server.Char.SetCurrentCharacter( ply, ply.charindex || 1 )

    if( ply:GetModel() ~= nil ) then
        ply:SetupHands()
    else
        Quantum.Error( tostring(ply) .. " doesn't have a valid model. Unable to set up hands!" )
    end
    Quantum.Debug( tostring( ply ) .. " spawned." )
end

function GM:PlayerSpawn( ply )

    if( ply.isloaded ) then 
        ply:Spectate( OBS_MODE_FIXED ) 
    else
        setUpPlayer( ply )
    end

end