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
 
	self:SetModel( "models/props_phx/gears/bevel12.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	local phys = self:GetPhysicsObject()
	if( phys:IsValid() ) then phys:Wake() end

end
 
function ENT:Use( activator, caller )
	if( activator:IsPlayer() ) then
		if( self.itemid != nil && self.amount != nil ) then
			self:Remove()
			-- add item to players inventory
			Quantum.Server.Inventory.GiveItem( activator, self.itemid, self.amount )
			Quantum.Notify.ItemPickup( activator, Quantum.Item.Get( self.itemid ), self.amount ) -- notify the player
			self:EmitSound( Quantum.Server.Settings.ItemPickupSound ) -- make a pickup sound
		end
	end
end
