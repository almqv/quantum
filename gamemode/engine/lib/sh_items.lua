--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

Quantum.Item = {}
Quantum.Items = {}

function Quantum.Item.Create( itemid, args )
	local item = {
		id = itemid,
		name = args.name || "ERROR", -- items name
		desc = args.desc || "ERROR: Some idiot forgot to give this item a description.", -- items description
		model = args.model || "models/props_phx/gears/bevel12.mdl", -- items model
		stack = args.stack || 1, -- items max stack size
		soulbound = args.soulbound, -- if item could be dropped/traded to other players
		equipslot = args.equipslot, -- slot for the equipable
		equipgive = args.equipgive,
		equipeffect = args.equipeffect, -- equip buff like in other MMO RPG games
		rarity = args.rarity || Quantum.Rarity.Trash, -- rarity of the item
		useeffect = args.useeffect, -- use effect
		consumeeffect = args.consumeeffect --consume effect
	}
	item.stack = math.Clamp( item.stack, 1, Quantum.Inventory.MaxStackSize ) -- clamp it so it does not go over the max size
	if( item.equipslot != nil ) then item.stack = 1 end -- make the stack size to 1 if equipable
	Quantum.Items[itemid] = item
	return item
end

function Quantum.Item.Get( id )
	return Quantum.Items[id]
end

if SERVER then
	Quantum.Server.Item = {}
	function Quantum.Server.Item.SpawnItem( pos, itemid, amount )
		if( pos == nil || itemid == nil || amount == nil ) then return end

		if( Quantum.Item.Get( itemid ) != nil ) then
			local itemEnt = ents.Create( "q_item" )

			if( IsValid( itemEnt ) ) then

				itemEnt:SetPos( pos  )
				itemEnt:InitializeItem( itemid, amount )
				itemEnt:Spawn()

				timer.Simple( math.Clamp( Quantum.Server.Settings.ItemDespawnTimer, 1, 600 ), function()
					if( IsValid( itemEnt ) ) then
						Quantum.Debug( "Despawned item " .. tostring(itemEnt) .. " [" .. itemEnt.itemid .. "]" )
						itemEnt:Remove()
					end
				end)
				
			end
		end
	end

	function Quantum.Server.Item.SpawnItemAtPlayer( pl, itemid, amount ) -- Quantum.Server.Item.SpawnItemAtPlayer( Entity(1), "potatoe", 1 ) 
		Quantum.Server.Item.SpawnItem( pl:GetPos() + ( pl:GetForward() * 40 ) + Vector( 0, 0, 40 ), itemid, amount )
	end
end