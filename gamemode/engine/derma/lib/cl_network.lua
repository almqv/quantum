--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

local snm = {} -- Safe. Networked. Message

function snm.RunNetworkedFunc( func, args )
    net.Start( "quantum_menu_button_net" )      -- used for menu buttons etc
        net.WriteString( func )                 -- don't worry! it's very secure :D
        net.WriteTable( args )
    net.SendToServer()
end

return snm