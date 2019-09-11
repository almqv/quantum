--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

Quantum.Server.Char = {}
Quantum.Server.Char.Players = {}

function Quantum.Server.Char.CreateCharTable( args )
    return {
        name = args.name || "UNKNOWN",
        model = args.model || "models/player.mdl",
        money = args.money || Quantum.Server.Settings.StarterMoney,
        inventory = args.inventory || {}, -- create new inventory
        jobs = args.jobs || {
            [1] = { title = "Hobo", level = -1 },
        },
        skills = args.skills || {
            crafting = 0,
            cooking = 0,
            combat = 0,
            science = 0
        },
        training = args.training || {},
        licenses = args.licenses || {},
        titles = args.titles || {}
    }
end

function Quantum.Server.Char.Create( pl, index, tbl )
    local id = pl:SteamID() .. ":" .. index
    if( Quantum.Server.Char.Players[ id ] ~= nil ) then
        Quantum.Server.Char.Players[ id ] = tbl
        Quantum.Debug( "Created character (" .. id .. ")" )
    else
        Quantum.Error( "Tried to duplicate character! Index already used. (" .. id .. ")" )
    end
end

function Quantum.Server.Char.Remove( pl, index )
    local id = pl:SteamID() .. ":" .. index
    if( Quantum.Server.Char.Players[ id ] ~= nil ) then
        Quantum.Server.Char.Players[ id ] = nil
        Quantum.Debug( "Removed character (" .. id .. ")" )
    end
end

function Quantum.Server.Char.GetCurrentCharacter( pl )
    if( pl.character == nil ) then Quantum.Error( tostring( pl ) .. " doesn't have a character! Unable to get current character table." ) end
    return pl.character
end