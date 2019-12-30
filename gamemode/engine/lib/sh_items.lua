--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

Quantum.Item = {}
Quantum.Items = {}

function Quantum.Item.Create( id, args )
	local item = {
		name = args.name || "ERROR", -- items name
		desc = args.desc || "ERROR: Some idiot forgot to give this item a description.", -- items description
		model = args.model || "models/props_phx/gears/bevel12.mdl", -- items model
		stack = args.stack || false, -- items max stack size
		soulbound = args.soulbound || true, -- if item could be dropped/traded to other players
		equipable = args.equipable || false, -- equipable or not
		rarity = args.rarity || Quantum.Rarity.Trash, -- rarity of the item
		usefunction = args.usefunction, -- use function 
		consumefunction = args.consumefunction --consume function
	}
	Quantum.Items[id] = item
	return item
end

function Quantum.Item.Get( id )
	return Quantum.Items[id]
end