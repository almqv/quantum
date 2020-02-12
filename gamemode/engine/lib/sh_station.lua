--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

Quantum.Station = {}

Quantum.Stations = {}

function Quantum.Station.Add( id, tbl )

	local returnTbl = {
		stationid = id,
		name = tbl.name || "Crafting Station", -- name of the station
		model = tbl.model || "models/props_phx/facepunch_barrel.mdl",
		showname = tbl.showname,
		recipes = tbl.recipes 
	}

	Quantum.Stations[ id ] = returnTbl 

	return returnTbl
end

function Quantum.Station.Get( id )
	return Quantum.Stations[id]
end	

function Quantum.Station.GetRecipes( id )
	return Quantum.Stations[id].recipes
end

if SERVER then
	Quantum.Server.Station = {} 
	Quantum.Server.Stations = {}
	Quantum.Server.Stations.Locations = {}

	function Quantum.Server.Station.Spawn( stationid, pos, ang ) -- internal function
		local ent = ents.Create( "q_crafting_station" )
		if( IsValid( ent ) ) then
			ent:InitializeStation( stationid, pos, ang )
			ent:Spawn()
		end
	end

	local function floorVectorString( vec )
		return tostring(math.floor( vec.x )) .. ", " .. tostring(math.floor( vec.y )) .. ", " .. tostring(math.floor( vec.z ))
	end

	function Quantum.Server.Station.Register( stationid, vec, angle )
		if( Quantum.Server.Stations.Locations == nil ) then 
			Quantum.Error( "Station tbl is nil" )
		end

		if( Quantum.Station.Get( stationid ) == nil ) then 
			Quantum.Error( "The station id is not valid! (" .. tostring( #Quantum.Server.Stations.Locations + 1 ) .. ")" ) 
		end

		Quantum.Debug( "Registering station '" .. tostring( stationid ) .. "' (" .. tostring(#Quantum.Server.Stations.Locations + 1) .. ")" )
		Quantum.Server.Stations.Locations[#Quantum.Server.Stations.Locations + 1] = {
			id = stationid,
			pos = vec,
			ang = angle
		}
	end
	
	function Quantum.Server.Station.Create( id, tbl )
		local stationTbl = Quantum.Station.Get( id )
	
		if( stationTbl != nil ) then
			Quantum.Server.Station.Spawn( id, tbl.pos, tbl.ang )
		end
	end

	function Quantum.Server.Station.SpawnAllRegistered()
		for i, station in pairs( Quantum.Server.Stations.Locations ) do
			Quantum.Server.Station.Create( station.id, { pos = station.pos, ang = station.ang } )
		end
	end

	function Quantum.Server.Station.Remove( station )
		if( IsValid( station ) ) then
			station:Remove()	
		end
	end

	function Quantum.Server.Station.RemoveAll()
		for i, station in pairs( ents.FindByClass( "q_crafting_station" ) ) do
			Quantum.Server.Station.Remove( station )
		end
	end

	function Quantum.Server.Station.UpdateAll()
		Quantum.Debug( "Updating station locations..." )
		Quantum.Server.Station.RemoveAll() -- remove all stations on lua refresh
		Quantum.Server.Station.SpawnAllRegistered() -- and create new ones
	end

	hook.Add( "PlayerInitialSpawn", "Quantum_Init_Stations_Load", function()  
		Quantum.Debug( "Spawning registered crafting stations..." )
		
		if( #player.GetAll() == 1 ) then -- spawn the stations when the first player joins
			Quantum.Server.Station.SpawnAllRegistered()
			Quantum.Server.StationsSpawned = true
		end
	end)

	hook.Add( "KeyRelease", "Quantum_Station_KeyRelease", function( pl, key ) 
		if( pl.isloaded ) then
			if( key == IN_USE ) then
				local ent = pl:GetEyeTraceNoCursor().Entity
				if( ent:GetClass() == "q_crafting_station" ) then
					local stationTbl = Quantum.Station.Get( ent.stationid )

					if( stationTbl != nil ) then
						if( stationTbl.recipes != nil ) then
							if( ent:GetPos():Distance( pl:GetPos() ) <= 100 ) then
								pl:SetLocalVelocity( Vector( 0, 0, 0 ) ) 
								Quantum.Net.OpenMenu( pl, "crafting", { stationEnt = ent, station = ent.stationid } )
							end
						end
					end
				end
			end
		end
	end)
end