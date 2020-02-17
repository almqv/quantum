--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

Quantum.Server.Zone = {}

Quantum.Server.Zone.Zones = {} -- all zones are rectangles where they go from vec1 to vec2

function Quantum.Server.Zone.Register( zoneid, tbl )
	if( Quantum.Server.Zone.Zones[zoneid] == nil ) then
		local zone = {
			name = tbl.name || "Unknown Zone",
			id = zoneid,
			vec1 = tbl.vec1,
			vec2 = tbl.vec2
		}

		Quantum.Server.Zone.Zones[zoneid] = zone
		return zone
	else
		Quantum.Error( "Zone id '" .. zoneid ..  "' already exists! Aborting..." )
	end
end

function Quantum.Server.Zone.Get( zoneid )
	return Quantum.Server.Zone.Zones[zoneid]
end

function Quantum.Server.Zone.IsInZone( vec, zoneid, zone )
	zone = zone || Quantum.Server.Zone.Get( zoneid )
	return vec:WithinAABox( zone.vec1, zone.vec2 )
end

function Quantum.Server.Zone.GetCurrentZone( vec )
	for i, zone in pairs( Quantum.Server.Zone.Zones ) do
		if( Quantum.Server.Zone.IsInZone( vec, nil, zone ) ) then
			return zone
		end
	end
end