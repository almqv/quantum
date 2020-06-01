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

function log.appendLinesToStr(tbl, sep)
	sep = sep || ""
	local out = ""
	for _, l in SortedPairs(tbl) do
		if(l != nil) then
			out = out .. l .. sep
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
		end
	end
	-- append the last sentence
	table.insert(lines, log.appendLinesToStr(wordlist, " "))
	return lines
end


function log.setHeightToLines( p, lines, font, add )
	add = add || 0
	surface.SetFont(font)
	local _, h = surface.GetTextSize("Quantum")
	p:SetHeight((#lines * h) + (#lines * padding_s) + add)
end

local maxW, maxH = 775 * scale, 160 * scale

function log.createOptionButton( interface, index, res, font )
	local parent = interface.contScroll
	if(parent == nil) then 
		Quantum.Error("Could not index dialogue interface, failed to create option button.")
		return 
	end

	local btn = parent:Add("DButton")
	btn:SetContentAlignment(4)
	btn:SetText(res.text)
	btn:SetFont(font)
	btn:SetTextColor( Color( 255, 255, 255, 200 ) )
	btn.index = index
	btn.w, btn.h = maxW - padding*4, 40 * scale
	btn:SetSize( btn.w, btn.h )
	btn.Paint = function( self )
		theme.renderblur( self, 2, 6 )
		theme.sharpbutton( self, Color( 20, 20, 20, 220) )
	end

	function btn:UpdateSize( add )
		local font, lines = self:GetFont(), log.genTextLinebreak( self:GetText(), font, btn.w )
		self:SetText( log.appendLinesToStr(lines, " ") )
		log.setHeightToLines(self, lines, font, add)
		self.w, self.h = self:GetSize()
		
		self:Dock(TOP)
		self:DockMargin( padding_s*4, 0, padding_s*4, padding_s*2 )
		return self
	end

	btn.DoClick = function(self)
		if(res.newqID) then
			log.updateDialogueInterface(interface, res.newqID)
		end
	end
	return btn
end

function log.createContainer( parent, hide )
	local box = vgui.Create( "DPanel", parent )
	box:SetSize( maxW, maxH )
	box.Paint = function( self ) 
		if( !hide ) then
			theme.dialogueBox(self) 
		end
	end
	box.w, box.h = maxW, maxH

	function box:UpdateSize( lines, font, add )
		log.setHeightToLines(self, lines, font, add)
	
		self.w, self.h = self:GetSize()
		if( self.h > maxH ) then 
			self:SetHeight(maxH)
		end
		self.w, self.h = self:GetSize()

		return self
	end
	
	local scroll = vgui.Create( "DScrollPanel", box )
	scroll:SetSize( box:GetSize() )
	scroll.Paint = function( self ) end
	local sb = scroll:GetVBar()
	sb.Paint = Quantum.EmptyFunction
	function sb.btnGrip:Paint() 
		theme.blurpanel(self)
	end
	sb:SetWidth(padding)

	sb.btnUp:SetSize(0,0)
	sb.btnUp.Paint = function(self) end

	sb.btnDown:SetSize(0,0)
	sb.btnDown.Paint = function(self) end

	scroll:SetSize( box:GetSize() )
	scroll.w, scroll.h = scroll:GetSize()

	return box, scroll
end

function log.createQBox( logdata, parent, log_cont )
	cinematic = cinematic || true
	local fw, fh = parent:GetSize()

	local box, scroll = log.createContainer( parent )

	box.text = vgui.Create( "DLabel", scroll )
	box.text:SetFont( "q_dialogue_question" )
	box.text:SetTextColor( Color( 240, 240, 240, 255 ) )
	
	function box.text:SetQText(logtext)
		self.lines = log.genTextLinebreak( logtext, self:GetFont(), maxW - (padding) )
		self:SetText(log.appendLinesToStr(self.lines))
		self:SetWidth( maxW )
		self:SizeToContentsY()	

		self.w, self.h = self:GetSize()
		self:SetPos(padding, padding)
	end
	
	function box:UpdateQ(qtext)
		self.text:SetQText(qtext)

		self:UpdateSize( self.text.lines, self.text:GetFont(), padding*2 )
		self:SetPos( fw/2 - self.w/2, log_cont.y - self.h - padding*2 )
	end

	box:UpdateQ(logdata["init"].question)

	return box
end


function log.createinfobox( logdata, parent, cinematic )
	cinematic = cinematic || true
	local fw, fh = parent:GetSize()
	local logtitle = logdata[1].title
	local logtext = logdata[1].text

	local box = vgui.Create( "DPanel", parent )
	box:SetSize( 775 * scale, 200 * scale )
	box.Paint = function( self ) theme.dialogueBox( self ) end
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

-- Dialogue stuff
local btnFont = "q_info"

local function setDialogueOptions( interface, dialogue, qID )
	if( interface.cont.options != nil ) then
		for _, option in pairs(interface.cont.options) do
			option:Remove()
		end
	end

	interface.cont.options = {}
	for i, option in SortedPairs(dialogue[qID].response) do
		PrintTable(option)
		interface.cont.options[i] = log.createOptionButton( interface, i, option, btnFont )
		interface.cont.options[i]:UpdateSize(padding_s)
	end
end

function log.createDialogueInterface(f, dialogue)
	f.dialogue = {}
	f.dialogue.log = dialogue
	f.dialogue.cont, f.dialogue.contScroll = log.createContainer( f, true )
	
	-- Generate the dialogue options
	setDialogueOptions( f.dialogue, dialogue, "init" )
	
	-- add the goodbye button
	f.dialogue.cont.options.bye = log.createOptionButton( f.dialogue, #f.dialogue.cont.options + 1, dialogue.bye, btnFont )
	f.dialogue.cont.options.bye:UpdateSize(padding_s)
	
	-- Update the containers pos
	f.dialogue.cont:SetPos( f.w/2 - f.dialogue.cont.w/2, f.h - f.dialogue.cont.h - padding )
	f.dialogue.cont.x, f.dialogue.cont.y = f.dialogue.cont:GetPos()

	-- Dialogue question
	f.dialogue.q = log.createQBox( dialogue, f, f.dialogue.cont )
	

	return f.dialogue
end

function log.updateDialogueInterface(i, qID)
	if(i.cont == nil || i.q == nil) then 
		Quantum.Error(tostring(i) .. " is not a dialogue interface!")
		return 
	end

	local qlog = i.log[qID]
	if(qlog == nil) then
		Quantum.Error("No such question id. qlog=nil, qID=" .. tostring(qID))
		return 
	end
	
	-- update the responses
	genDialogueOptions( i.cont, i.contScroll, i.log, qID )

	-- update the question
	i.q:UpdateQ(qlog.question)
	
end

return log
