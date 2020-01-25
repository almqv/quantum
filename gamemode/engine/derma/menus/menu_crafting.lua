--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

local menu = {}

local snm = Quantum.Client.Menu.GetAPI( "net" )
local theme = Quantum.Client.Menu.GetAPI( "theme" )
local iteminfo = Quantum.Client.Menu.GetAPI( "iteminfo" )

local resScale = Quantum.Client.ResolutionScale
local sw, sh = ScrW(), ScrH()
local padding = 10 * resScale
local padding_s = 4 * resScale

local itemWidth, itemHeight = 65 * resScale, 65 * resScale

local function configureCamLookPos( icon )
	local mn, mx = icon.Entity:GetRenderBounds()
	local size = 0

	size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
	size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
	size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )
	icon:SetCamPos( Vector( size/2, size, size ) )
	icon:SetLookAt( ( mn + mx )/2 )
end

local function createItemAmountLabel( icon, item )
	icon.amountpanel = vgui.Create( "DLabel", icon )
	icon.amountpanel:SetText( tostring( item.amount ) )
	icon.amountpanel:SetTextColor( Color( 205, 205, 205, 255 ) )
	icon.amountpanel:SetFont( "q_item_amount" )
	icon.amountpanel:SizeToContents()
	icon.amountpanel.w, icon.amountpanel.h = icon.amountpanel:GetSize()
	icon.amountpanel:SetPos( ( icon.w - icon.amountpanel.w ) - padding_s, icon.h - icon.amountpanel.h )
	return icon.amountpanel
end

local function createItemPanel( x, y, scale, parent, frame, addW )
	local p = vgui.Create( "DPanel", parent )
	p:SetSize( itemWidth * scale, itemHeight * scale )
	p.w, p.h = p:GetSize()
	p:SetPos( x - p.w/2, y - p.h/2 )
	p.x, p.y = p:GetPos()

	p.Paint = function( self ) 
		theme.itempanel( self, self.itemcolor, true )
	end

	function p.SetItem( itemid )
		
		if( itemid != nil ) then

			local itemTbl = Quantum.Item.Get( itemid )

			p.itemid = itemid -- give it its equipped item
			p.itemcolor = itemTbl.rarity.color -- give it its color

			p.item = itemTbl
			p.item.amount = 1

			if( IsValid( p.icon.tooltip ) ) then
				p.icon.tooltip:Remove() -- remove the old
			end

			p.icon.tooltip = iteminfo.givetooltip( p.icon, frame, addW ) -- create a new
			p.icon.tooltip:CreateInfo() 

			p.icon:SetVisible( true )
			p.icon:SetModel( itemTbl.model )
			configureCamLookPos( p.icon )
		else
			p.icon:SetVisible( false ) -- hide it if there is no item
			if( IsValid( p.icon.tooltip ) ) then
				p.icon.tooltip:Remove()
			end
			p.itemid = nil -- remove its item id
			p.itemcolor = nil -- remove the background color
		end
	end

	p.icon = vgui.Create( "DModelPanel", p )
	p.icon:SetSize( p:GetSize() )
	p.icon.w, p.icon.h = p.icon:GetSize()
	p.icon:SetPos( 0, 0 )
	p.icon:SetFOV( 45 )

	return p
end

