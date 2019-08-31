--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

include( "shared.lua" )

GM.Client = {}

-- Add all core files

function GM.Client.Load()
    local fol = GM.FolderName .. "/gamemode/core/"

    -- CLient files
    local clFiles = file.Find( fol .. "/client/cl_*.lua", "LUA" )
    for _, file in pairs( clFiles ) do
        include( fol .. "client/" .. file )
    end

end

GM.Client.Load() 