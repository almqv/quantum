--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

            Quantum.Server.Settings = {}

Quantum.Server.Settings.DamageScale = { -- The scale of the damage for each hitgroup
    [HITGROUP_HEAD] = 4,
    [HITGROUP_CHEST] = 2,
    [HITGROUP_STOMACH] = 1.5,
    [HITGROUP_LEFTARM] = 0.8,
    [HITGROUP_RIGHTARM] = 0.8,
    [HITGROUP_LEFTLEG] = 1,
    [HITGROUP_RIGHTLEG] = 1
}

Quantum.Server.Settings.PainSounds = {}
Quantum.Server.Settings.PainSounds.Male = {
    "vo/npc/male01/pain01.wav",
    "vo/npc/male01/pain02.wav",
    "vo/npc/male01/pain03.wav",
    "vo/npc/male01/pain04.wav",
    "vo/npc/male01/pain05.wav",
    "vo/npc/male01/pain06.wav",
    "vo/npc/male01/pain07.wav",
    "vo/npc/male01/pain08.wav",
    "vo/npc/male01/pain09.wav"
}

Quantum.Server.Settings.DamageHurtSoundRepeatChance = 90

Quantum.Server.Settings.IdlePainSounds = {}
Quantum.Server.Settings.IdlePainSounds.Male = {
    "vo/npc/male01/moan01.wav",
    "vo/npc/male01/moan02.wav",
    "vo/npc/male01/moan03.wav",
    "vo/npc/male01/moan04.wav",
    "vo/npc/male01/moan05.wav"
}


