--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

net.Receive( "quantum_menu_net", function( len, pl ) 
    local dt = net.ReadTable()
    local menu = include( GAMEMODE.FolderName .. "/gamemode/engine/derma/menus/menu_" .. dt.id .. ".lua" )
    menu.open( dt )
end)