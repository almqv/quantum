--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

if SERVER then
    AddCSLuaFile( "cl_init.lua" )
    AddCSLuaFile( "shared.lua" )

    include( "shared.lua" )

    Quantum.Server = {}

    -- Add all core files

    function Quantum.Server.Load()
        local fol = GM.FolderName .. "/gamemode/core/"

        -- Shared files
        local shFiles = file.Find( fol .. "/sh_*.lua", "LUA" )
        for _, file in pairs( shFiles ) do
            AddCSLuaFile( fol .. file )
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

    Quantum.Server.Load() 
end