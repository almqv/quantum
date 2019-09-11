--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

local prefix
if CLIENT then prefix = "[Quantum] : " else prefix = "" end -- A little advertisement for the players

function Quantum.Debug( txt ) -- Very usefull for debugging 
    if( txt ) then 
        MsgC( Color( 200, 200, 200 ), prefix .. "[Debug] " .. txt .. "\n" )
    else 
        MsgC( Color( 200, 200, 200 ), prefix .. "[Debug]\n" ) 
    end
end

function Quantum.Error( txt )
    if( txt ) then 
        MsgC( Color( 255, 10, 10 ), prefix .. "[ERROR] " .. txt .. "\n"  ) 
    else 
        return 
    end
end