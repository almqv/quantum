--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

Quantum.Effect = {} -- lib

Quantum.Effects = {} -- container for all of the effects

function Quantum.Effect.Create( effectid, tbl )
	local effect = {
		id = effectid,
		icon = tbl.icon,
		rarity = tbl.rarity || Quantum.Rarity.Common,
		duration = tbl.duration || -1
		func = {
			start = tbl.startfunc || Quantum.EmptyFunction,
			runtime = tbl.runtimefunc || Quantum.EmptyFunction,
			stop = tbl.stopfunc || Quantum.EmptyFunction
		}
	}
	Quantum.Effects[effectid] = effect
	return effect
end

function Quantum.Effect.Get( effectid ) return Quantum.Effects[effectid] end

if SERVER then -- server only functions

	function Quantum.Effect.AddRuntimeFunction( pl, effectid )
		pl.effecthooks = pl.effecthooks || {}
		local effectTbl = Quantum.Effect.Get( effectid )

		if( effectTbl != nil ) then

			local hookID = "Quantum_Effects_RunTime_" .. tostring(pl) .. "_" .. tostring(effectid)
			pl.effecthooks[ #pl.effecthooks + 1 ] = hookID

			Quantum.Debug( "Adding runtime effect hook: " .. hookID )

			hook.Add( "Think", hookID, function() 
				effectTbl.func.runtime( pl )
			end)

		end
		
	end

	function Quantum.Effect.RemoveRuntimeFunction( pl, effectid )
		local hookID = "Quantum_Effects_RunTime_" .. tostring(pl) .. "_" .. tostring(effectid)
		Quantum.Debug( "Removing runtime effect hook: " .. hookID )
		hook.Remove( "Think", hookID )
	end

	function Quantum.Effect.RemoveAllRuntimeFunctions( pl )
		if( pl.effecthooks != nil ) then
			Quantum.Debug( "Removing all runtime hooks for " .. tostring(pl) .. "." )
			for n, hookid in pairs( pl.effecthooks ) do
				Quantum.Effect.RemoveRuntimeFunction( pl, hookid )
			end
		end
	end

	function Quantum.Effect.Remove( pl, effectid )
		local effectTbl = Quantum.Effect.Get( effectid )
		local char = Quantum.Server.Char.GetCurrentCharacter( pl )

		if( effectTbl != nil ) then
			Quantum.Effect.RemoveRuntimeFunction( pl, effectid )
			pl.effects[effectid] = nil
			effectTbl.func.stop( pl ) -- run the end function
		end
	end

	function Quantum.Effect.Give( pl, effectid )
		local effectTbl = Quantum.Effect.Get( effectid )
		local char = Quantum.Server.Char.GetCurrentCharacter( pl )

		if( effectTbl != nil ) then
			if( effectTbl.func.start != nil && effectTbl.func.start != Quantum.EmptyFunction ) 
				effectTbl.func.start( pl )
			end

			if( effectTbl.func.runtime != nil && effectTbl.func.runtime != Quantum.EmptyFunction ) then
				Quantum.Effect.AddRuntimeFunction( pl, effectid )
			end

			if( effectTbl.duration > 0 ) then 
				timer.Simple( effectTbl.duration, function() 
					Quantum.Effect.Remove( pl, effectid ) -- remove the effect from the player after its duration is over
				end)
			end
		end
	end
end