function menu.open( dt )

	local station
	local stationEnt

	local recipes
	local stationTbl
	if( dt != nil ) then
		if( dt.cont != nil ) then
			station = dt.cont.station
			stationTbl = Quantum.Station.Get( station )
			recipes = Quantum.Station.GetRecipes( station )
			stationEnt = dt.cont.stationEnt
		end
	end

	local items = Quantum.Client.Inventory 
	local equipped = Quantum.Client.Equipped

	if( Quantum.Client.Character == nil ) then 
		chat.AddText( Color( 255, 25, 25 ), "[Quantum] - [ERROR] Check console for details.\n" )
		Quantum.Error( "\nCharacter could not be found. Can not open inventory!\nGive this message to someone important: Quantum.Client.Character=nil\nTry rejoining the server and this should be fixed." ) 
		return 
	end

	if( !Quantum.Client.CurStationMenu ) then
		Quantum.Client.IsInMenu = true

		local back = vgui.Create( "DPanel" )
		back:SetSize( sw, sh )
		back.Paint = function( self )
			theme.renderblur( self, 20, 20 )
		end

		local f = vgui.Create( "DFrame" )
		Quantum.Client.CurStationMenu = f
		f:SetSize( 1100 * resScale, 800 * resScale )
		f.w, f.h = f:GetSize()
		f:SetPos( sw/2 - f.w/2, sh/2 - f.h/2 )

		f:SetTitle( "" )
		f:SetDraggable( false )
		f:ShowCloseButton( false )
		f:MakePopup()
		f.Paint = function( self, w, h ) 
			surface.SetDrawColor( 0, 0, 0, 120 )
			surface.DrawRect( 0, 0, w, h )
			theme.renderblur( self, 10, 10 )
		end
		function f:OnClose()
			back:Remove()
			Quantum.Client.IsInMenu = false
			Quantum.Client.CurStationMenu = nil
			Quantum.Client.Cam.Stop()
		end

		local keycodesClose = {
			[KEY_ESCAPE] = true,
			[KEY_TAB] = true
		}

		function f:OnKeyCodeReleased( keyCode )
			if( keycodesClose[keyCode] ) then
				self:Close()	
			end
		end

		function f:Think()
			if( IsValid( stationEnt ) ) then
				if( LocalPlayer():GetPos():Distance( stationEnt:GetPos() ) >= 100 ) then -- clientside security sucks but works in this case :P
					self:Close()
				end
			end
		end

		Quantum.Client.CurMenu = f

		-- Title --
		local bar = vgui.Create( "DPanel", f )
		bar:SetSize( f.w, padding*4 )
		bar.w, bar.h = bar:GetSize()
		bar:SetPos( 0, 0 )
		bar.Paint = function( self ) theme.blurpanel( self ) end
		bar.DoClick = function( self ) f:Close() end

		-- Inventory title --
		title = vgui.Create( "DLabel", bar )
		title:SetText( stationTbl.name || "ERROR name=nil" )
		title:SetFont( "q_header_vs" )
		title:SetTextColor( Color( 255, 255, 255, 255 ) )
		title.Paint = function( self )
			theme.pagetext( self )
		end

		title:SizeToContents()
		title.w, title.h = title:GetSize()
		title:SetPos( bar.w/2 - title.w/2, bar.h/2 - title.h/2 )

		---- recipe list ----

		local list = vgui.Create( "DPanel", f )
		list:SetSize( f.w/4.2, f.h - bar.h )
		list.w, list.h = list:GetSize()
		list:SetPos( 0, bar.h )
		list.Paint = function( self )
			theme.blurpanel( self )
		end

		local scroll = vgui.Create( "DScrollPanel", list )
		scroll:SetSize( list.w, list.h )
		scroll.w, scroll.h = scroll:GetSize()

		local vbar = scroll:GetVBar()
		function vbar:Paint() theme.borderpanel( vbar, Color( 200, 200, 200, 200 ) ) end

		local btnColors = Color( 100, 100, 100, 50 ) 

		vbar.btnUp:SetText( "▲" ) -- up
		vbar.btnUp:SetTextColor( Color( 255, 255, 255, 200 ) )
		function vbar.btnUp:Paint() theme.sharpblurrbutton( vbar.btnUp, btnColors) end

		vbar.btnDown:SetText( "▼" ) -- down
		vbar.btnDown:SetTextColor( Color( 255, 255, 255, 200 ) )
		function vbar.btnDown:Paint() theme.sharpblurrbutton( vbar.btnDown, btnColors ) end

		-- grip
		function vbar.btnGrip:Paint() theme.sharpbutton( vbar.btnGrip, btnColors ) end

		local cont = vgui.Create( "DPanel", f )
		cont:SetSize( f.w - list.w, f.h - bar.h )
		cont:SetPos( list.w, bar.h )
		cont.Paint = function( self ) 
			theme.blurpanel( self, Color( 255, 255, 255, 1 ) )
		end

		local resBars = {}
		local selectedBar 
		for i, resID in pairs( recipes ) do
			resBars[resID] = vgui.Create( "DPanel", scroll )
			resBars[resID].resTbl = Quantum.Recipe.Get( resID )
			resBars[resID].resItemTbl = Quantum.Item.Get( resID )

			resBars[resID]:SetSize( scroll.w, 30 * resScale )
			resBars[resID].w, resBars[resID].h = resBars[resID]:GetSize()

			resBars[resID]:SetPos( 0, resBars[resID].h * (i-1) + padding*i )
			resBars[resID].x, resBars[resID].y = resBars[resID]:GetPos()

			resBars[resID].Paint = function( self, w, h )
				surface.SetDrawColor( 255, 255, 255, 1 )
				surface.DrawRect( 0, 0, w, h )
			end

			resBars[resID].txt_panel = vgui.Create( "DLabel", resBars[resID] )
			resBars[resID].txt_panel:SetText( resBars[resID].resTbl.name )
			resBars[resID].txt_panel:SetFont( "q_text" )
			resBars[resID].txt_panel:SetTextColor( theme.color.setalpha(resBars[resID].resItemTbl.rarity.color, 200) )

			resBars[resID].txt_panel:SizeToContents()
			resBars[resID].txt_panel.w, resBars[resID].txt_panel.h = resBars[resID].txt_panel:GetSize()

			resBars[resID].txt_panel:SetPos( padding, resBars[resID].h/2 - resBars[resID].txt_panel.h/2 )

			local overlay = vgui.Create( "DButton", resBars[resID] )
			overlay:SetText("")
			overlay:SetSize( resBars[resID].w, resBars[resID].h )
			overlay:SetPos( 0, 0 )
			overlay.Paint = function( self, w, h ) 
				theme.sharpbutton( self, Color( 0, 0, 0, 0 ), 10, 80 )
			end

			overlay.DoClick = function( self )
				surface.PlaySound( "UI/buttonclick.wav" )
				selectedBar = resBars[resID]
			end
			overlay.OnCursorEntered = function() surface.PlaySound( "UI/buttonrollover.wav" ) end
		end
		if( #resBars > 0 ) then
			selectedBar = resBars[1]
		end

	end
end

return menu