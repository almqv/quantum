--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

local menu = {}

local snm = Quantum.Client.Menu.GetAPI( "net" )
local theme = Quantum.Client.Menu.GetAPI( "theme" )
local fade = Quantum.Client.Menu.GetAPI( "fade" )

local resScale = Quantum.Client.ResolutionScale
local sw, sh = ScrW(), ScrH()
local padding = 10 * resScale
local padding_s = 4 * resScale

local scenes = {
	[1] = {
		fov = 60,
		velocity = 1,
	}
}

function menu.open( dt )
	if( dt.cont.dialogueID == nil ) then return end

	if( !f ) then
		Quantum.Client.IsInMenu = true -- hide the hud

		-- make the cinematic start from the players pov
		scenes[1].pos1 = LocalPlayer():GetBonePosition(LocalPlayer():LookupBone("ValveBiped.Bip01_Head1")) || Vector()
		scenes[1].ang1 = LocalPlayer():GetAngles()

		local npc = dt.cont.ent
		scenes[1].ang2 = Quantum.Client.Cam.InvertAngle(npc:GetAngles()) || Angle() -- make the camera look at the NPC
		scenes[1].pos2 = npc:GetBonePosition(npc:LookupBone("ValveBiped.Bip01_Head1")) + scenes[1].ang2:Forward() * -28 || Vector() -- Move the camera forward
		
		Quantum.Client.Cam.Start( scenes, true, false )

		local dialogue = Quantum.Dialogue.Get( dt.cont.dialogueID )

		local f = vgui.Create( "DFrame" )
		f:SetSize( sw, sh )
		f:SetTitle( "" )
		f:ShowCloseButton( false )
		f.Paint = function( self, w, h ) 
			surface.SetDrawColor( Color( 20, 20, 20, 255 ) )
			local height = 90 * resScale
			surface.DrawRect( 0, 0, w, height )
			surface.DrawRect( 0, h - height, w, height )
		end
		f:SetDraggable( false )
		f:MakePopup()
		function f:OnClose() 
			Quantum.Client.IsInMenu = false 
			Quantum.Client.Cam.Stop() -- stop the cinematic
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
		f.w, f.h = f:GetSize()

		local q = vgui.Create( "DLabel", f )

	end
end

return menu