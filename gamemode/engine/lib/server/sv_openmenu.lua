--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  


local menus = {
    character = function( pl )
        Quantum.Net.OpenMenu( pl, "character", Quantum.Server.Char.GetPlayerChars( pl ) )
    end
}

function Quantum.Server.OpenMenu( pl, menu ) 
    if( menus[menu] ) then
        menus[menu]( pl )
    else
        Quantum.Error( "Tried to open a non-exsistent menu for " .. tostring(pl) .. "." )
    end
end