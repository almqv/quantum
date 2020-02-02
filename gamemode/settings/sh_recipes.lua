--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  


Quantum.Recipe.Add( "potatoe", "barrel", {
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

Quantum.Recipe.Add( "test2", "barrel", { 
	name = "Test2 Recipe",
	amount = 5,
	delay = 5,
	recipe = {
		{ item = "potatoe", amount = 1 }
	}
})

Quantum.Recipe.Add( "m9k_colt1911", "barrel", { 
	name = "Colt 1911",
	amount = 1,
	delay = 5,
	recipe = {
		{ item = "test2", amount = 5 }
	}
})

Quantum.Recipe.Add( "jetpack", "barrel", { 
	name = "A Jet Engine & Duct Tape",
	amount = 1,
	delay = 5,
	recipe = {
		{ item = "test2", amount = 5 }
	}
})
