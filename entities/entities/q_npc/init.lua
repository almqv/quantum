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
	-- just the usual npc stuff
	self:SetModel( "models/kleiner.mdl" )
	self:SetHullType( HULL_HUMAN )
	self:SetHullSizeNormal()

	self:SetNPCState( NPC_STATE_IDLE )
	self:SetSolid( SOLID_BBOX )
	self:CapabilitiesAdd( CAP_ANIMATEDFACE + CAP_TURN_HEAD )
	self:SetUseType( SIMPLE_USE )

	self:DropToFloor()
end