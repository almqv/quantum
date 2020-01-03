--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

AddCSLuaFile( "cl_init.lua" ) 
AddCSLuaFile( "shared.lua" ) 
 
include( "shared.lua" )
 
function ENT:Initialize()
 
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON  )

	local phys = self:GetPhysicsObject()
	if( phys:IsValid() ) then phys:Wake() end

end
 
local useStartTime
local useDelay = Quantum.ItemPickupTime

function ENT:Use( activator, caller )
	-- FIX reset start time POST use
	if( activator:IsPlayer() ) then
		if( self.itemid != nil && self.amount != nil ) then
			useStartTime = useStartTime || CurTime()

			if( CurTime() - useStartTime >= useDelay ) then
				useStartTime = nil
				self:Remove()
				-- add item to players inventory
				Quantum.Server.Inventory.GiveItem( activator, self.itemid, self.amount )
				Quantum.Notify.ItemPickup( activator, Quantum.Item.Get( self.itemid ), self.amount ) -- notify the player
				self:EmitSound( Quantum.Server.Settings.ItemPickupSound ) -- make a pickup sound
			end
		end
	end
end

function ENT:InitializeItem( itemid, amount )
	self:SetModel( Quantum.Item.Get( itemid).model )
	self.itemid = itemid
	self.amount = amount

	self:SetNWString( "q_item_id", itemid )
	self:SetNWInt( "q_item_amount", amount )
end