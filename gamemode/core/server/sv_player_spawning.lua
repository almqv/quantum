--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

hook.Add( "PlayerSpawn", "Quantum_Player_Respawn", function( pl ) 
    if( pl.isloaded && pl.deathpos ) then
        local spawnposdist = {}
        for id, pos in pairs( Quantum.Server.Settings.SpawnLocations[ game.GetMap() ] ) do
            print( id, pos )
            spawnposdist[id] = { dist = pos:Distance( pl.deathpos ), spawnpos = pos }
        end


        local maxdist
        local spawnpos
        for i, spawnpos in ipairs( spawnposdist ) do -- Loop through everything and pick the nearest spawnpoint
            if( maxdist ~= nil ) then
                if( maxdist <= spawnpos.dist ) then
                    maxdist = spawnpos.dist
                    spawnpos = spawnpos.pos
                end
            else
                maxdist = spawnpos.dist
                spawnpos = spawnpos.pos
            end
        end

        Quantum.Debug( "Respawning player at nearest spawnpoint... ( " .. tostring( spawnpos ) .. " )" )
        pl:SetPos( spawnpos )

    end
end)