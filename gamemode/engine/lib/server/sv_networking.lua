--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

Quantum.Net = {}
util.AddNetworkString( "quantum_menu_net" )
util.AddNetworkString( "quantum_menu_button_net" )
util.AddNetworkString( "quantum_item_action" )

local function checkCacheTable( ply, cache_id, dt )
	Quantum.Debug( "Checking cache tables (" .. tostring(ply) .. " | " .. tostring(cache_id) .. " | " .. tostring(dt) .. ")" )
	local datatable = dt || {}
	if( ply.cache == nil ) then 
		Quantum.Error( tostring(ply) .. " does not have a cache table, creating..." )
		ply.cache = {} 
		if( ply.cache ~= nil ) then Quantum.Debug( "Success! Created cache table for " .. tostring(ply) ) end
	else
		if( ply.cache[cache_id] == nil ) then
			Quantum.Debug( tostring(ply) .. " does not have a cache for '" .. tostring(cache_id) .. "'. Creating..." )
			ply.cache[cache_id] = {
				id = cache_id,
				cache = datatable
			}
			if( ply.cache[cache_id] ~= nil && table.Count( ply.cache[cache_id] ) == 1 ) then
				Quantum.Debug( "Success! Created cache '" .. tostring(cache_id) .. "' for " .. tostring(ply) .. "." )
				if( ply.cache[id].count == nil ) then ply.cache[id].count = 1 else ply.cache[id].count = ply.cache[id].count + 1 end -- keep count
			else
				Quantum.Error( "Failed. Creation of cache '" .. tostring(cache_id) .. "' for " .. tostring(ply) .. " failed to validate or did not get created." )
				ply.cache[cache_id] = nil -- remove the cache since it is "broken"
			end
		end
	end
	return ply.cache[cache_id]
end

local function CacheDatatableMethod( id, datatable, ply )
	ply.cache[id] = checkCacheTable( ply, id, datatable ) -- check caching tables etc
	Quantum.Debug( "(" .. tostring(ply) .. " | " .. tostring(id) .. ") Removing known data in cache from datatable..." )
	if( ply.cache[id] ~= nil ) then
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
	end
	--datatable.id = id -- give it the id so that the client side could handle it
	-- Always give the id since it is highly "valuable".
	-- Don't want the client mixing up the NPC, which this caching system could do if not handled correctly.
	return { id = id, cont = datatable }
end

local function initializeDatatable( id, datatable, ply )
	Quantum.Debug( "(" .. tostring(ply) .. ") Initializing datatable for client net message.." )
	return CacheDatatableMethod( id, datatable, ply ) 
end

local function SendDatatableToClient( client, dt, type )
	local datatable = initializeDatatable( type, dt, client ) -- before we actually send the stuff, cache it and remove unneeded stuff
	local net_start = net.Start( "quantum_menu_net" )
		if( net_start ) then Quantum.Debug( "Sending net message to " .. tostring(client) .. "..." ) end
		if( table.Count(datatable) > 0 ) then -- if it's empty just dont send it because we will save 8 bits 
			net.WriteTable( datatable ) -- send the data to the player
		end
	net.Send( client )
	Quantum.Debug("Net message sent.")
end

function Quantum.Net.OpenMenu( pl, type, dt )
	SendDatatableToClient( pl, dt, type )
end

local funcs = {
	["createChar"] = true,
	["enterWorldChar"] = true
}

local netfuncs = {
	createChar = function( pl, args )
		pl.charcount = Quantum.Server.Char.GetCharCount( pl ) 
		if( #args.name > 16 ) then 
			Quantum.Debug( "Player " .. tostring( pl ) .. " character name too long. Unable to create." )
			return
		elseif( pl.charcount + 1 > Quantum.CharacterLimit ) then -- character limit
			Quantum.Debug( "Player " .. tostring( pl ) .. " tried to exceed their character limit." )
			return 
		end
		Quantum.Server.Char.Load( pl, pl.charcount + 1, args )
	end,
	enterWorldChar = function( pl, args )
		Quantum.Server.Char.SetCurrentCharacter( pl, args.index )
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


Quantum.Net.Inventory = {}

local function WriteIntcode( intcode ) net.WriteInt( intcode, Quantum.IntCode.BIT_SIZE ) end

function Quantum.Net.Inventory.SendItem( pl, index, itemid, amount ) -- sends a item to the client with amount of it, this is a DYNAMIC networking solution
	net.Start( "quantum_item_action" )
		WriteIntcode( Quantum.IntCode.SEND_ITEM )
		net.WriteInt( index, 8 )
	net.Send( pl )
end