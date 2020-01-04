--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

Quantum.Client.InventoryNet = {}

Quantum.Inventory.Size = Quantum.Inventory.Width * Quantum.Inventory.Height

function Quantum.Client.InventoryNet.SetItem( index, itemid, amount )
	if( Quantum.Client.Inventory == nil ) then Quantum.Client.Inventory = {} end

	if( amount >= 1 ) then
		Quantum.Client.Inventory[index] = { itemid, amount }
	else
		Quantum.Client.Inventory[index] = nil
	end
end

local intcodeFunctions = {
	[Quantum.IntCode.SET_ITEM] = Quantum.Client.InventoryNet.SetItem
}

net.Receive( "quantum_item_action", function( len, pl ) -- used for updating the players inventory on the client
	local intcode = net.ReadInt( Quantum.IntCode.BIT_SIZE )

	-- Parameters
	local index = net.ReadInt( Quantum.calculateNeededBits( Quantum.Inventory.Size ) ) 
	local itemid = net.ReadString()
	local amount = net.ReadInt( Quantum.calculateNeededBits( Quantum.Inventory.MaxStackSize ) ) 

	intcodeFunctions[intcode]( index, itemid, amount )
end)

net.Receive( "quantum_char_update", function( len, pl ) 
	Quantum.Client.Inventory = net.ReadTable() || {}
	Quantum.Client.Character = net.ReadTable()
	Quantum.Debug( "Updated character." )
end)

function Quantum.Client.InventoryNet.DropItem( itemid, index, amount )
	if( !index ) then Quantum.Error( "Error: index=nil" ) return end
	net.Start( "quantum_item_action" )
		Quantum.WriteIntcode( Quantum.IntCode.DROP_ITEM )
		net.WriteInt( index, Quantum.calculateNeededBits( Quantum.Inventory.Size ) )
		net.WriteString( itemid )
		net.WriteInt( amount, Quantum.calculateNeededBits( Quantum.Inventory.MaxStackSize ) )
	net.SendToServer()
end

function Quantum.Client.InventoryNet.UseItem( index )
	local item = Quantum.Client.Inventory[index]
	local itemTbl = Quantum.Item.Get( item[1] )
	if( itemTbl != nil && item[2] > 0 ) then
		if( itemTbl.usefunction != nil ) then

			Quantum.Client.InventoryNet.SetItem( index, item[1], item[2] - 1 ) -- remove one from the inventory on the client 

			net.Start( "quantum_item_action" )
				Quantum.WriteIntcode( Quantum.IntCode.USE_ITEM )
				net.WriteInt( index, Quantum.calculateNeededBits( Quantum.Inventory.Size ) )
			net.SendToServer()

		end
	end
end

function Quantum.Client.InventoryNet.EatItem( index )
	local item = Quantum.Client.Inventory[index]
	local itemTbl = Quantum.Item.Get( item[1] )
	if( itemTbl != nil && item[2] > 0 ) then
		if( itemTbl.consumefunction != nil ) then

			Quantum.Client.InventoryNet.SetItem( index, item[1], item[2] - 1 ) -- remove one from the inventory on the client 

			net.Start( "quantum_item_action" )
				Quantum.WriteIntcode( Quantum.IntCode.EAT_ITEM )
				net.WriteInt( index, Quantum.calculateNeededBits( Quantum.Inventory.Size ) )
			net.SendToServer()

		end
	end
end