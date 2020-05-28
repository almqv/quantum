--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

local log = {}
local scale = Quantum.Client.ResolutionScale
local padding = 10 * scale
local padding_s = 4 * scale

local theme = Quantum.Client.Menu.GetAPI( "theme" )

function log.appendLinesToStr(tbl)
	local out = ""
	for _, l in SortedPairs(tbl) do
		if(l != nil) then
			out = out .. l
		end
	end
	return out
end

function log.genTextLinebreak( txt, font, maxW )
	local wordlist = string.Split( txt, " " ) -- all words are seperated by spaces
	local lines = {}

	surface.SetFont(font)
	for i=1, #wordlist do -- loop through all of the words
		local str = wordlist[i] -- "workspace string"
		local wordsUsed = {i}
		for n=i-1, 1, -1 do -- add all words behind i
			if(wordlist[n] != nil) then
				str = wordlist[n] .. " " .. str	
				table.insert(wordsUsed, n) -- remove them all later from wordlist
			end
		end
		local add = ""
		if( wordlist[i+1] != nil ) then add = " " .. wordlist[i+1] end
		if(surface.GetTextSize(str .. add) >= maxW) then 
			table.insert(lines, str .. "\n")
			for _, wordI in pairs(wordsUsed) do
				wordlist[wordI] = nil
			end
		else
			-- append the last sentence
			table.insert(lines, log.appendLinesToStr(wordlist))
		end
	end
	return lines
end


function log.setHeightToLines( p, lines, font, add )
	add = add || 0
	surface.SetFont(font)
	local _, h = surface.GetTextSize("Quantum")
	print(#lines)
	PrintTable(lines)
	p:SetHeight((#lines * h) + (#lines * padding_s) + add)
end

function log.createDialogueBox( logdata, parent )
	cinematic = cinematic || true
	local fw, fh = parent:GetSize()
	local logtext = logdata["init"].question

	local box = vgui.Create( "DPanel", parent )
	local maxW, maxH = 775 * scale, 160 * scale
	box:SetSize( maxW, maxH )
	box.Paint = function( self, w, h )
		-- background blur
		theme.renderblur( self, 2, 7 )
		
		-- background
		surface.SetDrawColor( 20, 20, 20, 220 )
		surface.DrawRect( 0, 0, w, h )

		-- outline
		surface.SetDrawColor( 220, 220, 220, 100)
		surface.DrawOutlinedRect( 0, 0, w, h )
	end
	
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
	scroll:SetSize( box:GetSize() )
	scroll.w, scroll.h = scroll:GetSize()

	local text = vgui.Create( "DLabel", scroll )
	text:SetFont( "q_dialogue_question" )
	text.lines = log.genTextLinebreak( logtext, text:GetFont(), maxW - (padding) )
	text:SetText(log.appendLinesToStr(text.lines))
	text:SetTextColor( Color( 240, 240, 240, 255 ) )
	text:SetWidth( maxW )
	text:SizeToContentsY()	

	text.w, text.h = text:GetSize()
	text:SetPos(padding, padding)
	
	log.setHeightToLines(box, text.lines, text:GetFont(), padding*2)
	
	box.w, box.h = box:GetSize()
	if( box.h > maxH ) then 
		box:SetHeight(maxH)
	end
	box:SetPos( fw/2 - box.w/2, fh*0.7 )

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
