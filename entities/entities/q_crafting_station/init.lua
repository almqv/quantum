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

function ENT:InitializeStation( stationid, pos, ang )
	if( pos == nil || ang == nil ) then return end

	local stationTbl = Quantum.Station.Get( stationid )

	if( stationTbl != nil ) then
		self:SetModel( stationTbl.model )
		self.stationid = stationid 

		self:SetNWString( "q_station_id", stationid )

		self:SetPos( pos )
		self:SetAngles( ang )
	else
		Quantum.Error( "Station Table could not be found '" .. stationid .. "'!" )
		self:Remove()
	end
end