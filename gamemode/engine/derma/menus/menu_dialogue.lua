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
local log = Quantum.Client.Menu.GetAPI( "dialogue" )

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
		local node
		if( dt.cont.nodeid != nil ) then
			node = Quantum.Node.Get(dt.cont.nodeid)
		else
			Quantum.Error("Unable to fetch node table. Node ID is nil.")
			return 
		end

		local f = vgui.Create( "DFrame" )
		f:SetSize( sw, sh )
		f:SetTitle( "" )
		f:ShowCloseButton( false )
		local borderHeight = 90 * resScale
		f.Paint = function( self, w, h )
			--[[
			surface.SetDrawColor( Color( 20, 20, 20, 255 ) )
			surface.DrawRect( 0, 0, w, borderHeight )
			surface.DrawRect( 0, h - borderHeight, w, borderHeight )
			--]]
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
		
		f.dialogue = {}
		local textColor = Color(255, 255, 255, 220)
		
		-- Title is static, can't be changed mid dialogue.
		local title = vgui.Create( "DLabel", f ) -- dialogue title, useally the npcs name or something
		title:SetText(node.name)
		title:SetFont("q_header_s")
		title:SetTextColor(textColor)
		title:SizeToContents()
		title.w, title.h = title:GetSize()
		title:SetPos(padding*2, borderHeight/2 - title.h/2)
		
		-- Dialogue options
		f.dialogue.cont, f.dialogue.contScroll = log.createContainer( f, true )
		f.dialogue.cont.options = {}
		local btnFont = "q_info"
		for i, option in SortedPairs(dialogue["init"].response) do
			f.dialogue.cont.options[i] = log.createOptionButton( f.dialogue.contScroll, i, option.text, btnFont )
			f.dialogue.cont.options[i]:UpdateSize(padding_s)
		end
		-- add the goodbye button
		f.dialogue.cont.options.bye = log.createOptionButton( f.dialogue.contScroll, #f.dialogue.cont.options + 1, dialogue.bye, btnFont )
		f.dialogue.cont.options.bye:UpdateSize(padding_s)

		f.dialogue.cont:SetPos( f.w/2 - f.dialogue.cont.w/2, f.h - f.dialogue.cont.h - padding )
		f.dialogue.cont.x, f.dialogue.cont.y = f.dialogue.cont:GetPos()

		-- Dialogue question
		f.dialogue.q, f.dialogue.qtext = log.createQBox( dialogue, f )
		f.dialogue.q:SetPos( f.w/2 - f.dialogue.q.w/2, f.dialogue.cont.y - f.dialogue.q.h - padding*2 )

		return f
	end
end

return menu
