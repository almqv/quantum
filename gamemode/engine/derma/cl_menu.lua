--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

Quantum.Client.Menu = {}
local libs = {
    ["net"] = GAMEMODE.FolderName .. "/gamemode/engine/derma/lib/cl_network.lua"
}
Quantum.Client.Menu.GetAPI = function( lib ) return include( libs[lib] ) end

net.Receive( "quantum_menu_net", function( len, pl ) 
    local dt = net.ReadTable()
    local menu = include( GAMEMODE.FolderName .. "/gamemode/engine/derma/menus/menu_" .. dt.id .. ".lua" )
    menu.open( dt )
end)