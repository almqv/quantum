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

function menu.open( dt )

	local station
	if( dt != nil ) then
		station = dt.cont.station
	end

	local items = Quantum.Client.Inventory 
	local equipped = Quantum.Client.Equipped

	if( Quantum.Client.Character == nil ) then 
		chat.AddText( Color( 255, 25, 25 ), "[Quantum] - [ERROR] Check console for details.\n" )
		Quantum.Error( "\nCharacter could not be found. Can not open inventory!\nGive this message to someone important: Quantum.Client.Character=nil\nTry rejoining the server and this should be fixed." ) 
		return 
	end

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
			Quantum.Client.IsInMenu = false
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

		Quantum.Client.CurMenu = f

	end
end

return menu