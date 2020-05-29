--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

local theme ={}
local scale = Quantum.Client.ResolutionScale
local padding = math.Round( 10 * scale )
local padding_s = math.Round( 4 * scale )


local blur = Material("pp/blurscreen")

function theme.renderblur( p, a, d )
	local x, y = p:LocalToScreen( 0, 0 )
	surface.SetDrawColor( 255, 255, 255 )
	surface.SetMaterial( blur )
	
	for i = 1, d do
		blur:SetFloat( "$blur", (i / d) * a )
		blur:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect( x * -1, y * -1, ScrW(), ScrH() )
	end
end

function theme.borderpanel( p, color )
	local w, h = p:GetSize()
	local clr = color || Color( 20, 20, 20, 100 )

	surface.SetDrawColor( clr )
	surface.DrawOutlinedRect( 0, 0, w, h )
end

function theme.panel( p, color )
	local w, h = p:GetSize()
	local clr = color || Color( 0, 0, 0, 200 )
	local bclr = Color( 50, 50, 50, 105 ) 

	draw.RoundedBox( 6, 0, 0, w, h, bclr ) -- border
	draw.RoundedBox( 4, padding_s/2, padding_s/2, w - padding_s, h - padding_s, clr ) -- inner
end

function theme.blurpanel( p, color )
	local w, h = p:GetSize()
	local clr = color || Color( 0, 0, 0, 200 )
	theme.renderblur( p, 2, 7 )

	surface.SetDrawColor( clr )
	surface.DrawRect( 0, 0, w, h )
end

function theme.sharpblurpanel( p, color )
	local w, h = p:GetSize()
	local clr = color || Color( 0, 0, 0, 200 )
	surface.SetDrawColor( clr )
	surface.DrawRect( 0, 0, w, h )
	theme.renderblur( p, 2, 7 )
	theme.borderpanel( p, Color( 255, 255, 255, 255 ) )
end

function theme.button( b, color )
	local w, h = b:GetSize()
	local clr = color || Color( 235, 64, 52, 255 )
	local bclr = Color( 50, 50, 50, 255 ) 

	if( b:IsHovered() ) then
		bclr = Color( 205, 205, 205, 255 )
	else
		bclr = Color( 50, 50, 50, 255 ) 
	end
	draw.RoundedBox( 6, 0, 0, w, h, bclr ) -- border
	draw.RoundedBox( 4, padding_s/2, padding_s/2, w - padding_s, h - padding_s, clr ) -- inner
end

function theme.sharpbutton( b, inClr, borderAlpha, hoverBorderAlpha )
	borderAlpha = borderAlpha || 255
	hoverBorderAlpha = hoverBorderAlpha || borderAlpha
	local w, h = b:GetSize()
	inClr = inClr || Color( 235, 64, 52, 255 )

	if( !b:IsHovered() ) then
		surface.SetDrawColor( 205, 205, 205, borderAlpha )
	else
		surface.SetDrawColor( 116, 185, 255, hoverBorderAlpha )
	end

	surface.DrawOutlinedRect( 0, 0, w, h )

	surface.SetDrawColor( inClr )
	surface.DrawRect( padding_s/2, padding_s/2, w - padding_s, h - padding_s )
end

function theme.sharpblurrbutton( b, inClr )
	local w, h = b:GetSize()
	inClr = inClr || Color( 80, 80, 80, 100 )
	
	surface.SetDrawColor( inClr )
	surface.DrawRect( 0, 0, w, h )

	theme.renderblur( b, 4, 8 )

	if( !b:IsHovered() ) then
		surface.SetDrawColor( 205, 205, 205, 255 )
	else
		surface.SetDrawColor( 116, 185, 255, 255 )
	end
	surface.DrawOutlinedRect( 0, 0, w, h )
end

function theme.skipbutton( b, inClr )
	local w, h = b:GetSize()
	inClr = inClr || Color( 0, 0, 0, 0 )

	if( !b:IsHovered() ) then
		surface.SetDrawColor( 205, 205, 205, 2 )
		b:SetTextColor( Color( 255, 255, 255, 2 ) )
	else
		surface.SetDrawColor( 120, 120, 120, 255 )
		b:SetTextColor( Color( 255, 255, 255, 255 ) )
	end

	surface.DrawOutlinedRect( 0, 0, w, h )

	surface.SetDrawColor( inClr )
	surface.DrawRect( padding_s/2, padding_s/2, w - padding_s, h - padding_s )
end

function theme.pagetext( p, clr )
	local w, h = p:GetSize()
	clr = clr || Color( 205, 205, 205, 255 )

	p:SetTextColor( clr )

	surface.SetDrawColor( Color( 0, 0, 0, 0 ) )
	surface.DrawRect( 0, 0, w, h )
end

