--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

local ply = FindMetaTable( "Player" )

function GM:PlayerSpawn( ply )
    if( !ply:GetModel() || !ply:GetModel() == "" ) then
        ply:SetupHands()
    else
        Quantum.Error( tostring(ply) .. " doesn't have a valid model. Unable to set up hands!" )
    end
    Quantum.Debug( tostring( ply ) .. " spawned." )
end