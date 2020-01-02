--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

Quantum.Server.Char = {}
Quantum.Server.Char.Players = {}

local function CreateCharTable( args )
	return {
		name = args.name || "UNKNOWN",
		class = Quantum.Classes[args.class] || Quantum.Classes[1],
		maxhealth = Quantum.Server.Settings.MaxHealth,
		health = args.health || Quantum.Server.Settings.MaxHealth,
		model = Quantum.Classes[args.class].Models[args.gender][args.modelIndex] || Quantum.Classes[args.class].Models[args.gender][1] || "models/player.mdl",
		money = args.money || Quantum.Server.Settings.StarterMoney,
		inventory = args.inventory || {}, -- create new inventory later
		jobs = args.jobs || {
			[1] = { title = "Unemployed", level = -1 },
		},
		skills = args.skills || {
			crafting = 0,
			cooking = 0,
			combat = 0,
			science = 0
		},
		training = args.training || {},
		licenses = args.licenses || {},
		titles = args.titles || {}
	}
end

function Quantum.Server.Char.Load( pl, index, tbl )
	local id = pl:SteamID() .. ";" .. index
	if( Quantum.Server.Char.Players[ id ] == nil ) then
		Quantum.Server.Char.Players[ id ] = CreateCharTable( tbl ) -- create the character
		Quantum.Server.Char.Players[ id ].inventory = tbl.inventory || Quantum.Server.Inventory.Create( Quantum.Server.Char.Players[ id ] ) -- give the character an inventory

		Quantum.Debug( "Created character (" .. id .. ")" )
		return Quantum.Server.Char.Players[ id ]
	else
		Quantum.Error( "Tried to duplicate character! Index already used. (" .. id .. ")" )
	end
end

function Quantum.Server.Char.Remove( pl, index )
	local id = pl:SteamID() .. ":" .. index
	if( Quantum.Server.Char.Players[ id ] ~= nil ) then
		Quantum.Server.Char.Players[ id ] = nil
		Quantum.Debug( "Removed character (" .. id .. ")" )
	end
end

function Quantum.Server.Char.GetCurrentCharacter( pl )
	if( pl.character == nil ) then Quantum.Error( tostring( pl ) .. " doesn't have a character! Unable to get current character table." ) end
	return pl.character
end

local function setupCharacter( pl, char )
	pl.isloaded = true
	pl.deathpos = nil
	pl:Spawn()
	pl:SetMaxHealth( char.maxhealth )
	pl:SetHealth( char.health )
	pl:SetModel( char.model )
end

function Quantum.Server.Char.SetCurrentCharacter( pl, index )
	local id = pl:SteamID() .. ";" .. index
	if( Quantum.Server.Char.Players[ id ] ) then 
		pl.character = Quantum.Server.Char.Players[ id ]
		pl.charindex = index
		Quantum.Net.Inventory.Update( pl ) -- update the players inventory on char change
		setupCharacter( pl, pl.character )
		return pl.character
	else
		Quantum.Error( "Unable to set " .. tostring(pl) .. " character (" .. id ..  "). Character not found!" )
		return nil
	end
end

function Quantum.Server.Char.GetPlayerChars( pl )
	local chars = {}
	local strtbl = {}
	for id, char in pairs( Quantum.Server.Char.Players ) do 
		strtbl = string.Split( id, ";" )
		if( strtbl[1] == pl:SteamID() ) then chars[id] = char end
	end
	return chars
end

function Quantum.Server.Char.GetCharCount( pl )
	return table.Count( Quantum.Server.Char.GetPlayerChars( pl ) ) || 0
end

function Quantum.Server.Char.getBasicCharInfo( char )
	return {
		name = char.name,
		model = char.model,
		class = char.class.Name,
		job = char.jobs[1],
		money = char.money
	}
end

function Quantum.Server.Char.GetPlayerChars_cl( pl )
	local chars = {}
	local count = 0
	for id, char in pairs( Quantum.Server.Char.GetPlayerChars( pl ) ) do
		count = count + 1
		chars[count] = Quantum.Server.Char.getBasicCharInfo( char )
	end
	return chars
end

function Quantum.Server.Char.GetInventory( char )
	return char.inventory
end

function Quantum.Server.Char.GetInventory_cl( char )
	local inv = Quantum.Server.Char.GetInventory( char )
	local returninv = {}

	for i, item in pairs( inv ) do returninv[i] = { id = item.id, amount = item.amount } end
	return returninv
end