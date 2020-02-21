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

	local devmode = GetConVar( "developer" )
	function SWEP:DrawHUD()
		if( devmode:GetBool() == true && !Quantum.Client.IsInMenu ) then
			surface.SetTextPos( 10, 150 )
			surface.SetTextColor( Color( 200, 200, 200, 200 ) )
			surface.SetFont( "Default" )
			surface.DrawText( "Developer Mode" )

			surface.SetTextPos( 10, 165 )
			surface.DrawText( "Hitpos: " .. tostring( self:GetOwner():GetEyeTrace().HitPos ) )

			surface.SetTextPos( 10, 180 )
			surface.DrawText( "Angle: " .. tostring( self:GetOwner():GetAngles() ) )
		end
	end
	
	local cubeMat = Material( "vgui/white" )

	hook.Add( "PostDrawOpaqueRenderables", "Quantum_Client_DeveloperHands_HitPos", function() 
		if( devmode:GetBool() == true && !Quantum.Client.IsInMenu ) then
			if( IsValid( LocalPlayer():GetActiveWeapon() ) ) then
				if( LocalPlayer():GetActiveWeapon():GetClass() == "quantum_hands" ) then
					local trace = LocalPlayer():GetEyeTrace()
					local angle = trace.HitNormal:Angle()

					render.SetMaterial( cubeMat )
					render.DrawBox( trace.HitPos, Angle( 0, 0, 0), Vector( 0, 0, 0 ), Vector( 2, 2, 2 ), Color( 255, 25, 25, 100 ) )
					
					render.DrawLine( trace.HitPos, trace.HitPos + 12 * angle:Forward(), Color( 255, 0, 0 ), true )
					render.DrawLine( trace.HitPos, trace.HitPos + 12 * -angle:Right(), Color( 0, 255, 0 ), true )
					render.DrawLine( trace.HitPos, trace.HitPos + 12 * angle:Up(), Color( 0, 0, 255 ), true )
				end
			end
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
SWEP.Secondary.Delay = 0.75

function SWEP:Initialize()
	self:SetHoldType( "normal" )
end

function SWEP:Deploy()
	if( CLIENT || !IsValid(self:GetOwner()) ) then return true end
	self:GetOwner():DrawWorldModel( false )
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
		local devmode = GetConVar( "developer" )
		if( devmode:GetBool() == true ) then
			LocalPlayer():ChatPrint( "Check console for output.\n" )
			Quantum.Debug( "--Hitpos Data--" )
			print( translateVector( "Vector", LocalPlayer():GetEyeTrace().HitPos ) )
			print( translateVector( "Angle", LocalPlayer():GetAngles() ) )
		end
	end
end

function SWEP:SecondaryAttack() 

	if SERVER then
		local hitposEnt = self:GetOwner():GetEyeTraceNoCursor().Entity
		if( Quantum.DoorClasses[hitposEnt:GetClass()] && IsValid(hitposEnt) ) then -- if it is a door
			if( hitposEnt:GetPos():Distance(self:GetOwner():GetPos()) <= 90 ) then
				Quantum.Property.PlayerSwitchLock( self:GetOwner(), hitposEnt ) -- then try to unlock/lock it
			end
		end
	end

	if CLIENT then
		local devmode = GetConVar( "developer" )
		if( devmode:GetBool() == true ) then
			LocalPlayer():ChatPrint( "Check console for output.\n" )
			Quantum.Debug( "--Camera Data--" )
			print( translateVector( "Vector", LocalPlayer():GetBonePosition( LocalPlayer():LookupBone( "ValveBiped.Bip01_Head1" ) ) ) )
			print( translateVector( "Angle", LocalPlayer():GetAngles() ) )
		end
	end
end

function SWEP:Reload()
	return false
end