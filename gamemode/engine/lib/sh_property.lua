--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

Quantum.Property = {}

Quantum.Property.Properties = {}

function Quantum.Property.Register( propid, tbl )
	if( Quantum.Property.Properties[propid] == nil ) then
		local prop = {
			name = tbl.name || "Private Property",
			id = propid,
			owner = nil,
			vec1 = tbl.vec1,
			vec2 = tbl.vec2,
			price = tbl.price || Quantum.DefualtPropertyPrice
		}

		prop.zone = Quantum.Zone.Register( propid .. "_property", { -- register the zone for the property
			name = prop.name, 
			vec1 = prop.vec1, 
			vec2 = prop.vec2,
			property = propid
		} )

		Quantum.Property.Properties[propid] = prop
		return prop
	else
		Quantum.Error( "Property id '" .. propid ..  "' already exists! Aborting..." )
	end
end

function Quantum.Property.Get( propid ) return Quantum.Property.Properties[propid] end

-- Player functions --

function Quantum.Property.SetOwner( propid, charid )
	Quantum.Property.Properties[propid].owner = charid
end

hook.Add( "Move", "Quantum_Move_Property_CheckInZone", function( ply, mv ) -- DEBUG REMOVE LATER
	if( ply.isloaded ) then
		if( mv:GetVelocity() != Vector( 0, 0, 0 ) ) then
			local zone = Quantum.Zone.GetCurrentZone( ply:GetPos() )
			if( zone != nil ) then
				ply:ChatPrint( zone.name )
			end
		end
	end
end)

-- Door functions --

function Quantum.Property.LockDoor( ent )
	if( Quantum.DoorClasses[ent:GetClass()] && IsValid( ent ) ) then 
		ent:Fire( "lock", "", 0 )
		ent:EmitSound( Quantum.DoorSounds.Lock )
		ent.islocked = true
	end
end

function Quantum.Property.UnlockDoor( ent )
	if( Quantum.DoorClasses[ent:GetClass()] && IsValid( ent ) ) then 
		ent:Fire( "unlock", "", 0 )
		ent:EmitSound( Quantum.DoorSounds.Unlock )
		ent.islocked = false
	end
end

function Quantum.Property.SwitchLockDoor( ent )
	if( Quantum.DoorClasses[ent:GetClass()] && IsValid( ent ) ) then 
		if( ent.islocked ) then
			Quantum.Property.UnlockDoor( ent )
		else
			Quantum.Property.LockDoor( ent )
		end
	end
end

function Quantum.Property.PlayerSwitchLock( pl, doorent )
	local zone = Quantum.Zone.GetCurrentZone( pl:GetPos() )
	if( zone == nil ) then return end
	if( Quantum.Zone.DoorIsInZone(doorent, zone.id) ) then
		local prop = Quantum.Property.Get( zone.property )
		if( prop.owner == pl || pl:IsSuperAdmin() ) then
			Quantum.Property.SwitchLockDoor( doorent )
		else
			return
		end
	end
end