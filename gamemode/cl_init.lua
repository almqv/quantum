--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

if CLIENT then
    include( "shared.lua" )
    Quantum.Client = {}

    -- Add all core files

    function Quantum.Client.Load()
		local fol = GM.FolderName .. "/gamemode/core/"
		

		-- Shared files
		local shFiles = file.Find( fol .. "/sh_*.lua", "LUA" )
		for _, file in pairs( shFiles ) do
			include( fol .. file )
		end

		Quantum.Shared.Init()

        -- CLient files
        local clFiles = file.Find( fol .. "/client/cl_*.lua", "LUA" )
        for _, file in pairs( clFiles ) do
            include( fol .. "client/" .. file )
        end

        Quantum.Debug( "Loaded all files." )
    end

    Quantum.Client.Load() 
end