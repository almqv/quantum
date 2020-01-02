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

net.Receive( "quantum_item_update", function( len, pl ) 
	local dtInv = net.ReadTable()
	Quantum.Client.Inventory = dtInv || {}
	Quantum.Debug( "Updated inventory." )
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
