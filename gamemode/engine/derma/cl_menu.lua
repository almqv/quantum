--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

Quantum.Client.Menu = {}
local libs = {
	["net"] = GM.FolderName .. "/gamemode/engine/derma/lib/cl_network.lua",
	["page"] = GM.FolderName .. "/gamemode/engine/derma/lib/cl_menu_pages.lua",
	["theme"] = GM.FolderName .. "/gamemode/engine/derma/lib/cl_menu_theme.lua",
	["dialogue"] = GM.FolderName .. "/gamemode/engine/derma/lib/cl_menu_dialogueBox.lua",
	["sure"] = GM.FolderName .. "/gamemode/engine/derma/lib/cl_menu_areusure.lua"
}
Quantum.Client.Menu.GetAPI = function( lib ) return include( libs[lib] ) end

Quantum.Client.Menu.Menus = {}

local function getMenuIDbyFileName( file )
	local str = string.Split( tostring(file), "menu_" )
	return string.Split( str[2], ".lua" )[1]
end

Quantum.Client.Menu.Load = function()
	local files = file.Find( GM.FolderName .. "/gamemode/engine/derma/menus/menu_*.lua", "LUA" ) 
	Quantum.Debug("Loading menus...")
	if( !files == nil || #files <= 0 ) then Quantum.Error( "Failed to load menus! Menu files not found. Contact someone important!\nFiles: " .. tostring(files) .. " (" .. tostring(#files) .. ")" ) end

	for i, file in pairs( files ) do -- pretty ineffective but this will only be run ONCE to load all of the menus
		local id = getMenuIDbyFileName( file ) -- get the menu id by removing ".lua" and "menu_" from it
		Quantum.Client.Menu.Menus[id] = include( GM.FolderName .. "/gamemode/engine/derma/menus/" .. file ) -- put it into the table
		Quantum.Debug( "Loaded menu: '" .. tostring(id) .. "'" ) -- debug it
	end
end

Quantum.Client.Menu.Load() -- load in all of the menus when the player joins (lua autorun)

net.Receive( "quantum_menu_net", function( len, pl ) 
	local dt = net.ReadTable()
	if( Quantum.Client.Cache[dt.id] ~= nil && #Quantum.Client.Cache[dt.id] >= 1 ) then 
		 table.Merge( Quantum.Client.Cache[dt.id], dt )
	else
		Quantum.Client.Cache[dt.id] = dt || { id = dt.id }
	end

	if( Quantum.Client.EnableDebug ) then -- debug
		Quantum.Debug( "Datatable size: " .. len .. "b (" .. len/8 .. "B)" )
		Quantum.Debug( "[Datatable Contents]")
		PrintTable( dt ) 
		Quantum.Debug( "[End of Datatable Contens]" )
	end

	Quantum.Client.Menu.Menus[dt.id].open( dt ) -- open the menu
end)