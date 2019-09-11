--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

Quantum.Server.Inventory = {} 

function Quantum.Server.Inventory.Create( char )
    char.inventory = {}

    for i = 1, Quantum.Server.Settings.Inventory.Width do
        char.inventory[i] = {}
    end

    for h, v in pairs( char.inventory ) do
        for w = 1, Quantum.Server.Settings.Inventory.Height do
            char.inventory[h][w] = 0
        end
    end

    return char.inventory
end

local function isEquippable( item )
    return item.equipable || false
end

function Quantum.Server.Inventory.SetSlotItem( char, x, y, item, amount ) 
    if( isEquippable( item ) ) then 
        amount = 1
        char.inventory[x][y] = { item }
    else
        amount = amount || 1
        char.inventory[x][y] = { item, amount }
    end
    Quantum.Debug( "Gave " .. char.name .. " " .. amount .. " [" .. item.name .. "]" )
    return 
end

function Quantum.Server.Inventory.GetSlotItem( char, x, y ) return char.inventory[x][y] end