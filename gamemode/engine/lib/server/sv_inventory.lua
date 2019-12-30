--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

Quantum.Server.Inventory = {} 

function Quantum.Server.Inventory.Create( char )
	char.inventory = {}

	return char.inventory
end

local function isEquippable( item )
	return item.equipable || false
end

function Quantum.Server.Inventory.SetSlotItem( char, pos, item, amount ) 
	if( isEquippable( item ) ) then 
		amount = 1
		char.inventory[pos] = { item }
	else
		amount = amount || 1
		char.inventory[pos] = { item, amount }
	end
	Quantum.Debug( "Gave " .. char.name .. " " .. amount .. " [" .. item.name .. "]" )
	return 
end

function Quantum.Server.Inventory.GetSlotItem( char, x, y ) return char.inventory[x][y] end