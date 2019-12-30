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
		icon = args.icon, -- items icon
		stack = args.stack || false, -- items max stack size
		soulbound = args.soulbound || true, -- if item could be dropped/traded to other players
		rarity = args.rarity || Quantum.Rarity.Trash, -- rarity of the item
		usefunction = args.usefunction, -- use function 
		consumefunction = args.consumefunction, --consume function
		equipfunction = args.equipfunction -- equip function
	}
end