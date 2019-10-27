--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

Quantum.Net = {}
util.AddNetworkString( "quantum_menu_net" )
util.AddNetworkString( "quantum_menu_button_net" )

local function CacheDatatableMethod( id, datatable, ply )
	if( ply.cache == nil ) then ply.cache = {} end 

	if( ply.cache[id] == nil ) then -- if this is the first time then create a cache record
		ply.cache[id] = {
			cache = datatable
			-- won't be defining the count here
		} 
	end 

	if( ply.cache[id].count == nil ) then ply.cache[id].count = 1 else ply.cache[id].count = ply.cache[id].count + 1 end -- keep count of how many times we have cached this datatable

	if( ply.cache[id].count > 1 ) then -- dont want to filter out data if this is the first time.
		for k, v in pairs( datatable ) do -- loop through the datatable
			for k2, v2 in pairs( table.GetKeys( ply.cache[id].cache ) ) do -- check each key with each key from the record cache
				if( tostring(k) == tostring(v2) ) then -- check if the keys are the same
					if( v == ply.cache[id].cache[tostring(v2)] ) then -- check if the value/contents are the same
						datatable[k] = nil -- if so then remove the key from the datatable
					else -- if the key's value has changed we dont remove it since the client needs to know about it
						ply.cache[id].cache[tostring(v2)] = v -- and then update the cache so we know about it next time
					end
				end
			end
		end
	end
	--datatable.id = id -- give it the id so that the client side could handle it
	-- Always give the id since it is highly "valuable".
	-- Don't want the client mixing up the NPC, which this caching system could do if not handled correctly.
	return { id = id, cont = datatable }
end

local function SendDatatableToClient( client, dt, type )
	local datatable = CacheDatatableMethod( type, dt, client ) -- before we actually send the stuff, cache it and remove unneeded stuff
	net.Start( "quantum_menu_net" )
		if( table.Count( datatable ) > 0 ) then -- if it's empty just dont send it because we will save 8 bits 
			net.WriteTable( datatable ) -- send the data to the player
		end
	net.Send( client )
end

function Quantum.Net.OpenMenu( pl, type, dt )
	SendDatatableToClient( pl, dt, type )
end

local funcs = {
	["createChar"] = true
}

local netfuncs = {
	createChar = function( pl, args )
		pl.charcount = Quantum.Server.Char.GetCharCount( pl ) 
		Quantum.Server.Char.Load( pl, pl.charcount + 1, args )
	end
}

local function runNetFunc( pl, func, args )
	if( funcs[func] ) then
		netfuncs[func]( pl, args )
	else
		Quantum.Error( tostring(pl) .. " tried to run a non existant networked function! func: '" .. tostring( func ) .. "'" )
	end
end

net.Receive( "quantum_menu_button_net", function( len, pl )
    local funcid = net.ReadString()
	local args = net.ReadTable()
	runNetFunc( pl, funcid, args )
end)
