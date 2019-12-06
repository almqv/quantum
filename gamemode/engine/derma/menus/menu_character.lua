--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

local menu = {}

local snm = Quantum.Client.Menu.GetAPI( "net" )
local page = Quantum.Client.Menu.GetAPI( "page" )
local theme = Quantum.Client.Menu.GetAPI( "theme" )
local fade = Quantum.Client.Menu.GetAPI( "fade" )

local resScale = Quantum.Client.ResolutionScale
local sw, sh = ScrW(), ScrH()
local padding = 10 * resScale
local padding_s = 4 * resScale
local errorMdl = "models/player.mdl"

local function getClassModels( class ) 
	if( Quantum.Classes[class] ) then 
		return Quantum.Classes[class].Models 
	else
		Quantum.Error( "Unable to get models from class[" .. tostring( class ) .. "]." )
	end
end
local function getMaxModel( tbl, index ) return tbl[math.Clamp( index, 1, #tbl )] end
local function renderSelectedButton( b, sel ) 
	if( sel ) then
		b:SetTextColor( Color( 255, 239, 158 ) )
	else
		b:SetTextColor( Color( 255, 255, 255 ) )
	end
end

local function getNextIndex( index, isNext, min, max )
	if( isNext ) then
		if( index + 1 > max ) then 
			return min -- integer overflow 
		else
			return index + 1
		end 
	else
		if( index - 1 < min ) then -- integer underflow 
			return max
		else
			return index - 1
		end 
	end
end

local function checkNameString( name )
	local strTbl = string.Explode( "", name )
	for i, char in pairs( strTbl ) do
		if( i == 1 || strTbl[ math.Clamp( i-1, 1, #strTbl ) ] == " " ) then -- if it is the first letter then make it a capital one
			strTbl[i] = string.upper( char ) -- or if it is a space inbetween make it a capital one aswell
		end
		for n, char_ in pairs( strTbl ) do
			if( n >= #strTbl && char == " " && strTbl[n-1] ~= " " ) then strTbl[i] = " " end -- remove the spaces at the end
		end
	end
	return table.concat( strTbl ) -- return the "fixed" name
end

local function isFirstTime( char )
	return char.runIntro || false
end

local function runIntroCinematic( parent, char )
	if( isFirstTime(char) ) then 
		Quantum.Debug( "Running intro cinematic..." )

		fade.transition( parent, {}, 1.5, 2, 2.5, Color( 0,0,0,255 ), true, function() Quantum.Client.Menu.Menus["intro"].open( {} ) end, Quantum.EmptyFunction ) -- run the cinematic via fade in thing
	else
		char.runIntro = nil -- remove the unwanted var since it is taking space for no reason
	end
end

local pages = {
	charCreate = function( parent )
		local pW, pH = parent:GetSize()
		local args = {
			CloseButtonText = "Return",
			CloseButtonFont = "q_text",
		}
		local p, c = page.New( parent, args )
		p:SetVisible( true )
		p.w, p.h = p:GetSize()

		c:SetSize( 85 * resScale, 25 * resScale )
		c.w, c.h = c:GetSize()
		c:SetPos( (p.w - c.w) - padding*4, (p.h - c.h) - padding*4 )
		c.DoClick = function()
			surface.PlaySound( "UI/buttonclick.wav" )
			parent.page:SetVisible( true )
			p:Remove()
		end

		p.scene = {
			["rp_truenorth_v1a_livin"] = { 
				[1] = {
					fov = 75,
					velocity = 10,
					pos1 = Vector(11504.430664, 3809.523193, 72.031250),
					ang1 = Angle(5, 112.406662, 0.000000)
				}
			}
		}
		Quantum.Client.Cam.Start( p.scene[game.GetMap()], true )

		p.OnRemove = function( self )
			Quantum.Client.Cam.Start( parent.scene[game.GetMap()], true ) -- switch back to the parents scene
		end

		local banner = vgui.Create( "DImage", p )
		banner:SetImage( Quantum.Client.ServerBannerPath )
		banner:SizeToContents()
		banner.w, banner.h = banner:GetSize()
		banner:SetSize( (banner.w * resScale)/2.8, (banner.h * resScale)/2.8 )
		banner.w, banner.h = banner:GetSize()
		banner:SetPos( (p.w - banner.w) + padding*2, 0 )

		local ip = vgui.Create( "DPanel", p ) -- input panel
		ip:SetSize( 400 * resScale, p.h * 0.9 )
		ip.w, ip.h = ip:GetSize()
		ip:SetPos( padding*4, p.h/2 - ip.h/2 )
		ip.Paint = function( self ) theme.blurpanel(self) end
		ip.x, ip.y = ip:GetPos()

		local header = vgui.Create( "DLabel", p )
		header:SetText( "Character Creation" )
		header:SetFont( "q_header" )
		header:SetTextColor( Color( 255, 255, 255, 255 ) )
		header:SizeToContents()
		header.w, header.h = header:GetSize()
		header:SetPos( (ip.x + ip.w/2) - header.w/2, header.h/2 + padding )

		-- character model panel
		local mdl = vgui.Create( "DModelPanel", p )
		mdl:SetSize( 600 * resScale, 1000 * resScale )
		mdl.w, mdl.h = mdl:GetSize()
		mdl:SetPos( p.w/2 - mdl.w/2, p.h/2 - mdl.h/2 )
		mdl.x, mdl.y = mdl:GetPos()
		mdl:SetFOV( 55 )
		function mdl:LayoutEntity( ent ) return end

		local inputs = {
			gender = "Male",
			class = "Worker",
			modelIndex = 1,
			name = "",
			job = {
				title = "Unemployed",
				level = -1
			}
		}
		
		local name = vgui.Create( "DTextEntry", p )
		name:SetPlaceholderText( "Character Name" )
		name:SetPlaceholderColor( Color( 100, 100, 100, 100 ) )
		name:SetFont( "q_button2" )
		name:SetTextColor( Color( 255, 255, 255, 255 ) )
		name:SetSize( 300 * resScale, 40 * resScale )
		name.w, name.h = name:GetSize()
		name:SetPos( p.w/2 - name.w/2, p.h*0.85 - name.h/2 )
		name.x, name.y = name:GetPos()
		name.maincolor = Color( 255, 255, 255, 255 )
		name.Paint = function( self ) 
			theme.blurpanel( self ) 
			self:DrawTextEntryText( name.maincolor, Color( 150, 150, 150, 255 ), Color( 100, 100, 100, 255 ) )
		end
		name.OnEnter = function() checkNameString( name:GetText() ) end
		name.OnChange = function( self ) 
			if( #self:GetText() > Quantum.CharacterNameLimit || #self:GetText() < Quantum.CharacterNameMin ) then
				self.maincolor = Color( 255, 100, 100, 255 ) 
			else
				self.maincolor = Color( 255, 255, 255, 255 ) 
			end
		end

		-- input panel contens --

		local rheader = vgui.Create( "DLabel", ip )
		rheader:SetText("Select Class")
		rheader:SetFont( "q_button2" )
		rheader:SetTextColor( Color( 255, 255, 255, 255 ) )
		rheader:SizeToContents()
		rheader.w, rheader.h = rheader:GetSize()
		rheader:SetPos( ip.w/2 - rheader.w/2, rheader.h )
		rheader.x, rheader.y = rheader:GetPos()

		local gbuttons = {}

		gbuttons.female = vgui.Create( "DButton", ip )
		local selectedGenderButton = gbuttons.female -- select itself
		gbuttons.female:SetText( "Female" )
		gbuttons.female:SetTextColor( Color( 255, 255, 255, 255 ) )
		gbuttons.female:SetFont( "q_button2" )
		gbuttons.female.Paint = function( self, w, h ) 
			theme.sharpblurrbutton( self,  Color( 0, 0, 0, 0 ) ) 
			renderSelectedButton( self, selectedGenderButton == self ) 
		end
		gbuttons.female:SizeToContents()
		gbuttons.female.w, gbuttons.female.h = gbuttons.female:GetSize()
		gbuttons.female:SetPos( (ip.w - gbuttons.female.w) - padding - gbuttons.female.w/2, rheader.y + gbuttons.female.h + padding )
		gbuttons.female.x, gbuttons.female.y = gbuttons.female:GetPos()
		gbuttons.female.DoClick = function( self ) 
			if( selectedGenderButton ~= self ) then
				selectedGenderButton = self
				inputs.gender = "Female"
				surface.PlaySound( "UI/buttonclick.wav" )
			end
		end

		gbuttons.male = vgui.Create( "DButton", ip )
		selectedGenderButton = gbuttons.male
		gbuttons.male:SetText( "Male" )
		gbuttons.male:SetTextColor( Color( 0, 0, 0, 255 ) )
		gbuttons.male:SetFont( "q_button2" )
		gbuttons.male:SetSize( gbuttons.female:GetSize() )
		gbuttons.male.w, gbuttons.male.h = gbuttons.male:GetSize() 
		gbuttons.male:SetPos( padding + gbuttons.male.w/2, rheader.y + gbuttons.male.h + padding )

		gbuttons.male.Paint = function( self, w, h ) 
			theme.sharpblurrbutton( self,  Color( 0, 0, 0, 0 ) ) 
			renderSelectedButton( self, selectedGenderButton == self ) 
		end
		gbuttons.male.DoClick = function( self )
			if( selectedGenderButton ~= self ) then
				selectedGenderButton = self
				inputs.gender = "Male"
				surface.PlaySound( "UI/buttonclick.wav" )
			end
		end
		--- Class buttons ---

		local cscroll = vgui.Create( "DScrollPanel", ip )
		cscroll:SetSize( ip.w, ip.h/5 )
		cscroll.w, cscroll.h = cscroll:GetSize()
		cscroll:SetPos( 0, ip.h/6 )
		cscroll.x, cscroll.y = cscroll:GetPos()
		cscroll:GetVBar():SetSize( 0, 0 )

		local classButtons = {}
		local classCount = 0
		for id, class in pairs( Quantum.Classes ) do
			classCount = classCount + 1 -- keep count
			classButtons[classCount] = vgui.Create( "DButton", cscroll )
			classButtons[classCount].class = id
			classButtons[classCount]:SetText( class.Name )
			classButtons[classCount]:SetFont( "q_button2" )
			classButtons[classCount]:SetTextColor( Color( 255, 255, 255, 255 ) )
			classButtons[classCount]:SizeToContents()
			classButtons[classCount].w, classButtons[classCount].h = classButtons[classCount]:GetSize()
			classButtons[classCount]:SetSize( ip.w - padding*2, classButtons[classCount].h )
			classButtons[classCount].w, classButtons[classCount].h = classButtons[classCount]:GetSize()
			classButtons[classCount]:SetPos( cscroll.w/2 - classButtons[classCount].w/2, (classCount-1) * ( padding + classButtons[classCount].h ) )
			classButtons[classCount].Paint = function( self ) 
				theme.sharpblurrbutton( self, Color( 0, 0, 0, 0 ) ) 
				renderSelectedButton( self, inputs.class == self.class ) 
			end
			classButtons[classCount].DoClick = function( self )
				if( inputs.class ~= id ) then
					inputs.class = id
					surface.PlaySound( "UI/buttonclick.wav" )
				end
			end
		end

		--- Model selector ---
		local pmodel = vgui.Create( "DButton", p ) -- previous model
		pmodel:SetText( "< Prev. Model" )
		pmodel:SetFont( "q_button_m" )
		pmodel:SetTextColor( Color( 255, 255, 255, 255 ) )
		pmodel:SizeToContents()
		pmodel.w, pmodel.h = pmodel:GetSize()
		pmodel:SetPos( (mdl.x - pmodel.w) + padding*10, (mdl.y + mdl.h/2) - pmodel.h/2 )
		pmodel.Paint = function( self ) theme.sharpblurrbutton( self, Color( 0, 0, 0, 100 ) ) end
		pmodel.DoClick = function( self )
			surface.PlaySound( "UI/buttonclick.wav" )
			inputs.modelIndex = getNextIndex( inputs.modelIndex, false, 1, #getClassModels( inputs.class )[inputs.gender] )
		end

		local nmodel = vgui.Create( "DButton", p ) -- next model
		nmodel:SetText( "Next Model >" )
		nmodel:SetFont( "q_button_m" )
		nmodel:SetTextColor( Color( 255, 255, 255, 255 ) )
		nmodel:SetSize( pmodel.w, pmodel.h )
		nmodel.w, nmodel.h = nmodel:GetSize()
		nmodel:SetPos( (mdl.x + mdl.w) - padding*10, (mdl.y + mdl.h/2) - nmodel.h/2 )
		nmodel.Paint = function( self ) theme.sharpblurrbutton( self, Color( 0, 0, 0, 100 ) ) end
		nmodel.DoClick = function( self )
			surface.PlaySound( "UI/buttonclick.wav" )
			inputs.modelIndex = getNextIndex( inputs.modelIndex, true, 1, #getClassModels( inputs.class )[inputs.gender] )
		end

		-- Class info --
		local mscroll = vgui.Create( "DScrollPanel", ip )
		mscroll:SetSize( ip.w, ip.h/1.6 )
		mscroll.w, mscroll.h = mscroll:GetSize()
		mscroll:SetPos( 0, ip.h - mscroll.h )
		mscroll:GetVBar():SetSize( 0, 0 )
		mscroll.Paint = function( self )
			theme.borderpanel( self )
		end 


		--- Model viewer
		mdl:SetModel( Quantum.Models.Player.Citizen.Male[math.random(1, #Quantum.Models.Player.Citizen.Male)] ) -- set the char model
		local minv, maxv = mdl.Entity:GetRenderBounds()
		local ent = mdl.Entity
		local eyepos = ent:GetBonePosition( ent:LookupBone( "ValveBiped.Bip01_Head1" ) )
		eyepos:Add( Vector( 40, 0, -15 ) )
		mdl:SetCamPos( eyepos - Vector( -10, 0, -2 ) )
		mdl:SetLookAt( eyepos )

		mdl.Think = function( self )
			--getClassModels(inputs.class)
			if( self:GetModel() ~= getMaxModel( getClassModels(inputs.class)[inputs.gender], inputs.modelIndex ) ) then  
				self:SetModel( getMaxModel( getClassModels(inputs.class)[inputs.gender], inputs.modelIndex ) )
			end
		end

		-- create char button --
		local cr = vgui.Create( "DButton", p )
		cr:SetText( "Create Character" )
		cr:SetFont( "q_button2" )
		cr:SetTextColor( Color( 255, 255, 255, 255 ) )
		cr:SizeToContents()
		cr.w, cr.h = cr:GetSize()
		cr:SetPos( name.x + name.w/2 - cr.w/2, name.y + cr.h + padding )
		cr.Paint = function( self ) theme.sharpblurrbutton( self ) end
		cr.DoClick = function( self )
			
			-- create char
			inputs.name = checkNameString( name:GetText() )
			if( #inputs.name > Quantum.CharacterNameLimit || #inputs.name < Quantum.CharacterNameMin ) then 
				surface.PlaySound( "common/wpn_denyselect.wav" )
				return 
			else
				-- send it to the server
				surface.PlaySound( "UI/buttonclick.wav" )
				snm.RunNetworkedFunc( "createChar", inputs )

				---- save it on the client
				inputs.model = Quantum.Classes[inputs.class].Models[inputs.gender][inputs.modelIndex]

				Quantum.Client.Chars[#Quantum.Client.Chars + 1] = inputs

				--refresh chars in dscrollpanel--
				menu.charScroll.del( Quantum.Client.CharMenuList )
				Quantum.Client.charPanels = menu.charScroll.add( Quantum.Client.Chars, Quantum.Client.CharMenuList, parent.page )
				Quantum.Client.selectedChar = Quantum.Client.charPanels[#Quantum.Client.charPanels] -- select the newly created char

				-- switching buttons & stuff
				parent.page.info:Remove()
				parent.page.mdl:SetVisible(true)
				parent.page.mdl:SetModel( Quantum.Client.selectedChar.char.model )

				local minv, maxv = parent.page.mdl.Entity:GetRenderBounds()
				local eyepos = parent.page.mdl.Entity:GetBonePosition( parent.page.mdl.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) )
				eyepos:Add( Vector( 40, 0, -15 ) )
				parent.page.mdl:SetCamPos( eyepos - Vector( -10, 0, -2 ) )
				parent.page.mdl:SetLookAt( eyepos )

				-- Initialize intro cinematic vars for later
				Quantum.Client.Chars[#Quantum.Client.Chars].runIntro = true -- run the intro on first time spawn
				
				-- Page switching
				parent.page.enter:SetVisible(true)
				parent.page.dl:SetVisible(true)

				--close the page
				parent.page:SetVisible( true )
				p:Remove()
			end
			
		end

		return p, c
	end
}
menu.charScroll = {}
menu.charScroll.del = function( clist )
	for n, panel in pairs( clist.panels ) do
		panel:Remove()
	end
end
menu.charScroll.add = function( chars, clist, p )
	local count = 0
	local cpanels = {}
	for k, v in pairs( chars ) do
		count = count + 1
		cpanels[count] = vgui.Create( "DButton", clist )
		cpanels[count].index = count

		cpanels[count].char = v -- give the panel it's character
		if( !Quantum.Client.selectedChar ) then Quantum.Client.selectedChar = cpanels[1] end -- select the first one

		cpanels[count]:SetText( "" )
		cpanels[count]:SetSize( clist.w - padding, 100 * resScale )
		cpanels[count].w, cpanels[count].h = cpanels[count]:GetSize()
		cpanels[count]:SetPos( padding/2, (padding)*count + (cpanels[count].h * (count-1)) )
		cpanels[count].Paint = function( self, w, h )

			surface.SetDrawColor( 0, 0, 0, 0 )
			surface.DrawRect( 0, 0, w, h )
			
			if( self == Quantum.Client.selectedChar ) then
				surface.SetDrawColor( 252, 186, 3, 100 )
			else
				surface.SetDrawColor( 255, 255, 255, 100 )
			end
			surface.DrawOutlinedRect( 0, 0, w, h )
		end
		cpanels[count].DoClick = function( self ) -- if you press the char, then select it
			Quantum.Client.selectedChar = self
			surface.PlaySound( "UI/buttonclick.wav" )
			p.mdl:SetModel( self.char.model || errorMdl )
		end

		local txt = vgui.Create( "DLabel", cpanels[count] )
		txt:SetText( v.name || "[ERROR] NAME=nil" )
		txt:SetFont( "q_charNameText" )
		txt:SetTextColor( Color( 200, 200, 200, 220 ) )
		txt:SizeToContents()
		local txtW, txtH = txt:GetSize()
		txt:SetPos( padding, cpanels[count].h/4 - txtH/2 )
		local txtX, txtY = txt:GetPos()

		local lvlTxt
		if( v.job.level >= 0 ) then
			lvlTxt = "Level " .. v.job.level .. " "
		else
			lvlTxt = ""
		end

		local lvl = vgui.Create( "DLabel", cpanels[count] )
		lvl:SetText( lvlTxt .. v.job.title )
		lvl:SetFont( "q_text2" )
		lvl:SetTextColor( Color( 180, 180, 180, 225 ) )
		lvl:SizeToContents()
		local lvlW, lvlH = lvl:GetSize()
		lvl:SetPos( txtX, txtY + lvlH )
		local lvlX, lvlY = lvl:GetPos()

		local class = vgui.Create( "DLabel", cpanels[count] )
		class:SetText( v.class )
		class:SetFont( "q_text2" )
		class:SetTextColor( Color( 252, 186, 3, 180 ) )
		class:SizeToContents()
		local classW, classH = class:GetSize()
		class:SetPos( txtX, lvlY + classH )
	end
	clist.panels = cpanels
	return clist.panels
end

function menu.open( dt )
	Quantum.Client.IsInMenu = true -- hide the hud
	Quantum.Client.Chars = dt.cont
	if( !f ) then
		local f = vgui.Create( "DFrame" )
		f:SetTitle( "" )
		f:SetSize( sw, sh )
		f.Paint = function( self, w, h )
			surface.SetDrawColor( 0, 0, 0, 120 )
			surface.DrawRect( 0, 0, w, h )
		end
		f:SetDraggable( false )
		f:ShowCloseButton( false )
		f:MakePopup()
		function f:OnClose()
			Quantum.Client.Chars = nil
			Quantum.Client.IsInMenu = false -- show the hud when closed
			Quantum.Client.Cam.Stop()
		end

		f.scene = {
			["rp_truenorth_v1a_livin"] = { 
				[1] = {
					fov = 70,
					velocity = 10,
					pos1 = Vector(9807.226563, -9093.957031, 5560.153809),
					ang1 = Angle(5.702401, -42.888149, 0.000000)
				}
			}
		}
		Quantum.Client.Cam.Start( f.scene[game.GetMap()], true )

		local args = {
			CloseButtonText = "Return",
			CloseButtonFont = "q_text"
		}
		local p, c = page.New( f, args )
		f.page = p
		f.page:SetVisible( true )

		Quantum.Client.CharMenuList = vgui.Create( "DScrollPanel", p )
		Quantum.Client.CharMenuList:SetSize( 380 * resScale, sh - padding*15 )
		Quantum.Client.CharMenuList.w, Quantum.Client.CharMenuList.h = Quantum.Client.CharMenuList:GetSize()
		Quantum.Client.CharMenuList:SetPos( (sw - Quantum.Client.CharMenuList.w) - padding*2, padding*6 )
		Quantum.Client.CharMenuList.x, Quantum.Client.CharMenuList.y = Quantum.Client.CharMenuList:GetPos()
		Quantum.Client.CharMenuList.Paint = function( self, w, h )
			theme.blurpanel( self )
		end

		local sbar = Quantum.Client.CharMenuList:GetVBar()
		sbar:SetSize( 0, 0 ) -- Remove the scroll bar

		--- Close/quit button stuff ---
		local cW, cH = c:GetSize()
		c:SetPos( (Quantum.Client.CharMenuList.x + Quantum.Client.CharMenuList.w) - cW, Quantum.Client.CharMenuList.y + Quantum.Client.CharMenuList.h + cH )
		c.Paint = function( self ) theme.sharpblurrbutton( self ) end
		c:SetTextColor( Color( 255, 255, 255, 255 ) )
		c.DoClick = function() 
			surface.PlaySound( "UI/buttonclick.wav" )
			f:Close() 
			Quantum.Client.Menu.Menus["main"].open(dt)
		end
		---

		local banner = vgui.Create( "DImage", p )
		banner:SetImage( Quantum.Client.ServerBannerPath )
		banner:SizeToContents()
		banner.w, banner.h = banner:GetSize()
		banner:SetSize( (banner.w * resScale)/2.8, (banner.h * resScale)/2.8 )
		banner:SetPos( padding, padding )

		local header = vgui.Create( "DLabel", p )
		header:SetText( "Characters" )
		header:SetFont( "q_header" )
		header:SizeToContents()
		local headerW, headerH = header:GetSize()
		header:SetPos( Quantum.Client.CharMenuList.x + ( Quantum.Client.CharMenuList.w/2 - headerW/2 ), (Quantum.Client.CharMenuList.y - headerH) + padding/2 )
		header:SetTextColor( Color( 255, 255, 255, 255 ) )
		header.Paint = function( self, w, h ) end

		local chars = dt.cont -- set the char table
		
		local cpanels = {}

		-- Char model
		p.mdl = vgui.Create( "DModelPanel", p )
		p.mdl:SetSize( 600 * resScale, 1000 * resScale )
		p.mdl.w, p.mdl.h = p.mdl:GetSize()
		p.mdl:SetPos( p.w/2 - p.mdl.w/2, p.h/2 - p.mdl.h/2 )
		p.mdl:SetFOV( 55 )
		function p.mdl:LayoutEntity( ent ) return end
		p.mdl:SetVisible( false )

		-- No char found text
		local titles = {
			"404 - Characters not found :(",
			"No Characters Found"
		}

		p.info = vgui.Create( "DLabel", p )
		p.info:SetText( titles[ math.random( 1, #titles ) ] )
		p.info:SetFont( "q_header" )
		p.info:SizeToContents()

		p.info.w, p.info.h = p.info:GetSize()

		p.info:SetPos( p.w/2 - p.info.w/2, p.h/2 - p.info.h/2 )
		p.info:SetVisible( false )

		if( table.Count( Quantum.Client.Chars ) >= 1 ) then
			p.mdl:SetVisible( true )
			p.info:SetVisible( false )
		else
			p.mdl:SetVisible( false )
			p.info:SetVisible( true )
		end
		-----------------------------------------------------
		Quantum.Client.charPanels = menu.charScroll.add( Quantum.Client.Chars, Quantum.Client.CharMenuList, p ) -- add the panels
		Quantum.Client.selectedChar = Quantum.Client.charPanels[1]
		-----------------------------------------------------

		if( Quantum.Client.selectedChar && p.mdl ~= nil ) then
			p.mdl:SetModel( Quantum.Client.selectedChar.char.model ) -- set the char model
			local minv, maxv = p.mdl.Entity:GetRenderBounds()
			local eyepos = p.mdl.Entity:GetBonePosition( p.mdl.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) )
			eyepos:Add( Vector( 40, 0, -15 ) )
			p.mdl:SetCamPos( eyepos - Vector( -10, 0, -2 ) )
			p.mdl:SetLookAt( eyepos )
		end
		-- create char button
		local cr = vgui.Create( "DButton", p )
		cr:SetText("Create New Character")
		cr:SetFont( "q_button" )
		cr:SetTextColor( Color( 255, 255, 255, 255 ) )
		cr:SizeToContents()
		cr.w, cr.h = cr:GetSize()
		cr:SetPos( Quantum.Client.CharMenuList.x + ( Quantum.Client.CharMenuList.w/2 - cr.w/2 ), Quantum.Client.CharMenuList.y + ( ( Quantum.Client.CharMenuList.h - cr.h ) - padding*2 ) )
		cr.Paint = function( self ) 
			theme.sharpblurrbutton( self )
		end
		cr.Think = function( self )
			if( table.Count(Quantum.Client.Chars) >= Quantum.CharacterLimit ) then
				self:SetVisible( false )
			else
				self:SetVisible( true )
			end
		end
		cr.DoClick = function()
			surface.PlaySound( "UI/buttonclick.wav" )
			p:SetVisible( false )
			local crPage = pages.charCreate( f )
		end
		
		cr.OnCursorEntered = function() surface.PlaySound( "UI/buttonrollover.wav" ) end

		if( table.Count(Quantum.Client.Chars) >= Quantum.CharacterLimit ) then
			cr:SetVisible( false ) -- hide if max chars are set
		end

		-- Delete char button
		p.dl = vgui.Create( "DButton", p )
		p.dl:SetText("Delete Character")
		p.dl:SetFont( "q_text" )
		p.dl:SetTextColor( Color( 255, 100, 100, 255 ) )
		p.dl:SizeToContents()
		p.dl.w, p.dl.h = p.dl:GetSize()
		p.dl:SetPos( Quantum.Client.CharMenuList.x, Quantum.Client.CharMenuList.y + ( Quantum.Client.CharMenuList.h + p.dl.h ) )
		p.dl.Paint = function( self ) 
			theme.sharpblurrbutton( self )
		end
		p.dl.DoClick = function()
			surface.PlaySound( "UI/buttonclick.wav" )
			LocalPlayer():ChatPrint( "Comming soon!" )
		end
		
		p.dl.OnCursorEntered = function() surface.PlaySound( "UI/buttonrollover.wav" ) end
		p.dl:SetVisible(false)

		-- Enter world button --
		p.enter = vgui.Create( "DButton", p )
		p.enter:SetText( "Enter World" )
		p.enter:SetFont( "q_button2" )
		p.enter:SetTextColor( Color( 255, 255, 255, 255 ) )
		p.enter:SizeToContents()
		p.enter.w, p.enter.h = p.enter:GetSize()
		p.enter:SetPos( p.w/2 - p.enter.w/2, p.h*0.925 - p.enter.h/2 )
		p.enter.Paint = function( self ) theme.sharpblurrbutton( self ) end
		p.enter.DoClick = function() 
			surface.PlaySound( "UI/buttonclick.wav" ) 
			-- enter world --
			local dt = { index = Quantum.Client.selectedChar.index }
			snm.RunNetworkedFunc( "enterWorldChar", dt ) 
			if( !isFirstTime( Quantum.Client.selectedChar.char ) ) then 
				fade.transition( f, {}, 1, 2, 1, Color( 0, 0, 0, 255 ), true, Quantum.EmptyFunction, Quantum.EmptyFunction ) -- close the frame
			end 

			-- Open the intro cinematic
			runIntroCinematic( f, Quantum.Client.selectedChar.char ) -- run the cinematic if it is the first time
			-- else do nothing

		end
		p.enter.OnCursorEntered = function() surface.PlaySound( "UI/buttonrollover.wav" ) end
		p.enter:SetVisible(false)

		if( Quantum.Client.selectedChar ) then
			p.enter:SetVisible(true)
			p.dl:SetVisible(true)
		end
	end
end

return menu