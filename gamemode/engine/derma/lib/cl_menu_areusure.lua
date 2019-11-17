--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

local sure = {}

local scale = Quantum.Client.ResolutionScale
local padding = 10 * scale
local padding_s = 4 * scale

local theme = Quantum.Client.Menu.GetAPI( "theme" )

function sure.open( text, parent, func )

	local p = vgui.Create( "DPanel", parent )
	p:SetSize( parent:GetSize() )
	p.Paint = function( self ) end -- paint nothing
	p.w, p.h = p:GetSize()

	func = func || function() end

	local box = vgui.Create( "DPanel", p )
	box:SetSize( 380 * scale, 180 * scale )
	box.w, box.h = box:GetSize()
	box:SetPos( p.w/2 - box.w/2, p.h/2 - box.h/2 )

	local barH = box.h/6 - padding

	box.Paint = function( self, w, h )
		theme.sharpblurpanel( self )

		surface.SetDrawColor( 255, 255, 255, 225 )
		surface.DrawRect( 0, 0, w, barH )
	end

	local txt = vgui.Create( "DLabel", box )
	txt:SetText( "Are you sure?" )
	txt:SetFont( "q_button_m" )
	txt:SetTextColor( Color( 0, 0, 0, 255 ) )
	txt:SizeToContents()
	txt.w, txt.h = txt:GetSize()
	txt:SetPos( box.w/2 - txt.w/2, barH/3 - txt.h/2 )

	local info = vgui.Create( "DLabel", box )
	info:SetText( text )
	info:SetFont( "q_text2" )
	info:SetTextColor( Color( 255, 255, 255, 225 ) )
	info:SizeToContents()
	info.w, info.h = info:GetSize()
	info:SetPos( box.w/2 - info.w/2, box.h/3 - info.h/2 )

	local yes = vgui.Create( "DButton", box )
	yes:SetText( "Yes" )
	yes:SetFont( "q_button_m" )
	yes:SetTextColor( Color( 0, 0, 0, 255 ) )
	yes:SizeToContents()
	yes.w, yes.h = yes:GetSize()
	yes:SetPos( box.w/4 - yes.w/2, (box.h*0.75) - yes.h/2 )
	yes.Paint = function( self ) theme.sharpbutton( self, Color( 80, 190, 90, 225 ) ) end
	yes.DoClick = function( self ) 
		surface.PlaySound( "UI/buttonclick.wav" )
		func()
		p:Remove() 
	end
	yes.OnCursorEntered = function() surface.PlaySound( "UI/buttonrollover.wav" ) end

	local no = vgui.Create( "DButton", box )
	no:SetText( "No" )
	no:SetFont( "q_button_m" )
	no:SetTextColor( Color( 0, 0, 0, 255 ) )
	no:SetSize( yes:GetSize() )
	no.w, no.h = no:GetSize()
	no:SetPos( box.w*0.75 - no.w/2, (box.h*0.75) - no.h/2 )
	no.Paint = function( self ) theme.sharpbutton( self, Color( 190, 110, 90, 225 ) ) end
	no.DoClick = function( self ) 
		surface.PlaySound( "UI/buttonclick.wav" )
		p:Remove() 
	end
	no.OnCursorEntered = function() surface.PlaySound( "UI/buttonrollover.wav" ) end
end

return sure