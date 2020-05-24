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
	self:CapabilitiesAdd( CAP_ANIMATEDFACE )
	self:CapabilitiesAdd( CAP_TURN_HEAD )
	self:SetUseType( SIMPLE_USE )

	self:SetSequence(self:SelectWeightedSequence(ACT_IDLE))

	self:DropToFloor()
end

function ENT:Use( activator, caller )
	if( self.node != nil ) then
		if( self.node.dialogueID ) then
			-- open up dialogue menu
			Quantum.Net.OpenMenu(activator, "dialogue", { ent = self, dialogueID = self.node.dialogueID })
		end
		if( #self.node.voiceLines > 0 ) then
			self:EmitSound(self.node.voiceLines[math.random(1, #self.node.voiceLines)]) -- emit a voiceline
		end
	end
end

function ENT:OnTakeDamage( dmgInfo )
	if( !self.m_bApplyingDamage ) then
		if( self.node != nil ) then
			if( #self.node.damageSounds > 0 ) then
				self:EmitSound( self.node.damageSounds[math.random(1, #self.node.damageSounds)] )
			end
		end
	end
end