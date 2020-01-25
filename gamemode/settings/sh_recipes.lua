--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  


Quantum.Recipe.Add( "potatoe", "barrel", { --Quantum.Server.Crafting.MakeItem( Entity(1), "potatoe" )
	name = "Legendary Potatoe Recipe",
	amount = 1,
	delay = 5,
	recipe = {
		{ item = "test2", amount = 5 },
		{ item = "test", amount = 2  }
	}
})

Quantum.Recipe.Add( "test", "barrel", { 
	name = "Test Recipe",
	amount = 2,
	delay = 5,
	recipe = {
		{ item = "potatoe", amount = 1 }
	}
})
