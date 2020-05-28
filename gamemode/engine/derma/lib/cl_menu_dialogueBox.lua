--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

-- This is mainly used for cinematic, do not confuse it with NPC dialogue

local log = {}
local scale = Quantum.Client.ResolutionScale
local padding = 10 * scale
local padding_s = 4 * scale

local theme = Quantum.Client.Menu.GetAPI( "theme" )

function log.createDialogueBox( logdata, parent )
	cinematic = cinematic || true
	local fw, fh = parent:GetSize()
	local logtext = logdata["init"].question

	local box = vgui.Create( "DPanel", parent )
	box:SetSize( 775 * scale, 80 * scale )
	box.Paint = theme.sharpblurpanel( self ) 
	box.w, box.h = box:GetSize()
	box:SetPos( fw/2 - box.w/2, fh*0.7 - box.h/2 ) 
	box.x, box.y = box:GetPos()

	local scroll = vgui.Create( "DScrollPanel", box )
	scroll:SetSize( box:GetSize() )
	scroll.Paint = function( self ) end
	local sb = scroll:GetVBar()
	sb.Paint = function( self ) end
	function sb.btnGrip:Paint() 
		theme.button( self, Color( 0, 0, 0, 0 ) ) 
	end
	sb.btnUp:SetSize(0,0)
	sb.btnDown:SetSize(0,0)
	scroll.w, scroll.h = scroll:GetSize()

	local text = vgui.Create( "DLabel", scroll )
	text:SetText( logtext )
	text:SetFont( "q_dialogue_question" )
	text:SetTextColor( Color( 240, 240, 240, 255 ) )
	text:SetSize( scroll.w * 0.95, scroll.h * 0.95 )
	text:SetWrap( true )

	text.w, text.h = text:GetSize()

	text:SetPos( scroll.w/2 - text.w/2, 0 )

	return box
end
function log.createinfobox( logdata, parent, cinematic )
	cinematic = cinematic || true
	local fw, fh = parent:GetSize()
	local logtitle = logdata[1].title
	local logtext = logdata[1].text

	local box = vgui.Create( "DPanel", parent )
	box:SetSize( 775 * scale, 200 * scale )
	box.Paint = function( self ) theme.sharpblurpanel( self ) end
	box.w, box.h = box:GetSize()
	box:SetPos( fw/2 - box.w/2, fh*0.8 - box.h/2 ) 
	box.x, box.y = box:GetPos()

	local header = vgui.Create( "DLabel", parent )
	header:SetFont( "q_header_s" )
	header:SetTextColor( Color( 255, 255, 255, 220 ) )
	header:SizeToContents()
	header.w, header.h = header:GetSize()
	header:SetPos( box.x, ( box.y - header.h ) - padding/2 )
	header.Think = function( self ) 
		if( Quantum.Client.Cam.Temp != nil ) then
			if( logdata[Quantum.Client.Cam.Temp.scene_index] != nil ) then
				if( logdata[Quantum.Client.Cam.Temp.scene_index].title != nil ) then
					self:SetVisible( true )
					self:SetText( logdata[Quantum.Client.Cam.Temp.scene_index].title ) 
					surface.SetFont( self:GetFont() )
					local tw, th = surface.GetTextSize( self:GetText() )
					self:SetSize( tw * 1.1, th * 1.1 )
				end
			end
		end
	end
	header.Paint = function( self )
		theme.sharpblurpanel( self )
	end
	header:SetContentAlignment( 5 )

	local scroll = vgui.Create( "DScrollPanel", box )
	scroll:SetSize( box:GetSize() )
	scroll.Paint = function( self ) end
	local sb = scroll:GetVBar()
	sb.Paint = function( self ) end
	function sb.btnGrip:Paint() 
		theme.button( self, Color( 0, 0, 0, 0 ) ) 
	end
	sb.btnUp:SetSize(0,0)
	sb.btnDown:SetSize(0,0)
	scroll.w, scroll.h = scroll:GetSize()

	local text = vgui.Create( "DLabel", scroll )
	text:SetText( logtext )
	text:SetFont( "q_info" )
	text:SetTextColor( Color( 240, 240, 240, 255 ) )
	text:SetSize( scroll.w * 0.95, scroll.h * 0.95 )
	text:SetWrap( true )

	text.w, text.h = text:GetSize()

	text:SetPos( scroll.w/2 - text.w/2, 0 )

	text.Think = function( self ) 
		if( Quantum.Client.Cam.Temp != nil && cinematic ) then
			if( logdata[Quantum.Client.Cam.Temp.scene_index] != nil ) then
				self:SetText( logdata[Quantum.Client.Cam.Temp.scene_index].text ) 
			end
		end
	end

	return box
end

return log
