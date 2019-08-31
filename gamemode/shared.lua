--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

GM.Name = "DarkRP"
GM.Author = "AlmTech"
GM.Email = "elias@almtech.se"
GM.Website = "N/A"

GM.Shared = {}

function GM.Shared.Load()
    local fol = GM.FolderName .. "/gamemode/core/"

    local shFiles = file.Find( fol .. "/sh_*.lua", "LUA" )
    for _, file in pairs( shFiles ) do
        include( fol .. file )
    end
end

GM.Shared.Load()