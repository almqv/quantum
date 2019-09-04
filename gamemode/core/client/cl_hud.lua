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
		print( lasthp, LocalPlayer():Health() )
		if( LocalPlayer():Health() ~= lasthp ) then
			lasthp = Lerp( 0.5, lasthp, hp )
		end

		-- Health border
		surface.SetDrawColor( 0, 0, 0, 200 )
		surface.DrawRect( sw/2 - barW/2, sh*0.9, barW, barH )
		
		-- Health
		surface.SetDrawColor( 168, 62, 50, 255 )
		surface.DrawRect( (sw/2 - barW/2) + padding/2, (sh*0.9) + padding/2, barW - padding, barH - padding )
	end

end