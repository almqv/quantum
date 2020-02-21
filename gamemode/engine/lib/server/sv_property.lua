--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

Quantum.Server.Property = {}

Quantum.Server.Property.Properties = {}

function Quantum.Server.Property.Register( propid, tbl )
	if( Quantum.Server.Property.Properties[propid] == nil ) then
		local prop = {
			name = tbl.name || "Private Property",
			id = propid,
			owner = nil,
			vec1 = tbl.vec1,
			vec2 = tbl.vec2,
			price = tbl.price || Quantum.Server.DefualtPropertyPrice
		}
		prop.zone = Quantum.Server.Zone.Register( propid .. "_zone", { -- register the zone for the property
			name = prop.name, 
			vec1 = prop.vec1, 
			vec2 = prop.vec2
		} )

		Quantum.Server.Property.Properties[propid] = prop
		return prop
	else
		Quantum.Error( "Property id '" .. propid ..  "' already exists! Aborting..." )
	end
end

function Quantum.Server.Property.Get( propid ) return Quantum.Server.Property.Properties[propid] end

-- Player functions --

function Quantum.Server.Property.SetOwner( propid, charid )
	Quantum.Server.Property.Properties[propid].owner = charid
end

hook.Add( "Move", "Quantum_Move_Property_CheckInZone", function( ply, mv ) 
	if( ply.isloaded ) then
		if( mv:GetVelocity() != Vector( 0, 0, 0 ) ) then
			local zone = Quantum.Server.Zone.GetCurrentZone( ply:GetPos() )
			if( zone != nil ) then
				ply:ChatPrint( zone.name )
			end
		end
	end
end)

-- Door functions --

function Quantum.Server.Property.LockDoor( ent )
	if( ent:GetClass() ) then -- doors/door_locked2.wav

	end
end