-- This plugin was made by AlmTech and comes with the master branch of Quantum

-- This plugin creates items for all of the weapons in the game using "weapons.GetList"
-- https://wiki.garrysmod.com/page/weapons/GetList

-- Feel free to remove it if you do not like it or to make your own.

local plugin = {}

function plugin.getAllWeaponID()
	local returnTbl = {}
	for _, wep in pairs( weapons.GetList() ) do
		if( wep.ClassName != "weapon_base" && wep.ClassName != "quantum_hands" && wep.ClassName != "quantum_keys" ) then -- do not want them
			returnTbl[ #returnTbl + 1 ] = wep.ClassName
		end
	end

	return returnTbl
end

function plugin.CreateItems( weps )
	for _, wepID in pairs( weps ) do
		local swepTbl = weapons.Get( wepID ) 
		Quantum.Item.Create( wepID, {
			name = swepTbl.PrintName , 
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