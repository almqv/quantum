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
local barW, barH = 400 * scale, 25 * scale
local radius = 1.05 * scale
local padding = 5 * scale
local sw, sh = ScrW(), ScrH()

local function SetAlpha( color, alpha )
	return Color( color.r, color.g, color.b, alpha )
end

local function renderStatHUD()
	local hp = LocalPlayer():Health()
	local lasthp = hp
	local maxhp = LocalPlayer():GetMaxHealth()

	-- Health border
	surface.SetDrawColor( 0, 0, 0, 200 )
	surface.DrawRect( sw/2 - barW/2, sh*0.9, barW, barH )

	-- Health bar
	surface.SetDrawColor( 168, 62, 50, 255 )
	surface.DrawRect( ( sw/2 - barW/2 ) + padding/2, (sh*0.9) + padding/2, math.Clamp( (barW - padding) * hp/maxhp, 0, barW - padding ), barH - padding )

	-- Health Text
	surface.SetFont( "q_HUD" )
	surface.SetTextColor( 255, 255, 255, 255 )
	local hptxt = tostring( 100 * (hp/maxhp) .. "%" )
	local txtW, txtH = surface.GetTextSize( hptxt )
	surface.SetTextPos( ( ( sw/2 - txtW/2 ) + padding/2 ), ( ( sh*0.9 - txtH/3 ) ) )
	surface.DrawText( hptxt )

	-- Crosshair
	if( Quantum.Client.ShowCrosshair ) then
		surface.SetDrawColor( 255, 255, 255, 200 )
		surface.DrawRect( sw/2 - radius, sh/2 - radius, radius*2, radius*2 )
	end
end

