--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

local enabledHUDs = {
	["CHudChat"] = true,
	["CHudGMod"] = true
}

hook.Add( "HUDShouldDraw", "Quantum_RemoveDefualtHUD", function( hudid ) 
	return enabledHUDs[hudid] ~= nil
end)


local scale = Quantum.Client.ResolutionScale
local barW, barH = 250 * scale, 10 * scale
local padding = 2 * scale
local sw, sh = ScrW(), ScrH()

function GM:HUDPaint()
	local hp = LocalPlayer():Health()
	local lasthp = hp
	local maxhp = LocalPlayer():GetMaxHealth()
	
	if( Quantum.Client.Config.EnableHUD ) then
		if !LocalPlayer():Alive() then return end

		-- Health border
		surface.SetDrawColor( 0, 0, 0, 200 )
		surface.DrawRect( sw/2 - barW/2, sh*0.9, barW, barH )
		
		-- Health
		surface.SetDrawColor( 168, 62, 50, 255 )
		surface.DrawRect( ( sw/2 - barW/2 ) + padding/2, (sh*0.9) + padding/2, math.Clamp( (barW - padding) * hp/maxhp, 0, barW - padding ), barH - padding )

		-- Text
		surface.SetFont( "q_HUD" )
		surface.SetTextColor( 255, 255, 255, 255 )
		local hptxt = tostring( 100 * (hp/maxhp) .. "%" )
		local txtW, txtH = surface.GetTextSize( hptxt )
		surface.SetTextPos( ( ( sw/2 - txtW/2 ) + padding/2 ), ( ( sh*0.9 - txtH/2 ) ) )
		surface.DrawText( hptxt )

	end

end

hook.Add( "RenderScreenspaceEffects", "Quantum_HUD_RenderLowHealth", function() 
	DrawColorModify( {
		[ "$pp_colour_addr" ] = 0,
		[ "$pp_colour_addg" ] = 0,
		[ "$pp_colour_addb" ] = 0,
		[ "$pp_colour_brightness" ] = Lerp( LocalPlayer():Health() / LocalPlayer():GetMaxHealth(), -0.75, 0 ),
		[ "$pp_colour_contrast" ] = Lerp( LocalPlayer():Health() / LocalPlayer():GetMaxHealth(), 0.6, 1 ),
		[ "$pp_colour_colour" ] = Lerp( LocalPlayer():Health() / LocalPlayer():GetMaxHealth(), 0.2, 1 ),
		[ "$pp_colour_mulr" ] = 0,
		[ "$pp_colour_mulg" ] = 0,
		[ "$pp_colour_mulb" ] = 0
	} )
	if( LocalPlayer():Health() / LocalPlayer():GetMaxHealth() <= 0.15 ) then DrawMotionBlur( 0.4, 0.8, 0.1 ) end
end)
