--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

local ply = FindMetaTable( "Player" )

function GM:PlayerInitialSpawn( ply )
    ply.isloaded = true -- REMOVE THIS WHEN MYSQL DB IS ADDED
end

function GM:PlayerSpawn( ply )

    ply:SetModel( "models/player/Group03/male_04.mdl" )

    if( ply:GetModel() ~= nil ) then
        ply:SetupHands()
    else
        Quantum.Error( tostring(ply) .. " doesn't have a valid model. Unable to set up hands!" )
    end
    Quantum.Debug( tostring( ply ) .. " spawned." )
end