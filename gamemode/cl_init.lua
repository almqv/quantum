--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

if CLIENT then
    include( "shared.lua" )
    Quantum.Client = {}
    Quantum.Client.ResolutionScale = ScrW() / 1080

    local function loadCoreFiles()
        local fol = GM.FolderName .. "/gamemode/engine/core/"

        local shFiles = file.Find( fol .. "/sh_*.lua", "LUA" )
        for _, file in pairs( shFiles ) do
			include( fol .. file )
        end

        local clFiles = file.Find( fol .. "/client/cl_*.lua", "LUA" )
        for _, file in pairs( clFiles ) do
            include( fol .. "client/" .. file )
        end
    end

    local function loadLibFiles()
        local fol = GM.FolderName .. "/gamemode/engine/lib/"

        local shFiles = file.Find( fol .. "/sh_*.lua", "LUA" )
        for _, file in pairs( shFiles ) do
			AddCSLuaFile( fol .. file )
			include( fol .. file )
        end

        local clFiles = file.Find( fol .. "/client/cl_*.lua", "LUA" )
        for _, file in pairs( clFiles ) do
            include( fol .. "client/" .. file )
        end
    end

    local function loadAllDermaMenus()
        local fol = GM.FolderName .. "/gamemode/engine/derma/"
        include( fol .. "/cl_menu.lua" )
    end

    function Quantum.Client.Load()
		local fol = GM.FolderName .. "/gamemode/engine/core/"
		
        loadCoreFiles()
        loadLibFiles()
        loadAllDermaMenus()

        Quantum.Debug( "Loaded all files." )
    end

    Quantum.Client.Load() 
end