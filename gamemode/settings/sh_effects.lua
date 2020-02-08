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

Quantum.Effect.Create( "equip_potatoe", {
	title = "Potatoe Powers",
	desc = "Increases your max health by 100 and\nheales you with 5 health every second.",
	rarity = Quantum.Rarity.Legendary,
	startfunc = function( pl )
		pl:SetMaxHealth( pl:GetMaxHealth() + 100 )

		pl.runtimeEffect_timerActive_equip_potatoe = false
	end,
	runtimefunc = function( pl )
		if( IsValid( pl ) ) then
			if( !pl.runtimeEffect_timerActive_equip_potatoe ) then
				pl.runtimeEffect_timerActive_equip_potatoe = true
				timer.Simple( 1, function() 
					pl:SetHealth( math.Clamp( pl:Health() + 5, 1, pl:GetMaxHealth() ) )
					pl.runtimeEffect_timerActive_equip_potatoe = false
				end)
			end
		end
	end,
	stopfunc = function( pl )
		pl:SetMaxHealth( math.Clamp( pl:GetMaxHealth() - 100, 1, pl:GetMaxHealth() ) )
		pl.runtimeEffect_timerActive_equip_potatoe = nil
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

Quantum.Effect.Create( "test_chest", {
	title = "Protective Shield",
	desc = "You gain 100 armor while the chestpiece is on.",
	rarity = Quantum.Rarity.Rare,
	startfunc = function( pl )
		pl:SetArmor( 100 )
	end,
	stopfunc = function( pl )
		pl:SetArmor( 0 )
	end
} )