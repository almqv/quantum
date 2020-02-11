--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Quantum Tool"
	SWEP.Slot = 0
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.UseHands = true
SWEP.Weight = 4

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

function SWEP:Initialize()
	self:SetHoldType( "melee" )
end

function SWEP:Deploy()
	if( CLIENT || !IsValid(self:GetOwner()) ) then return true end
	self:GetOwner():DrawWorldModel( self.WorldModel != "" && self.WorldModel != nil )
	return true
end

function SWEP:Holster()
	return true
end

function SWEP:PreDrawViewModel()
	return true
end

function SWEP:PrimaryAttack()
	return
end

function SWEP:SecondaryAttack() 
	return
end

function SWEP:Reload()
	return false
end