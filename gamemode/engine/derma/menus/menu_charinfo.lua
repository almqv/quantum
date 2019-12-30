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

local resScale = Quantum.Client.ResolutionScale
local sw, sh = ScrW(), ScrH()
local padding = 10 * resScale
local padding_s = 4 * resScale
local errorMdl = "models/player.mdl"

function menu.open( dt ) 
	local items = dt.cont.items
	PrintTable(dt)
	if( !f ) then
		Quantum.Client.IsInMenu = true

		local f = vgui.Create( "DFrame" )
		f:SetSize( sw, sh )
		f.w, f.h = f:GetSize()
		f:SetTitle( "" )
		f:SetDraggable( false )
		f:ShowCloseButton( false )
		f:MakePopup()
		f.Paint = function( self, w, h ) 
			surface.SetDrawColor( 0, 0, 0, 40 )
			surface.DrawRect( 0, 0, w, h )
			theme.renderblur( self, 10, 10 )
		end
		function f:OnClose()
			Quantum.Client.IsInMenu = false -- show the hud when closed
			Quantum.Client.Cam.Stop()
		end

		-- Default is the inventory page --

		local bar = vgui.Create( "DPanel", f )
		bar:SetSize( f.w, padding*5 )
		bar.w, bar.h = bar:GetSize()
		bar:SetPos( 0, 0 )
		bar.Paint = function( self ) theme.blurpanel( self ) end
		bar.DoClick = function( self ) f:Close() end

		-- Inventory button --
		title = vgui.Create( "DLabel", bar )
		title:SetText( "Inventory" )
		title:SetFont( "q_header_s" )
		title:SetTextColor( Color( 255, 255, 255, 255 ) )
		title.Paint = function( self )
			theme.pagetext( self )
		end

		title:SizeToContents()
		title.w, title.h = title:GetSize()
		title:SetPos( bar.w/2 - title.w/2, bar.h/2 - title.h/2 )

		---- Character view ----
		local char = vgui.Create( "DModelPanel", f )
		char:SetSize( 550 * resScale, f.h - bar.h )
		char.w, char.h = char:GetSize()
		char:SetPos( 0, bar.h )
		char.x, char.y = char:GetPos()
		char:SetFOV( 25 )
		char:SetModel( dt.cont.char.model || errorMdl )
		char:SetDirectionalLight( BOX_FRONT, Color( 116, 205, 255 ) )

		local ent = char.Entity
		local eyepos = ent:GetBonePosition( ent:LookupBone( "ValveBiped.Bip01_Head1" ) )
		eyepos:Add( Vector( 40, 0, -15 ) )
		char:SetCamPos( eyepos + Vector( 40, -5, 2 ) )
		char:SetLookAt( eyepos )
		ent:SetEyeTarget( eyepos + Vector( 40, -5, 2 ) )
		function char:LayoutEntity( Entity ) return end

		---- Inventory panel ----

		local inv = vgui.Create( "DPanel", f ) -- section for all of the item panels
		inv:SetSize( f.w - char.w, f.h - bar.h )
		inv.w, inv.h = inv:GetSize()
		inv:SetPos( char.w, bar.h )
		inv.Paint = function( self, w, h ) 
			surface.SetDrawColor( 0, 0, 0, 0 )
			surface.DrawRect( 0, 0, w, h )
		end

		local itemWidth, itemHeight = 65 * resScale, 65 * resScale
		local maxW, maxH = Quantum.Inventory.Width, Quantum.Inventory.Height

		local itempanels = {}
				
		local count = 0
		local xbasepos, ybasepos = 0, 0
		local xintervall, yintervall = itemWidth + padding/2, itemHeight + padding/2
		local xpos, ypos = 0, 0
		local rows = 0

		local itemframe = vgui.Create( "DPanel", inv ) -- container for all of the item panels
		itemframe:SetSize( inv:GetSize() )
		itemframe:SetPos( 0, 0 )
		itemframe.Paint = function( self, w, h ) end

		for ii=1, maxW * maxH, 1 do -- create all of the item panels
			if( ii != 1 ) then count = count + 1 end

			itempanels[ii] = vgui.Create( "DPanel", itemframe )
			itempanels[ii]:SetSize( itemWidth, itemHeight )
			if( count >= maxW ) then
				ypos = ypos + yintervall
				xpos = xbasepos
				count = 0
				rows = rows + 1
			else
				if( count != 0 ) then
					xpos = xpos + xintervall
				else
					xpos = 0
				end
			end
			itempanels[ii]:SetPos( xpos, ypos )
			itempanels[ii].x, itempanels[ii].y = itempanels[ii]:GetPos()

			itempanels[ii].Paint = function( self ) 
				theme.itempanel( self, Quantum.Rarity.Rare.color )
			end
		end
		
		-- get the width and height of all of the items
		local iwidth, iheight = (itempanels[maxW].x - xbasepos) + itemWidth, (itempanels[#itempanels].y - ybasepos) + itemHeight 
		itemframe:SetSize( iwidth, iheight ) -- set the frames dimensions to all of the items dimensions combined.
		itemframe.w, itemframe.h = itemframe:GetSize()
		itemframe:SetPos( inv.w/2 - itemframe.w/2, inv.h/2 - itemframe.h/2 + padding*8 ) -- center the item panels
		itemframe.x, itemframe.y = itemframe:GetPos()

		----CHAR INFO----

		--Money text
		local money = vgui.Create( "DLabel", inv )
		money:SetText( Quantum.Format.Money( dt.cont.char.money ) )
		money:SetFont( "q_money" )
		money:SetTextColor( Color( 90, 218, 132, 255 ) )
		money:SizeToContents()
		money.w, money.h = money:GetSize()
		money:SetPos( itemframe.x, itemframe.y - money.h - padding )
		money.x, money.y = money:GetPos()
		money.Paint = function( self, w, h ) 
			draw.RoundedBox( 5, 0, 0, w, h, Color( 0, 0, 0, 90 ) )
		end


		--Name text
		local name = vgui.Create( "DLabel", inv )
		name:SetText( dt.cont.char.name || "ERROR: NAME=nil" )
		name:SetFont( "q_name" )
		name:SizeToContents()
		name.w, name.h = name:GetSize()
		name:SetPos( itemframe.x, money.y - name.h - padding )
		name.Paint = function( self, w, h ) 
			draw.RoundedBox( 5, 0, 0, w, h, Color( 0, 0, 0, 90 ) )
			theme.pagetext( self ) 
		end

		---- TEMPORARY: REMOVE WHEN THE MENU IS DONE ----
		local close = vgui.Create( "DButton", f )
		close:SetText( "DEV CLOSE" )
		close:SizeToContents()
		close.w, close.h = close:GetSize()
		close:SetPos( 0, f.h - close.h )
		close.DoClick = function( self ) f:Close() end

	end
end

return menu