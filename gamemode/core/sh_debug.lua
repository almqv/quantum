--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

--- This is used for debugging :D

function GM.Debug( txt )
    if( txt ) then MsgC(  Color( 100, 100, 100 ), "[Debug] " .. txt .. "\n" ) else MsgC( Color( 100, 100, 100 ), "[Debug]" .. "\n" ) end
end

function GM.Error( txt )
    if( txt ) then 
        MsgC( Color( 255, 10, 10 ), "[ERROR] " .. txt .. "\n" ) 
    else 
        return 
    end
end