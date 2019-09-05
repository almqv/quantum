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
    Quantum.Debug( tostring(pl) .. " got damaged (" .. tostring(hitgroup) .. " : " .. tostring(dmginfo) )
end

function GM:GetFallDamage( pl, vel )
    return vel / 8 -- Makes the player take more "realistic" fall damage
end

function GM:PlayerDeathSound() return true end