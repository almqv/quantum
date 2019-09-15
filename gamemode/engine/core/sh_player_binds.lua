--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  


if SERVER then

    local keyfuncs = {
        [IN_USE] = function( pl )
            pl:ChatPrint( "Use bind test" )
        end
    }

    function GM:KeyRelease( ply, key )
        if( keyfuncs[key] ) then keyfuncs[key]( pl ) end
    end

end