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

local function isStackable( item )
	return item.stack || false
end

function Quantum.Server.Inventory.SetSlotItem( char, pos, itemid, amount ) 
	if( amount < 1 ) then return end
	local item = Quantum.Item.Get( itemid )
	if( isEquippable( item ) || !isStackable( item ) ) then 
		amount = 1
		char.inventory[pos] = { itemid }
	else
		amount = amount || 1
		char.inventory[pos] = { itemid, amount }
	end
	Quantum.Debug( "Gave " .. char.name .. " " .. amount .. "x [" .. item.name .. "] at " .. tostring(pos) )
end

function Quantum.Server.Inventory.GetSlotItem( char, pos ) return char.inventory[pos] end

function Quantum.Server.Inventory.FindStackable( char, item )
	if( item.stack ) then
		local inv = Quantum.Server.Char.GetInventory( char ) 
		for i, item2 in pairs( inv ) do
			if( item2[1] == item.id && item2[2] < item.stack ) then -- if the item is stackable and it is the same item
				return i -- return its index
			end
		end
	else
		return
	end
end

local function getStackSize( char, item )
	return item.stack || 1
end

local function sortItem( char, itemid, amount )

	local item = Quantum.Item.Get( itemid )
	local slotitem = Quantum.Server.Inventory.GetSlotItem( char, index ) 
	local inv = Quantum.Server.Char.GetInventory( char )

	local stacksize = getStackSize( char, item )

	local index = Quantum.Server.Inventory.FindStackable( char, item ) || #inv + 1

	local rest = amount
	if( slotitem != nil ) then rest = rest + slotitem[2] end

	local count = 0

	local itemInSlot = Quantum.Server.Inventory.GetSlotItem( char, index )

	if( itemInSlot != nil ) then
		if( itemInSlot[2] < stacksize ) then
			rest = rest - ( stacksize - itemInSlot[2] )
			Quantum.Server.Inventory.SetSlotItem( char, index, itemid, stacksize )
		end
	end

	while( rest >= stacksize ) do
		count = count + 1
		
		if( count == 1 ) then
			if( itemInSlot != nil ) then 
				rest = rest - ( stacksize - itemInSlot[2] )
			else
				rest = rest - stacksize 
			end
			Quantum.Server.Inventory.SetSlotItem( char, index, itemid, stacksize )
		else
			index = index + 1
			itemInSlot = Quantum.Server.Inventory.GetSlotItem( char, index )

			if( itemInSlot != nil ) then
				if( itemInSlot[1] == itemid && itemInSlot[2] < stacksize ) then
					rest = rest - ( stacksize - itemInSlot[2] )
					Quantum.Server.Inventory.SetSlotItem( char, index, itemid, stacksize )
					
					if( rest <= 0 ) then 
						rest = 0
						break
					end
				end
			else
				rest = rest - stacksize
				Quantum.Server.Inventory.SetSlotItem( char, index, itemid, stacksize )
			end
		end
	end

	Quantum.Server.Inventory.SetSlotItem( char, #inv + 1, itemid, rest ) 
end

function Quantum.Server.Inventory.GiveItem( pl, itemid, amount ) -- Quantum.Server.Inventory.GiveItem( Entity(1), "test2", 21 )
	local char = Quantum.Server.Char.GetCurrentCharacter( pl )
	local inv = Quantum.Server.Char.GetInventory( char )
	local item = Quantum.Item.Get( itemid )

	if( item == nil ) then Quantum.Error( "Tried to give " .. tostring(pl) .. " a non-existent item! Item '" .. tostring(itemid) .. "' does not exist." ) return end

	if( #inv + 1 <= Quantum.Inventory.Width * Quantum.Inventory.Height || Quantum.Server.Inventory.FindStackable( char, item ) != nil ) then
		
		sortItem( char, itemid, amount )
		-- send net message to client about item update 
	else
		Quantum.Debug( "Tried to give " .. tostring(pl) ..  " a item but their inventory is full!" )
	end
end