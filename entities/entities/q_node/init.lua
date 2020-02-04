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

function ENT:InitializeNode( nodeid, pos, ang )
	if( pos == nil || ang == nil ) then return end

	local nodeTbl = Quantum.node.Get( nodeid )

	if( nodeTbl != nil ) then
		self:SetModel( nodeTbl.model )
		self.nodeid = nodeid

		self:SetNWString( "q_node_id", nodeid )

		self:SetPos( pos )
		self:SetAngles( ang )
	else
		Quantum.Error( "Node Table could not be found '" .. nodeid .. "'!" )
		self:Remove()
	end
end