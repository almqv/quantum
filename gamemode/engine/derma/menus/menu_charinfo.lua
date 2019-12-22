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
		local f = vgui.Create( "DFrame" )
		f:SetSize( sw, sh )
		f:SetTitle("Character Info")
		f:SetDraggable( false )
		f:MakePopup()
		f.Paint = function() end
		function f:OnClose()
			Quantum.Client.IsInMenu = false -- show the hud when closed
			Quantum.Client.Cam.Stop()
		end

		-- Default is the inventory page --

		--f.inv = page.New( f, {} )
	end
end

return menu