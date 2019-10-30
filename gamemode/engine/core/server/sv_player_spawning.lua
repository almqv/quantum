--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

hook.Add( "PlayerDeath", "Quantum_Player_SaveDeathPos", function( pl ) 
    pl.deathpos = pl:GetPos()
end)

local function getNearestSpawn( pl )
    local spawnposdist = {}
    for id, spawnpoint in pairs( Quantum.Server.Settings.SpawnLocations[ game.GetMap() ] ) do
        spawnposdist[id] = { dist = spawnpoint.pos:Distance( pl.deathpos ), spawnpos = spawnpoint.pos, angle = spawnpoint.ang }
    end

    local maxdist, spawnpos, spawnangle
    for id, spawn in pairs( spawnposdist ) do -- Loop through everything and pick the nearest spawnpoint
        if( maxdist ~= nil ) then
            if( maxdist >= spawn.dist ) then
                maxdist = spawn.dist
                spawnpos = spawn.spawnpos
                spawnangle = spawn.angle
            end
        else
            maxdist = spawn.dist
            spawnpos = spawn.spawnpos
            spawnangle = spawn.angle
        end
    end
    return spawnpos, spawnangle
end

hook.Add( "PlayerSpawn", "Quantum_Player_Respawn", function( pl ) 
    if( pl.isloaded && pl.deathpos ) then
        
        local spawnpos, spawnangle = getNearestSpawn( pl )

        Quantum.Debug( "Respawning player at nearest spawnpoint." )
        pl:SetPos( spawnpos )
        pl:SetAngles( spawnangle )
    end
end)