function theme.itempanel( p, rarecolor, disableHover )
	local w, h = p:GetSize()
	local icon
	if( p.icon == nil || !p.icon:IsValid() || !p.icon:IsVisible() ) then 
		icon = p 
	else
		icon = p.icon
	end

	surface.SetDrawColor( theme.color.setalpha( rarecolor || Color( 0, 0, 0, 120 ), 150 ) )
	surface.DrawRect( 0, 0, w, h )

	if( icon:IsHovered() && !disableHover ) then
		theme.borderpanel( p, Color( 116, 185, 255, 90 ) )
	else
		theme.borderpanel( p, Color( 255, 255, 255, 200 ) )
	end
end

function theme.iteminfopanel( p )
	local w, h = p:GetSize()

	theme.renderblur( p, 4, 5 )

	surface.SetDrawColor( Color( 20, 20, 20, 220 ) )
	surface.DrawRect( 0, 0, w, h )

	theme.borderpanel( p, Color( 205, 205, 205, 200 ) )
end

function theme.iteminfobutton( b, txtClr )
	local w, h = b:GetSize()
	txtClr = txtClr || Color( 255, 255, 255, 255 )

	if( !b:IsHovered() ) then
		b:SetTextColor( txtClr )
	else
		b:SetTextColor( Color( 116, 185, 255, 255 ) )
	end
end

function theme.titleframe( p )
	local w, h = p:GetSize()
	theme.renderblur( p, 25, 10 )
	theme.blurpanel( p, Color( 0, 0, 0, 100 ) )
	surface.SetDrawColor( 0, 0, 0, 100 )
	surface.DrawOutlinedRect( -scale*2, 0, w + 4 * scale, h )
end

function theme.fadepanel( p, dir, color, startalpha, intervall )
	local w, h = p:GetSize()
	color = color || Color( 0, 0, 0 )
	local alpha = startalpha || 200
	dir = dir || 1
	intervall = intervall || 2

	surface.SetDrawColor( color )
	surface.SetAlphaMultiplier( 1 )

	if( dir == 1 ) then
		for iw=1, w, intervall do
			surface.SetDrawColor( Color( color.r, color.g, color.b, alpha * math.Clamp( (w-(iw-1)) / w, 0, 1 ) ) )
			surface.DrawRect( iw - 1, 0, intervall, h )
		end
	elseif( dir == 2 ) then
		for iw=1, w, intervall do
			surface.SetDrawColor( Color( color.r, color.g, color.b, alpha * math.Clamp( (w-(iw-1)) / w, 0, 1 ) ) )
			surface.DrawRect( w - (iw - 1), 0, intervall, h )
		end
	end
end

function theme.fadepanelborder( p, dir, color, color2, startalpha, intervall )
	local w, h = p:GetSize()
	color = color || Color( 0, 0, 0 )
	color2 = color2 || Color( 0, 0, 0 )
	local alpha = startalpha || 200
	dir = dir || 1
	intervall = intervall || 1

	local ih = 2*scale

	theme.fadepanel( p, dir, color, startalpha, intervall )

	-- border
	if( dir == 1 ) then
		for iw=1, w, intervall do
			surface.SetDrawColor( Color( color2.r, color2.g, color2.b, alpha * math.Clamp( (w-(iw-1)) / w, 0, 1 ) ) )

			surface.DrawRect( iw - 1, 0, intervall, ih )
			surface.DrawRect( iw - 1, h - ih/2, intervall, ih )
		end
	elseif( dir == 2 ) then
		for iw=1, w, intervall do ------------------- NOT DONE
			surface.SetDrawColor( Color( color2.r, color2.g, color2.b, alpha * math.Clamp( (w-(iw-1)) / w, 0, 1 ) ) )
			surface.DrawRect( w - (iw - 1), 0, intervall, 2 )
		end
	end
end

function theme.fadebutton( b, dir, inColor, font, txtColor )
	local w, h = b:GetSize()
	local brdColor = Color( 0, 0, 0 )
	inColor = inColor || Color( 0, 0, 0, 100 )

	if( !b:IsHovered() ) then
		brdColor = Color( 0, 0, 0 )
	else
		brdColor = Color( 116, 185, 255 )
	end
	theme.fadepanelborder( b, dir, Color( brdColor.r * 0.4, brdColor.g * 0.4, brdColor.b * 0.4 ) , brdColor )

	-- render the text
	local txt = b.txt || "ERROR txt=nil"
	surface.SetFont( font || "Default" )
	surface.SetTextColor( txtColor || Color( 255, 255, 255, 255 ) )
	local tw, th = surface.GetTextSize( txt )
	surface.SetTextPos( w/8, h/2 - th/2 )
	surface.DrawText( txt )
	
end

function theme.dialogueBox( p )
	local w, h = p:GetSize()
	-- background blur
	theme.renderblur( p, 2, 7 )
		
	-- background
	surface.SetDrawColor( 20, 20, 20, 220 )
	surface.DrawRect( 0, 0, w, h )

	-- outline
	surface.SetDrawColor( 220, 220, 220, 60)
	surface.DrawOutlinedRect( 0, 0, w, h )
end

---- Color Manipulation ----
theme.color = {}

function theme.color.setalpha( color, alpha )
	return Color( color.r, color.g, color.b, alpha )
end


return theme
