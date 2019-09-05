--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

local damagescales = {
    [HITGROUP_HEAD] = Quantum.Server.Settings.DamageScale[HITGROUP_HEAD],
    [HITGROUP_CHEST] = Quantum.Server.Settings.DamageScale[HITGROUP_CHEST],
    [HITGROUP_STOMACH] = Quantum.Server.Settings.DamageScale[HITGROUP_STOMACH],
    [HITGROUP_LEFTARM] = Quantum.Server.Settings.DamageScale[HITGROUP_LEFTARM],
    [HITGROUP_RIGHTARM] = Quantum.Server.Settings.DamageScale[HITGROUP_RIGHTARM],
    [HITGROUP_LEFTLEG] = Quantum.Server.Settings.DamageScale[HITGROUP_LEFTLEG],
    [HITGROUP_RIGHTLEG] = Quantum.Server.Settings.DamageScale[HITGROUP_RIGHTLEG]
}

function GM:ScalePlayerDamage( pl, hitgroup, dmginfo ) -- This is used for getting shot etc
    if( damagescales[hitgroup] ~= nil ) then dmginfo:ScaleDamage( damagescales[hitgroup] ) end
    Quantum.Debug( tostring(pl) .. " got damaged (" .. tostring(hitgroup) .. " : " .. tostring( math.Round( dmginfo:GetDamage() ) ) .. " )" )
end

function GM:GetFallDamage( pl, vel )
    Quantum.Debug( tostring(pl) .. " got damaged ( Fall Damage : " .. tostring( math.Round( vel / 8 ) ) .. " )" )
    return vel / 8 -- Makes the player take more "realistic" fall damage
end

function GM:PlayerDeathSound() return true end

hook.Add( "EntityTakeDamage", "Quantum_PlayerDamage_SoundEffect", function( pl, dmginfo ) 
    if( pl:IsPlayer() && dmginfo:GetDamage() >= 25 ) then
        local soundlist = {
            pain = Quantum.Server.Settings.PainSounds.Male, -- replace later with correct gender for the playermodel/character
            idlepain = Quantum.Server.Settings.IdlePainSounds.Male -- same for this one
        }
        pl:EmitSound( Quantum.Server.Settings.PainSounds.Male[ math.random( 1, #Quantum.Server.Settings.PainSounds.Male ) ] ) 
        
        if( timer.Exists( "Quantum_PlayerHurtSounds_" .. tostring( pl ) ) ) then timer.Remove( "Quantum_PlayerHurtSounds_" .. tostring( pl ) ) end -- if it already exists remove it
        timer.Create( "Quantum_PlayerHurtSounds_" .. tostring( pl ), 4, 0, function() 

            local rannum = math.random( 0, 100 )
            if( rannum >= Quantum.Server.Settings.DamageHurtSoundRepeatChance ) then -- Make the player "moan" for a while when hurt
                pl:EmitSound( Quantum.Server.Settings.IdlePainSounds.Male[ math.random( 1, #Quantum.Server.Settings.IdlePainSounds.Male ) ] )
            end

        end)

        timer.Simple( 60, function() 
            timer.Remove( "Quantum_PlayerHurtSounds_" .. tostring( pl ) ) -- remove the timer for the player
        end)

    end
end)