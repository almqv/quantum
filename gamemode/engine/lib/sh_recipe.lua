--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

Quantum.Recipe = {}

Quantum.Recipes = {}

function Quantum.Recipe.Add( itemid, station, tbl )
	if( Quantum.Item.Get( itemid ) == nil ) then return end

	local returnTbl = {
		name = tbl.name || "Secret Recipe" -- name of the recipe
		station = station,
		creates = itemid -- what the recipe creates
		amount = tbl.amount -- how much you get from 1 craft
		recipe = tbl.recipe || {}
	}

	Quantum.Recipes[ itemid ] = returnTbl

	return returnTbl
end

function Quantum.Recipe.Get( itemid )
	return Quantum.Recipes[itemid]
end	

function Quantum.Recipe.GetAvailableAmountForReq( recipe, pos, inv )
	if( inv != nil ) then
		return Quantum.Server.Inventory.GetItemAmount( nil, recipe[pos].item, inv )
	end
end

function Quantum.Recipe.GetNeededAmountForReq( recipe, pos, inv )
	if( inv != nil ) then
		return Quantum.Recipe.GetAvailableAmountForReq( recipe, pos, inv ) - recipe[pos].amount
	end
end

local function canMakeReq( diff ) return diff >= 0 end

function Quantum.Recipe.CanMake( inv, itemid )
	if( inv != nil && itemid != nil ) then

		local recipeTbl = Quantum.Recipe.Get( itemid )
		local rTbl = recipeTbl.recipe

		local canMake = {}
		local failedReq = {}

		for i, req in pairs( rTbl ) do
			canMake[i] = canMakeReq( Quantum.Recipe.GetNeededAmountForReq( rTbl, i, inv ) )
			if( !canMake[i] ) then
				failedReq[i] = req.item
			end
		end

		return #failedReq <= 0, failedReq

	end
end

function Quantum.Recipe.MakeItem( pl, itemid )
	local recipe = Quantum.Recipe.Get( itemid )
	local char = Quantum.Server.Char.GetCurrentCharacter( pl )
	local inv = Quantum.Server.Char.GetInventory( char )

	if( recipe != nil ) then
		local canMake, failedReq = Quantum.Recipe.CanMake( inv, itemid )

		if( canMake ) then
			-- create item
		else
			-- Dont make the item
			return
		end
	end
end