local function renderItemInfoHUD()
	local trace = LocalPlayer():GetEyeTraceNoCursor() 
	local entsNear = ents.FindInSphere( LocalPlayer():GetPos(), Quantum.ItemInfoDisplayMaxDistance )

	for i, ent in pairs( entsNear ) do
		if( ent:GetClass() == "q_item" ) then
			local distance = LocalPlayer():GetPos():Distance( ent:GetPos() )
			local distFrac = Lerp( distance/Quantum.ItemInfoDisplayMaxDistance, 1, 0 )
	
			if( distance <= Quantum.ItemInfoDisplayMaxDistance ) then
				local item = Quantum.Item.Get( ent:GetNWString( "q_item_id" ) ) || { name = "", rarity = { txt = "", color = Color( 0, 0, 0, 0 ) } }
				local amount = ent:GetNWInt( "q_item_amount" ) || 1
	
				local pos = ent:GetPos()
				pos.z = pos.z + 20
	
				local screenPos = pos:ToScreen()
	
				local txtPadding = 20 * scale
				local itemAmountTxt = ""
				if( amount > 1 ) then itemAmountTxt = amount .. "x " end
	
				local alphaFrac = distFrac
	
	
				draw.SimpleText( itemAmountTxt .. item.name, "q_item_hud_title", screenPos.x, screenPos.y, SetAlpha( item.rarity.color, 255 * alphaFrac ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				draw.SimpleText( "Rarity: " .. item.rarity.txt, "q_item_hud_rarity", screenPos.x, screenPos.y + txtPadding, SetAlpha( item.rarity.color, 255 *alphaFrac ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				if( item.soulbound ) then
					draw.SimpleText( "Soulbound", "q_item_hud_soulbound", screenPos.x, screenPos.y + txtPadding*2, Color( 235, 64, 52, 255 * alphaFrac ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end
			end
		end
	end
end

local handle

local function renderCharNamesHUD()
	local trace = LocalPlayer():GetEyeTraceNoCursor() 
	

	local entsNear = ents.FindInSphere( LocalPlayer():GetPos(), Quantum.CharInfoDisplayDistance )

	for i, ent in pairs( entsNear ) do
		if( ent:IsPlayer() && ent != LocalPlayer() ) then
			local distance = LocalPlayer():GetPos():Distance( ent:GetPos() )
			local distFrac = Lerp( distance/Quantum.CharInfoDisplayDistance, 1, 0 )
			
			if( distance <= Quantum.CharInfoDisplayDistance ) then
				handle = util.GetPixelVisibleHandle() 
				local pixelVis = util.PixelVisible( ent:GetPos(), 20, handle )
				print( ent:Nick(), pixelVis, ent:GetPos() )
				--if( util.PixelVisible( ent:GetPos(), 5, handle ) > 0  ) then
					local name = ent:GetNWString( "q_char_name" )
					local pos = ent:GetPos()
					pos.z = pos.z + 75
				
					local screenPos = pos:ToScreen()
		
					local txtPadding = 20 * scale
					local alphaFrac = distFrac
				
			
					draw.SimpleText( name, "q_char_hud_name", screenPos.x, screenPos.y, Color( 225, 225, 225, 255 * distFrac ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				--end
			end
		end
	end

	-- local ent = trace.Entity
	-- if( ent:IsPlayer() ) then
	-- 	local distance = LocalPlayer():GetPos():Distance( ent:GetPos() )
	-- 	local distFrac = Lerp( distance/Quantum.CharInfoDisplayDistance, 1, 0 )
	
	-- 	if( distance <= Quantum.CharInfoDisplayDistance ) then
	-- 		local name = ent:GetNWString( "q_char_name" )
	-- 		local pos = ent:GetPos()
	-- 		pos.z = pos.z + 20
	
	-- 		local screenPos = pos:ToScreen()

	-- 		local txtPadding = 20 * scale
	-- 		local alphaFrac = distFrac
	

	-- 		draw.SimpleText( name, "q_char_hud_name", screenPos.x, screenPos.y, Color( 225, 225, 225, 255 * distFrac ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	-- 	end
	-- end
end

local showRarities = {
	[Quantum.Rarity.Rare] = true,
	[Quantum.Rarity.Epic] = true,
	[Quantum.Rarity.Legendary] = true
}

local function renderHaloAroundItems()
	for i, item in pairs( ents.FindByClass( "q_item" ) ) do
		local itemid = item:GetNWString( "q_item_id" )
		local itemTbl = Quantum.Item.Get(itemid) || { rarity = Quantum.Rarity.Rare }

		if( itemTbl != nil ) then
			if( showRarities[itemTbl.rarity] ) then
				halo.Add( { item }, SetAlpha( itemTbl.rarity.color, 255 ), 0, 0, 2, true, false )
			end
		end
	end
end

hook.Add( "PreDrawHalos", "Quantum_Item_Halos", function() 
	renderHaloAroundItems()
end)

function GM:HUDPaint()
	if( LocalPlayer():IsValid() ) then
		if( !Quantum.Client.IsInMenu ) then
			if( !LocalPlayer():Alive() ) then 
				surface.SetDrawColor( 0, 0, 0, 255 )
				surface.DrawRect( 0, 0, sw, sh )
			end
			
			if( Quantum.Client.Config.EnableHUD ) then
				if( LocalPlayer():Alive() ) then
					renderStatHUD()
					renderItemInfoHUD()
					renderCharNamesHUD()
				end
			end
		end
	end
end

function GM:Think()
	if( Quantum.Client.IsInMenu ) then
		if( gui.IsGameUIVisible() ) then gui.HideGameUI() end -- hides the main menu for the player

		if( !LocalPlayer():Alive() ) then
			if( IsValid( Quantum.Client.CurMenu ) ) then 
				Quantum.Client.CurMenu:Close() -- closes the current open menu on death
			end
		end
	end
end

hook.Add( "RenderScreenspaceEffects", "Quantum_HUD_RenderLowHealth", function() 
	if( !Quantum.Client.IsInMenu ) then
		if( LocalPlayer():Health() / LocalPlayer():GetMaxHealth() <= 0.25 ) then 
			DrawMotionBlur( 0.4, 0.8, 0.1 ) 
			DrawColorModify( {
				[ "$pp_colour_addr" ] = 0,
				[ "$pp_colour_addg" ] = 0,
				[ "$pp_colour_addb" ] = 0,
				[ "$pp_colour_brightness" ] = Lerp( LocalPlayer():Health() / LocalPlayer():GetMaxHealth(), -0.25, 0 ),
				[ "$pp_colour_contrast" ] = Lerp( LocalPlayer():Health() / LocalPlayer():GetMaxHealth(), 0.2, 1 ),
				[ "$pp_colour_colour" ] = Lerp( LocalPlayer():Health() / LocalPlayer():GetMaxHealth(), 0.8, 1 ),
				[ "$pp_colour_mulr" ] = 0,
				[ "$pp_colour_mulg" ] = 0,
				[ "$pp_colour_mulb" ] = 0
			} )
		end
	end
end)
