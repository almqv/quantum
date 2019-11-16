--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  


if SERVER then

	local keyfuncs = {
		["openCharMenu"] = function( pl )
			Quantum.Net.OpenMenu( pl, "character", Quantum.Server.Char.GetPlayerChars_cl( pl ) )
		end,
		["mainMenu"] = function( pl )
			Quantum.Net.OpenMenu( pl, "main", Quantum.Server.Char.GetPlayerChars_cl( pl ) )
		end
	}

	function GM:KeyRelease( ply, key )
		if( keyfuncs[key] ) then keyfuncs[key]( ply ) end
	end
	function GM:ShowHelp( ply ) keyfuncs["openCharMenu"]( ply ) end
	function GM:ShowTeam( ply ) keyfuncs["mainMenu"]( ply ) end
	
end