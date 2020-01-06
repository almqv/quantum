--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

Quantum.Item.Create( "test", {
	name = "Test Item", 
	desc = "This is a test item!\nDoes not stack.",
	model = "models/props_phx/gears/bevel12.mdl",
	soulbound = true, 
	rarity = Quantum.Rarity.Rare, 
	equipslot = Quantum.EquipSlots.Chest
} )

Quantum.Item.Create( "test2", {
	name = "Trash Item Test", 
	desc = "This is literall trash\nLine breaker test :D\n\nTest :D",
	model = "models/props_phx/gears/bevel12.mdl",
	stack = 10, 
	soulbound = false, 
	rarity = Quantum.Rarity.Trash, 
	consumeeffect = "eat_trash"
} )

Quantum.Item.Create( "bomb", {
	name = "WW2 Bomb", 
	desc = "Not a real item but okay.",
	model = "models/props_phx/ww2bomb.mdl",
	stack = 2, 
	soulbound = false, 
	rarity = Quantum.Rarity.Epic
} )

Quantum.Item.Create( "potatoe", {
	name = "Legendary Potatoe", 
	desc = "The most legendary potatoe in existance. Don't eat it!",
	model = "models/props_phx/misc/potato.mdl",
	stack = 1, 
	soulbound = false, 
	rarity = Quantum.Rarity.Legendary,
	equipslot = Quantum.EquipSlots.Head,
	consumeeffect = "eat_potatoe"
} )