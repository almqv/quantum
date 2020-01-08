--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

Quantum.Client.Holster = {} 

local holsterBind = Quantum.Bind.HolsterMain
local holsterTime = Quantum.HolsterTime

local client

local function getItemFromInv( pos )
	return Quantum.Client.Inventory[pos]
end

local function getCurEquippedWeapon()
	local item = getItemFromInv(Quantum.Client.Equipped[ Quantum.EquipSlots.Weapon ])
	local itemTbl = Quantum.Item.Get( item[1] )

	if( itemTbl != nil ) then
		return itemTbl.equipgive
	end
end

function Quantum.Client.Holster.SwitchHolster()
	client = LocalPlayer()

	if( client:GetActiveWeapon():GetClass() != "quantum_hands" ) then
		local curWep= getCurEquippedWeapon()
		if( curWep != nil && curWep != "quantum_hands" ) then
			local wepEnt = client:GetWeapon( curWep )
			client:SelectWeapon( client:GetWeapon( curWep ) )
		else
			client:SelectWeapon( client:GetWeapon( "quantum_hands" ) )
		end
	end
end

local startTime

function Quantum.Client.Holster.CheckBind()
	if( Quantum.Client.Equipped != nil ) then
		if( input.IsKeyDown( holsterBind ) ) then
			if( startTime == nil ) then startTime = CurTime() end

			if( CurTime() - startTime >=  holsterTime ) then
				Quantum.Client.Holster.SwitchHolster()
				startTime = nil
			end
		else
			startTime = nil
		end
	end
end

hook.Add( "Think", "Quantum_Client_Holster_Hook", function() 
	-- if( !Quantum.Client.IsInMenu ) then
	-- 	Quantum.Client.Holster.CheckBind()
	-- end
end)