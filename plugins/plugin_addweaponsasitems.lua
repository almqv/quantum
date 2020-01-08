-- This plugin was made by AlmTech and comes with the master branch of Quantum

-- This plugin creates items for all of the weapons in the game using "weapons.GetList"
-- https://wiki.garrysmod.com/page/weapons/GetList

-- Feel free to remove it if you do not like it or to make your own.

local plugin = {}

plugin.types = {
	pwb = "weapon_pwb",
	quantum = "quantum",
	cw = "cw",
	fas2 = "fas2",
	m9k = "m9k",
	weapon = "weapon"
}

plugin.AllowedTypes = {
	[plugin.types.pwb] = true,
	[plugin.types.weapon] = true,
	[plugin.types.quantum] = true,
	[plugin.types.cw] = true,
	[plugin.types.m9k] = true,
	[plugin.types.fas2] = true
}

local function createItemName( entclass )
	local str = string.Replace( entclass, "_", " " )

	for i, ns in pairs( plugin.types ) do
		str = string.gsub( str, ns, "" )
	end

	return string.upper( str )
end

function plugin.getAllWeaponID()
	local returnTbl = {}
	for _, ent in pairs( weapons.GetList()  ) do

		local classname = ent.ClassName
		local splitTbl = string.Split( classname, "_" )
		local entType = splitTbl[1]

		if( plugin.AllowedTypes[entType] ) then
			local wep = weapons.Get( classname )
			if( classname != "weapon_base" && classname != "quantum_hands" && classname != "quantum_keys" ) then -- do not want them
				returnTbl[ #returnTbl + 1 ] = classname
			end
		end

	end

	return returnTbl
end

function plugin.CreateItems( weps )
	for _, wepID in pairs( weps ) do
		local swepTbl = weapons.Get( wepID ) 
		local wepName = swepTbl.PrintName
		if( wepName == "Scripted Weapon" || wepName == wepID ) then 
			wepName = createItemName( wepID )
		end
		Quantum.Item.Create( wepID, {
			name = wepName, 
			desc = "A firearm." || swepTbl.Purpose,
			model = swepTbl.WorldModel,
			rarity = Quantum.Rarity.Weapon, 
			equipslot = Quantum.EquipSlots.Weapon,
			equipgive = wepID
		} )
	end
end

hook.Add( "PostGamemodeLoaded", "Quantum_Plugin_AddAllWeaponsAsItems", function() 
	local weps = plugin.getAllWeaponID()
	plugin.CreateItems( weps )
end)

local weps = plugin.getAllWeaponID()
plugin.CreateItems( weps )