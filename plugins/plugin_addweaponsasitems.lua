-- This plugin was made by AlmTech and comes with the master branch of Quantum

-- This plugin creates items for all of the weapons in the game using "weapons.GetList"
-- https://wiki.garrysmod.com/page/weapons/GetList

-- Feel free to remove it if you do not like it or to make your own.

local plugin = {}

plugin.AllowedTypes = {
	["fas2"] = true,
	["weapon"] = true,
	["quantum"] = true,
	["cw"] = true
}

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
		Quantum.Debug( "Added " .. wepID .. " as an item!" )
		Quantum.Item.Create( wepID, {
			name = swepTbl.PrintName, 
			desc = swepTbl.Purpose,
			model = swepTbl.WorldModel,
			rarity = Quantum.Rarity.Common, 
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