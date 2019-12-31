--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

Quantum.Item = {}
Quantum.Items = {}

function Quantum.Item.Create( itemid, args )
	local item = {
		id = itemid,
		name = args.name || "ERROR", -- items name
		desc = args.desc || "ERROR: Some idiot forgot to give this item a description.", -- items description
		model = args.model || "models/props_phx/gears/bevel12.mdl", -- items model
		stack = args.stack || 1, -- items max stack size
		soulbound = args.soulbound, -- if item could be dropped/traded to other players
		equipable = args.equipable, -- equipable or not
		rarity = args.rarity || Quantum.Rarity.Trash, -- rarity of the item
		usefunction = args.usefunction, -- use function 
		consumefunction = args.consumefunction --consume function
	}
	math.Clamp( item.stack, 1, Quantum.Inventory.MaxStackSize ) -- clamp it so it does not go over the max size
	Quantum.Items[itemid] = item
	return item
end

function Quantum.Item.Get( id )
	return Quantum.Items[id]
end