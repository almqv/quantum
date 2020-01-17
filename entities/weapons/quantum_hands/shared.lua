--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  
AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Hands"
	SWEP.Slot = 0
	SWEP.SlotPos = 0
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false

	function SWEP:DrawHUD()
		--if( self:GetOwner():IsSuperAdmin() ) then
			
			local hitpos = self:GetOwner():GetEyeTrace().HitPos
			print("dRQAW")
			local x, y, v = hitpos:ToScreen()
			local w, h = 51 * Quantum.Client.ResolutionScale, 51 * Quantum.Client.ResolutionScale
			surface.SetDrawColor( Color( 90, 90, 255, 255 ) )
			--surface.DrawRect( x, y, w, h )
			--surface.DrawRect( 10, 10, w, h )
			surface.SetTextPos( 10, 10 )
			surface.SetTextColor( Color( 200, 200, 200, 200 ) )
			surface.SetFont( "Default" )
			surface.DrawText( "Developer Mode" )
		--end
	end
end

SWEP.WorldModel = ""
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.Primary.Delay = 0.25

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""
SWEP.Secondary.Delay = 0.25

function SWEP:Initialize()
	if CLIENT || !IsValid(self:GetOwner()) then return true end
	self:SetHoldType( "normal" )
end

function SWEP:Deploy()
	--self:GetOwner():DrawWorldModel( false )
	return true
end

function SWEP:Holster()
	return true
end

function SWEP:PreDrawViewModel()
	return true
end

function SWEP:PrimaryAttack()
	if SERVER then
		local ent = self:GetOwner():GetEyeTraceNoCursor().Entity
		if( IsValid( ent ) && ent:GetPos():Distance( self:GetOwner():GetPos() ) < 100 ) then
			if ( ent:IsPlayerHolding() ) then return end
			self:GetOwner():PickupObject( ent ) 
		end
	end
	return false
end

function SWEP:SecondaryAttack() 
	return false
end

function SWEP:Reload()
	return false
end