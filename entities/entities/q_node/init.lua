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
 
	self:PhysicsInit( SOLID_BSP )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetCollisionGroup( COLLISION_GROUP_NONE  )

	local physObj = self:GetPhysicsObject()
	if( IsValid( physObj ) ) then
		physObj:EnableMotion( false ) -- dont want it to move
	end

end

function ENT:OnTakeDamage( dmgInfo )
	if( !self.m_bApplyingDamage ) then

		self:SetHealth( self:Health() - dmgInfo:GetDamage() )
		if( self:Health() <= 0 ) then
			Quantum.Node.Remove( self ) 
		end
		print( self:Health(), dmgInfo:GetDamage() )

		local attacker = dmgInfo:GetAttacker()
		local wep = attacker:GetActiveWeapon()
		if( IsValid( wep ) && IsValid( attacker ) ) then
			Quantum.Node.Gather( attacker, wep:GetClass(), self )
		end

	end
end