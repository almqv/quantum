--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

if SERVER then
	AddCSLuaFile( "engine/sh_debug.lua" )

	AddCSLuaFile( "engine/vars/sh_vars.lua" )
	AddCSLuaFile( "engine/vars/cl_vars.lua" )

	AddCSLuaFile( "settings/sh_settings.lua" )
	AddCSLuaFile( "settings/sh_items.lua" )
	AddCSLuaFile( "settings/sh_effects.lua" )
	AddCSLuaFile( "settings/sh_recipes.lua" )

	AddCSLuaFile( "cl_init.lua" )
	AddCSLuaFile( "shared.lua" )

	-- Content --
	local path = "gamemodes/" .. GM.FolderName .. "/gamemode/content/materials/quantum/server_banner.png"
	resource.AddSingleFile( path )

	resource.AddSingleFile( "materials/quantum/mic_icon48.png" ) -- add the mic icon
	resource.AddSingleFile( "materials/quantum/mic_icon24.png" )

	include( "shared.lua" ) -- 

	Quantum.Server = {}
	include( "settings/sv_settings.lua" ) -- include the settings
	include( "engine/vars/sv_vars.lua" ) -- include vars


	local function loadCoreFiles()
		local fol = GM.FolderName .. "/gamemode/engine/core/"
		MsgC( "\n" )
		Quantum.Debug( "Loading core files..." )
		-- Shared files
		local shFiles = file.Find( fol .. "/sh_*.lua", "LUA" )
		for _, file in pairs( shFiles ) do
			AddCSLuaFile( fol .. file )
			include( fol .. file )
			Quantum.Debug( "(CORE) Loaded: " .. fol .. file )
		end

		-- CLient files
		local clFiles = file.Find( fol .. "/client/cl_*.lua", "LUA" )
		for _, file in pairs( clFiles ) do
			AddCSLuaFile( fol .. "client/" .. file )
			Quantum.Debug( "(CORE) Loaded: " .. fol .. "client/" .. file )
		end

		-- Server files
		local cFiles = file.Find( fol .. "/server/sv_*.lua", "LUA" )
		for _, file in pairs( cFiles ) do
			include( fol .. "server/" .. file )
			Quantum.Debug( "(CORE) Loaded: " .. fol .. "server/" .. file )
		end   
	end

	local function loadLibFiles()
		local fol = GM.FolderName .. "/gamemode/engine/lib/"
		MsgC( "\n" )
		Quantum.Debug( "Loading libraries..." )
		-- Shared files
		local shFiles = file.Find( fol .. "/sh_*.lua", "LUA" )
		for _, file in pairs( shFiles ) do
			AddCSLuaFile( fol .. file )
			include( fol .. file )
			Quantum.Debug( "Added library: " .. fol .. file )
		end

		-- CLient files
		local clFiles = file.Find( fol .. "/client/cl_*.lua", "LUA" )
		for _, file in pairs( clFiles ) do
			AddCSLuaFile( fol .. "client/" .. file )
			Quantum.Debug( "Added library: " .. fol .. "client/" .. file )
		end

		-- Server files
		local cFiles = file.Find( fol .. "/server/sv_*.lua", "LUA" )
		for _, file in pairs( cFiles ) do
			include( fol .. "server/" .. file )
			Quantum.Debug( "Added library: " .. fol .. "server/" .. file )
		end  
	end

	local function addAllDermaMenus()
		local fol = GM.FolderName .. "/gamemode/engine/derma/"
		MsgC( "\n" )
		Quantum.Debug( "Loading menus...")

		AddCSLuaFile( fol .. "cl_menu.lua" )

		-- add all the menu libs
		local libfol = fol .. "lib/"
		local libFiles = file.Find( libfol .. "cl_*.lua", "LUA" )
		for _, file in pairs( libFiles ) do
			AddCSLuaFile( libfol .. file )
			Quantum.Debug( "Added library: " .. libfol .. file )
		end

		-- add the menu's
		local menufol = GM.FolderName .. "/gamemode/engine/derma/menus/"
		local menuFiles = file.Find( menufol .. "menu_*.lua", "LUA" )
		for _, file in pairs( menuFiles ) do
			AddCSLuaFile( menufol .. file )
			Quantum.Debug( "Added menu: " .. menufol .. file )
		end

	end

	local function loadAllItemsAndEffects()
		include( "settings/sh_items.lua" )
		include( "settings/sh_effects.lua" )
		include( "settings/sh_recipes.lua" )
	end

	local function loadPlugins()
		

		local fol = GM.FolderName .. "/plugins/"
		local pluginFiles = file.Find( fol .. "plugin_*.lua", "LUA" )

		if( #pluginFiles > 0 ) then
			MsgC( "\n" )
			Quantum.Debug( "Loading plugins...")
			for _, file in pairs( pluginFiles ) do
				Quantum.Debug( "Added plugin: " .. fol .. file )
				AddCSLuaFile( fol .. file )
				include( fol .. file )
			end
		else
			MsgC( "\n" )
			Quantum.Debug( "No plugins found." )
		end
	end
	
	function Quantum.Server.Load()
		-- Add all of the base files
		loadCoreFiles()
		loadLibFiles()
		addAllDermaMenus()

		-- Creation of stuff
		loadAllItemsAndEffects() 

		-- Plugins
		loadPlugins()
	end
	
	Quantum.Server.Load() 
	MsgC( "\n" )
end
