--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

if SERVER then
    AddCSLuaFile( "engine/sh_debug.lua" )
    AddCSLuaFile( "cl_init.lua" )
    AddCSLuaFile( "shared.lua" )

    include( "shared.lua" )

    Quantum.Server = {}
    include( "settings/sv_settings.lua" ) -- include the settings


    local function loadCoreFiles()
        local fol = GM.FolderName .. "/gamemode/engine/core/"

        -- Shared files
        local shFiles = file.Find( fol .. "/sh_*.lua", "LUA" )
        for _, file in pairs( shFiles ) do
			AddCSLuaFile( fol .. file )
			include( fol .. file )
        end

        -- CLient files
        local clFiles = file.Find( fol .. "/client/cl_*.lua", "LUA" )
        for _, file in pairs( clFiles ) do
            AddCSLuaFile( fol .. "client/" .. file )
        end

        -- Server files
        local cFiles = file.Find( fol .. "/server/sv_*.lua", "LUA" )
        for _, file in pairs( cFiles ) do
            include( fol .. "server/" .. file )
        end   
    end

    local function loadLibFiles()
        local fol = GM.FolderName .. "/gamemode/engine/lib/"

        -- Shared files
        local shFiles = file.Find( fol .. "/sh_*.lua", "LUA" )
        for _, file in pairs( shFiles ) do
			AddCSLuaFile( fol .. file )
			include( fol .. file )
        end

        -- CLient files
        local clFiles = file.Find( fol .. "/client/cl_*.lua", "LUA" )
        for _, file in pairs( clFiles ) do
            AddCSLuaFile( fol .. "client/" .. file )
        end

        -- Server files
        local cFiles = file.Find( fol .. "/server/sv_*.lua", "LUA" )
        for _, file in pairs( cFiles ) do
            include( fol .. "server/" .. file )
        end  
    end

    local function addAllDermaMenus()

        AddCSLuaFile( fol .. "/cl_menu.lua" )

        local fol = GM.FolderName .. "/gamemode/engine/derma/"
        local menuFiles = file.Find( fol .. "/lib/menu_*.lua", "LUA" )
        for _, file in pairs( menuFiles ) do
            AddCSLuaFile( fol .. "/" .. file )
        end

    end
    
    function Quantum.Server.Load()
        -- Add all of the base files
        loadCoreFiles()
        loadLibFiles()
        addAllDermaMenus()
    end

    Quantum.Server.Load() 
end