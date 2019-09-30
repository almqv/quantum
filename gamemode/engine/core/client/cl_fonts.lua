--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

surface.CreateFont( "q_HUD", {
    font = "Arial",
    size = 30 * Quantum.Client.ResolutionScale,
    antialias = true,
    outline = true
})

surface.CreateFont( "q_text", {
    font = "Arial",
    size = 22 * Quantum.Client.ResolutionScale,
    antialias = true
})