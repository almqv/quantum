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
		if( self:GetOwner():IsSuperAdmin() ) then
			surface.SetTextPos( 10, 10 )
			surface.SetTextColor( Color( 200, 200, 200, 200 ) )
			surface.SetFont( "Default" )
			surface.DrawText( "Developer Mode" )

			surface.SetTextPos( 10, 25 )
			surface.DrawText( "Hitpos: " .. tostring( self:GetOwner():GetEyeTrace().HitPos ) )

			surface.SetTextPos( 10, 40 )
			surface.DrawText( "Angle: " .. tostring( self:GetOwner():GetAngles() ) )
		end
	end
	
	local cubeMat = Material( "vgui/white" )

	hook.Add( "PostDrawOpaqueRenderables", "Quantum_Client_DeveloperHands_HitPos", function() 
		if( LocalPlayer():IsSuperAdmin() ) then
			local trace = LocalPlayer():GetEyeTrace()
			local angle = trace.HitNormal:Angle()

			render.SetMaterial( cubeMat )
			render.DrawBox( trace.HitPos, Angle( 0, 0, 0), Vector( 0, 0, 0 ), Vector( 2, 2, 2 ), Color( 255, 255, 255 ) )
			
			render.DrawLine( trace.HitPos, trace.HitPos + 8 * angle:Forward(), Color( 255, 0, 0 ), true )
			render.DrawLine( trace.HitPos, trace.HitPos + 8 * -angle:Right(), Color( 0, 255, 0 ), true )
			render.DrawLine( trace.HitPos, trace.HitPos + 8 * angle:Up(), Color( 0, 0, 255 ), true )

		end
	end)
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

local function translateVector( pre, vec )
	return pre .. "( " .. tostring(vec.x) .. ", " .. tostring(vec.y) .. ", " .. tostring(vec.z) .. " )"
end

function SWEP:PrimaryAttack()
	if SERVER then
		local ent = self:GetOwner():GetEyeTraceNoCursor().Entity
		if( IsValid( ent ) && ent:GetPos():Distance( self:GetOwner():GetPos() ) < 100 ) then
			if ( ent:IsPlayerHolding() ) then return end
			self:GetOwner():PickupObject( ent ) 
		end
	else
		if( LocalPlayer():IsSuperAdmin() ) then
			Quantum.Debug( "--Hitpos Data--" )
			print( translateVector( "Vector", LocalPlayer():GetEyeTrace().HitPos ) )
			print( translateVector( "Angle", LocalPlayer():GetAngles() ) )
		end
	end
	return false
end

function SWEP:SecondaryAttack() 
	if CLIENT then
		if( LocalPlayer():IsSuperAdmin() ) then
			Quantum.Debug( "--Camera Data--" )
			print( translateVector( "Vector", LocalPlayer():GetPos() ) )
			print( translateVector( "Angle", LocalPlayer():GetAngles() ) )
		end
	end
	return false
end

function SWEP:Reload()
	return false
end