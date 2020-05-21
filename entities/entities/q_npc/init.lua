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
	self:SetCollisionGroup( COLLISION_GROUP_NONE )
	self:SetModel("models/kleiner.mdl") -- mingebad model :)

	local physObj = self:GetPhysicsObject()
	if( IsValid( physObj ) ) then
		physObj:EnableMotion( false ) 
	end

end