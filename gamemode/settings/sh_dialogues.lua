--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  


---- CREATE DIALOGUE INSTANCES UNDER THIS LINE ----
Quantum.Dialogue.Create( "npc_generalvendor" )

	Quantum.Dialogue.AddQuestion( "npc_generalvendor", "init", "What do you want? I don't have time for any shenanigans right now!" )

		Quantum.Dialogue.AddResponse( "npc_generalvendor", "init", {
			text = "To do business.",
			newqID = "sellorbuy",
			func = function()
				print("You pressed this response!")
			end
		}, 1 )
		
		Quantum.Dialogue.AddResponse( "npc_generalvendor", "init", {
			text = "To take all of your money! Aaaaa aaaa a  aa a a a aa  aa a  aa a a a  aa  aa a a a a aaaaaaaaaaaaaaaaa a a a a aa a a a a  aa  a aa a  aa a a a aaaa a a aa a aa aa aa!"

		}, 2 )

	Quantum.Dialogue.AddQuestion( "npc_generalvendor", "sellorbuy", "What do you have in mind?" )
		
		Quantum.Dialogue.AddResponse( "npc_generalvendor", "sellorbuy", {
			text = "What do you have for sale?",
			func = function()
				print("You pressed this response! BUY")
			end
		}, 1 )

		Quantum.Dialogue.AddResponse( "npc_generalvendor", "sellorbuy", {
			text = "I would like to sell some things.",
			func = function()
				print("You pressed this response! SELL")
			end
		}, 2 )
