--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

Quantum.Client.InventoryNet = {}

local function calculateNeededBits( n ) return math.ceil( math.log( n, 2 ) ) end

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

net.Receive( "quantum_item_action", function( len, pl ) 
	local intcode = net.ReadInt( Quantum.IntCode.BIT_SIZE )

	-- Parameters
	local index = net.ReadInt( calculateNeededBits( Quantum.Inventory.Size ) ) 
	local itemid = net.ReadString()
	local amount = net.ReadInt( calculateNeededBits( Quantum.Inventory.MaxStackSize ) ) 

	intcodeFunctions[intcode]( index, itemid, amount )
end)