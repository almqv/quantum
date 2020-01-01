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
	if( amount < 1 ) then 
		char.inventory[pos] = nil -- remove the item
		return 
	end
	local item = Quantum.Item.Get( itemid )
	if( isEquippable( item ) || !isStackable( item ) ) then 
		amount = 1
		char.inventory[pos] = { itemid }
	else
		amount = amount || 1
		char.inventory[pos] = { itemid, amount }
	end
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

function Quantum.Server.Inventory.FindItemSpot( char )
	local inv = Quantum.Server.Char.GetInventory( char )
	local pos = 0

	local item
	for ii = 1, Quantum.Inventory.Width * Quantum.Inventory.Height, 1 do 
		item = inv[ii]
		if( item == nil ) then 
			pos = ii
			break
		end
	end
	return pos
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
		if( itemInSlot[1] == itemid && itemInSlot[2] < stacksize ) then

			local add = itemInSlot[2] + amount
			if( add > stacksize ) then
				rest = rest - ( stacksize - itemInSlot[2] )
			else
				rest = rest - amount
			end
			local setAmt = math.Clamp( add, 1, stacksize )
			Quantum.Server.Inventory.SetSlotItem( char, index, itemid, setAmt )

		end
	else
		local setAmt = math.Clamp( amount, 1, stacksize )
		local pos = Quantum.Server.Inventory.FindItemSpot( char )
		rest = rest - setAmt
		Quantum.Server.Inventory.SetSlotItem( char, pos, itemid, setAmt )
	end

	while( rest >= stacksize ) do
		count = count + 1
		
		if( count == 1 ) then
			local setAmt = math.Clamp( amount, 1, stacksize )

			if( itemInSlot != nil ) then 
				setAmt = math.Clamp( itemInSlot[2] + amount, 1, stacksize )
			end

			rest = rest - setAmt

			local pos = Quantum.Server.Inventory.FindItemSpot( char )
			Quantum.Server.Inventory.SetSlotItem( char, pos, itemid, setAmt )
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

	local stackIndex = Quantum.Server.Inventory.FindStackable( char, item )
	local pos 
	if( stackIndex == nil ) then
		pos = Quantum.Server.Inventory.FindItemSpot( char )
		Quantum.Server.Inventory.SetSlotItem( char, pos, itemid, rest ) 
	else
		if( rest > 0 ) then
			pos = stackIndex
			itemInSlot = Quantum.Server.Inventory.GetSlotItem( char, pos )

			local setAmt = math.Clamp( itemInSlot[2] + rest, 1, stacksize )
			local diff = ( itemInSlot[2] + rest ) - setAmt
			rest = rest - diff

			if( rest <= 0 ) then
				Quantum.Server.Inventory.SetSlotItem( char, pos, itemid, setAmt ) 
			end
		end
	end
end

function Quantum.Server.Inventory.GiveItem( pl, itemid, amount ) -- Quantum.Server.Inventory.GiveItem( Entity(1), "test2", 21 )
	local char = Quantum.Server.Char.GetCurrentCharacter( pl ) -- Quantum.Server.Inventory.GiveItem( Entity(1), "test", 1 )
	local inv = Quantum.Server.Char.GetInventory( char )
	local item = Quantum.Item.Get( itemid )

	if( item == nil ) then Quantum.Error( "Tried to give " .. tostring(pl) .. " a non-existent item! Item '" .. tostring(itemid) .. "' does not exist." ) return end

	if( #inv + 1 <= Quantum.Inventory.Width * Quantum.Inventory.Height || Quantum.Server.Inventory.FindStackable( char, item ) != nil ) then
		
		sortItem( char, itemid, amount )
		-- Quantum.Debug( "Gave " .. char.name .. " " .. amount .. "x [" .. item.name .. "]" )
		-- Send net message to client about item update 
		-- ############################################
		-- ############################################
		-- ############################################
		-- ############################################
	else
		Quantum.Debug( "Tried to give " .. tostring(pl) ..  " a item but their inventory is full!" )
	end
end

function Quantum.Server.Inventory.DropItem( pl, index, amount ) -- Quantum.Server.Inventory.DropItem( Entity(1), 1, 9 )
	local char = Quantum.Server.Char.GetCurrentCharacter( pl ) -- Quantum.Server.Inventory.DropItem( Entity(1), 4, 1 )
	local inv = Quantum.Server.Char.GetInventory( char )

	if( inv[index] != nil ) then
		local itemid = inv[index][1] 

		local item = Quantum.Item.Get( itemid )

		if( item.soulbound == true ) then 
			Quantum.Notify.Deny( pl, "You can not drop that item!" )
			return 
		end -- players cant drop soulbound items

		local am_diff = inv[index][2] - amount

		if( am_diff >= 0 ) then -- drop the item from the players inv
			-- remove the items am_diff from its stack
			Quantum.Server.Inventory.SetSlotItem( char, index, itemid, am_diff )

			-- spawn the item infront of the player
			local itemEnt = ents.Create( "q_item" )
			if( IsValid( itemEnt ) ) then
				itemEnt:SetModel( item.model )
				itemEnt:SetPos( pl:GetPos() )
				itemEnt.amount = amount
				itemEnt.itemid = itemid
				itemEnt:Spawn()

				timer.Simple( math.Clamp( Quantum.Server.Settings.ItemDespawnTimer, 1, 600 ), function()
					if( IsValid( itemEnt ) ) then
						Quantum.Debug( "Despawned item " .. tostring(itemEnt) .. " [" .. itemEnt.itemid .. "]" )
						itemEnt:Remove()
					end
				end)
			end
		end
	else
		Quantum.Error( "Player " .. tostring( pl ) .. " tried to drop a something from index=" .. tostring(index) .. " where there exists no item." )
	end
end