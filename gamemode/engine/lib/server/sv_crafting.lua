--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

Quantum.Server.Crafting = {}


local function setPlayerIsCrafting( pl, iscrafting, delay )
	pl.iscrafting = iscrafting
	pl:SetNWBool( "Quantum_Craft_IsCrafting", iscrafting )

	if( delay ) then
		pl:SetNWInt( "Quantum_Craft_IsCrafting_Delay", delay ) -- a bit expensive but it should do the trick
	else
		pl:SetNWInt( "Quantum_Craft_IsCrafting_Delay", 0 )
	end
end

local function isPlayerCrafting( pl ) 
	return pl.iscrafting
end

local function cancelCrafting( pl ) 
	if( timer.Exists( "Quantum_Crafting_" .. pl:SteamID64() ) ) then
		timer.Stop( "Quantum_Crafting_" .. pl:SteamID64() )
		setPlayerIsCrafting( pl, false )
		if( pl.craftSound != nil ) then
			pl.craftSound:Stop()
		end
	end
end

function Quantum.Server.Crafting.MakeItem( pl, itemid )

	local recipe = Quantum.Recipe.Get( itemid )
	local char = Quantum.Server.Char.GetCurrentCharacter( pl )
	local inv = Quantum.Server.Char.GetInventory( char )

	if( recipe != nil ) then

		local canMake, failedReq = Quantum.Recipe.CanMake( inv, itemid )

		if( canMake ) then
			
			cancelCrafting( pl ) -- stop the crafting if the player is allready crafting something

			-- and then craft this item instead
			setPlayerIsCrafting( pl, true )

			pl.craftSound = CreateSound( pl, "physics/cardboard/cardboard_box_scrape_rough_loop1.wav" )

			if( isPlayerCrafting( pl ) ) then
				pl.craftSound:Play()
				pl.craftSound:ChangeVolume( 0.2 )

				timer.Create( "Quantum_Crafting_" .. pl:SteamID64(), recipe.delay, 1, function() 
					-- remove the ingridients from the players inv
					Quantum.Server.Inventory.FindItemSlots( pl, itemid, inv )

					for k, reqItem in pairs( recipe.recipe ) do

						-- get items
						local slots = Quantum.Server.Inventory.FindItemSlots( pl, reqItem.item, inv )
						local itemCount = 0
						-- loop through all slots and remove them
						for i, slot in pairs( slots ) do
							if( itemCount < reqItem.amount ) then 
								itemCount = itemCount + inv[slot][2]
								Quantum.Server.Inventory.RemoveSlotItem( pl, char, slot, inv[slot][2] )
							end

							if( i >= #slots ) then local itemCount = 0 end
						end
					end
		
					-- create item

					Quantum.Server.Inventory.GiveItem( pl, recipe.creates, recipe.amount )
					Quantum.Notify.ItemCrafted( pl, Quantum.Item.Get( recipe.creates ), recipe.amount )
					setPlayerIsCrafting( pl, false ) -- when everything is done then set this to false

					pl.craftSound:Stop()
					pl:EmitSound( Quantum.Server.Settings.ItemPickupSound ) -- make a sound on craft
				end)

			end

		else
			-- Dont make the item
			Quantum.Notify.Deny( pl, "You don not have sufficient resources to create that item!" )
		end
	end
end

local function isMoving( vec )
	return vec.x != 0 || vec.y != 0 || vec.z != 0
end

hook.Add( "Move", "Quantum_Crafting_Velocity_Stop", function( ply, mv ) -- a hook to check if the player is moving when crafting
	if( ply.isloaded ) then
		if( isMoving( mv:GetVelocity() ) ) then
			if( isPlayerCrafting( ply ) ) then 
				cancelCrafting( ply )  -- if so then make the player stop crafting
			end
		end
	end
end)
