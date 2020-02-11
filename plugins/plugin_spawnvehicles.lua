-- This plugin was made by AlmTech and comes with the master branch of Quantum

-- You may remove this if you want.
if SERVER then
	local plugin = {}
	plugin.vechilesTypes = {
		["jeep"] = function( pos, ang )
			local ent = simfphys.SpawnVehicleSimple( "sim_fphys_jeep", pos, ang )
			return ent
		end,
		["duke"] = function( pos, ang )
			local ent = simfphys.SpawnVehicleSimple( "sim_fphys_dukes", pos, ang )
			return ent
		end,
		["couch"] = function( pos, ang )
			local ent = simfphys.SpawnVehicleSimple( "sim_fphys_couch", pos, ang )
			return ent
		end,
		["heli"] = function( pos, ang )
			local ent = ents.Create( "wac_hc_littlebird_mh6" )
			if( !IsValid(ent) ) then
				Quantum.Error( "Failed to create WAC helicopter" )
				return
			end
			ent:SetPos( pos )
			ent:SetAngles( Angle( 0, 0, 0 ) )

			ent:Spawn()
			ent:Activate()

			return ent
		end
	}

	function plugin.spawnvehicle( ply, type )

		if( IsValid( ply.vehicle ) ) then 
			Quantum.Notify.Deny( ply, "You already have a vehicle spawned! Remove it by typing: /remve" )
		else
			if( plugin.vechilesTypes[type] != nil ) then
				local spawnpos = ply:GetPos() + Vector( 110, 0, 50 )

				ply.vehicle = plugin.vechilesTypes[type]( spawnpos, Angle( 0, 0, 0) )
			else
				Quantum.Notify.Deny( ply, "That is not a valid vehicle ID!" )
			end
		end
		
	end

	function plugin.delvehicle( ply )
		if( IsValid( ply.vehicle ) ) then
			ply.vehicle:Remove()
		end
	end

	local function runChatCMD( ply, txt )
		local tbl = string.Split( txt, " " )
		if( tbl[1] == "/spawn" ) then
			if( tbl[2] != nil ) then
				print( "yes")
				plugin.spawnvehicle( ply, tbl[2] )
				return ""
			else
				Quantum.Notify.Deny( ply, "Please input a vehicle type. Example: /spawn couch" )
				return ""
			end
		elseif( tbl[1] == "/remve" ) then
			plugin.delvehicle( ply )
			ply:ChatPrint( "Deleted vehicle." )
			return ""
		end
	end

	hook.Add( "PlayerSay", "Quantum_Plugin_SpawnVehicles_ChatCMD", function( ply, txt, tchat ) 
		runChatCMD( ply, txt )
	end)
end