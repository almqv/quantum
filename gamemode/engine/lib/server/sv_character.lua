--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

Quantum.Server.Char = {}
Quantum.Server.Char.Players = {}

local function CreateCharTable( args )
    return {
        name = args.name || "UNKNOWN",
        maxhealth = Quantum.Server.Settings.MaxHealth,
        health = args.health || Quantum.Server.Settings.MaxHealth,
        model = args.model || "models/player.mdl",
        money = args.money || Quantum.Server.Settings.StarterMoney,
        inventory = args.inventory || {}, -- create new inventory later
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

function Quantum.Server.Char.Load( pl, index, tbl )
    local id = pl:SteamID() .. ";" .. index
    if( Quantum.Server.Char.Players[ id ] == nil ) then
        Quantum.Server.Char.Players[ id ] = CreateCharTable( tbl ) -- create the character
        Quantum.Server.Char.Players[ id ].inventory = tbl.inventory || Quantum.Server.Inventory.Create( Quantum.Server.Char.Players[ id ] ) -- give the character an inventory

        Quantum.Debug( "Created character (" .. id .. ")" )
        return Quantum.Server.Char.Players[ id ]
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

local function setupCharacter( pl, char )
    pl:SetMaxHealth( char.maxhealth )
    pl:SetHealth( char.health )
    pl:SetModel( char.model )
end

function Quantum.Server.Char.SetCurrentCharacter( pl, index )
    local id = pl:SteamID() .. ":" .. index
    if( Quantum.Server.Char.Players[ id ] ) then 
        pl.character = Quantum.Server.Char.Players[ id ]
        setupCharacter( pl, pl.character )
        return pl.character
    else
        Quantum.Error( "Unable to set " .. tostring(pl) .. " character. Character not found!" )
        return nil
    end
end

function Quantum.Server.Char.GetPlayerChars( pl )
    local chars = {}
    for id, char in pairs( Quantum.Server.Char.Players ) do
        chars[id] = char
    end
    return chars
end