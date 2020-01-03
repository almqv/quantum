--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  


if SERVER then

	local keyfuncs = {
		["mainMenu"] = function( pl )
			Quantum.Net.OpenMenu( pl, "main", { chars = Quantum.Server.Char.GetPlayerChars_cl( pl ), resume = true } )
		end
	}

	function GM:KeyRelease( ply, key )
		if( keyfuncs[key] ) then keyfuncs[key]( ply ) end
	end

	function GM:ShowHelp( ply )
		keyfuncs["mainMenu"]( ply )
	end
	
end