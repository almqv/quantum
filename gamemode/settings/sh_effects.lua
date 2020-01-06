--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  


Quantum.Effect.Create( "eat_potatoe", {
	title = "Potatoe Powers",
	desc = "Gives you 1000 health for 10 seconds.",
	rarity = Quantum.Rarity.Legendary,
	duration = 10,
	startfunc = function( pl )
		pl:SetHealth( 1000 )
	end,
	stopfunc = function( pl )
		pl:SetHealth( pl:GetMaxHealth() )
	end
} )

Quantum.Effect.Create( "eat_trash", {
	title = "Bad Health",
	desc = "You die.",
	rarity = Quantum.Rarity.Trash,
	startfunc = function( pl )
		pl:Kill()
	end
} )