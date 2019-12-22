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

		f.pages = {
			inventory = { title = "Inventory" },
			info = { title = "Character Information" }
		}

		-- Inventory button --
		title = vgui.Create( "DLabel", bar )
		title:SetText( "Inventory" )
		title:SetFont( "q_header_s" )
		title:SetTextColor( Color( 255, 255, 255, 255 ) )
		title.Paint = function( self )
			theme.pagetitle( self )
		end

		title:SizeToContents()
		title.w, title.h = title:GetSize()
		title:SetPos( bar.w/2 - title.w/2, bar.h/2 - title.h/2 )


		---- Character view ----
		local char = vgui.Create( "DModelPanel", f )
		char:SetSize( 500, 500 )
		--char:SetModel( dt.cont.char.model ) ------------FIX THIS

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