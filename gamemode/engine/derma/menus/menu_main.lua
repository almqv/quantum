--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

local main = {}

local theme = Quantum.Client.Menu.GetAPI( "theme" )
local surebox = Quantum.Client.Menu.GetAPI( "sure" )

local scenes = {
	["rp_truenorth_v1a_livin"] = {
		[1] = {
			[1] = {
				fov = 60,
				velocity = 1,
				pos1 = Vector( 3473.962158, -5456.522949, 4205.845703 ),
				ang1 = Angle( 6.283165, -108.298935, 0.000000 )
			}
		},
		[2] = {
			[1] = {
				fov = 70,
				velocity = 1,
				pos1 = Vector( 10481.976562, -6193.810059, 5464.451172 ),
				ang1 = Angle( 3.220725, 103.288849, 0.000000 )
			}
		},
		[3] = {
			[1] = {
				fov = 85,
				velocity = 1,
				pos1 = Vector( 6285.742676, -14192.770508, 53.289391 ),
				ang1 = Angle( -0.052740, 158.862747, 0.000000 )
			}
		},
		[4] = {
			 [1] = {
				 fov = 85,
				 velocity = 1,
				 pos1 = Vector( -11803.785156, -13864.571289, -39.331917 ),
				 ang1 = Angle( 7.180876, 118.805817, 0.000000 )
			 }
		}
	}
}

local charmenu = include( GAMEMODE.FolderName .. "/gamemode/engine/derma/menus/menu_character.lua" )

function main.open(dt)

	if( !f ) then
		Quantum.Client.IsInMenu = true -- hide the hud

		local resScale = Quantum.Client.ResolutionScale
		local sw, sh = ScrW(), ScrH()
		local padding = 10 * resScale
		local padding_s = 4 * resScale

		local buttonWidth = 255 * resScale
		local buttonColor = Color( 20, 20, 20, 100 )
		local buttonTextColor = Color( 255, 255, 255, 255 )
		local buttonFont = "q_button2"

		local f = vgui.Create( "DFrame" )
		f:SetSize( sw, sh )
		f:SetTitle( "" )
		f:IsDraggable( false )
		f:ShowCloseButton( false )
		f:MakePopup()
		f.Paint = function( self ) 
			theme.renderblur( self, 2, 7 )
		end
		f.OnClose = function( self )
			--Quantum.Client.IsInMenu = false 
			--Quantum.Client.Cam.Stop()
			charmenu.open( dt )
		end

		Quantum.Client.Cam.Start( scenes[ game.GetMap() ][math.random( 1, table.Count(scenes[ game.GetMap() ])) ], false )

		local version = vgui.Create( "DLabel", f )
		version:SetText( "Quantum Version: " .. Quantum.Version )
		version:SetFont( "q_text2" )
		version:SetTextColor( Color( 255, 255, 255, 80 ) )
		version:SizeToContents()
		version.w, version.h = version:GetSize()
		version:SetPos( padding, padding )

		local title = vgui.Create( "DLabel", f )
		title:SetText( Quantum.ServerTitle || "[ERROR COULD NOT FIND TITLE]" )
		title:SetFont( "q_title" )
		title:SetTextColor( Color( 255, 255, 255, 225 ) )
		title:SizeToContents()
		title.w, title.h = title:GetSize()
		title:SetPos( sw/2 - title.w/2, sh/5 - title.h/2 )
		title.x, title.y = title:GetPos()

		local sub = vgui.Create( "DLabel", f )
		sub:SetText( "Run by Quantum, created by AlmTech" )
		sub:SetFont( "q_subtitle" )
		sub:SetTextColor( Color( 255, 255, 255, 150 ) )
		sub:SizeToContents()
		sub.w, sub.h = sub:GetSize()
		sub:SetPos( sw/2 - sub.w/2, title.y + sub.h + padding*2.25 )
		sub.x, sub.y = sub:GetPos()


		---- BUTTONS ----

		-- play button
		local play = vgui.Create( "DButton", f )
		play:SetText( "Play" )
		play:SetFont( buttonFont )
		play:SetTextColor( buttonTextColor )

		play:SizeToContents()
		play.w, play.h = play:GetSize()
		play:SetSize( buttonWidth, play.h )
		play.w, play.h = play:GetSize()

		play:SetPos( sw/2 - play.w/2, sub.y + play.h + padding*20 )
		play.x, play.y = play:GetPos()

		play.Paint = function( self )
			theme.sharpbutton( self, buttonColor )
		end

		play.DoClick = function( self )
			surface.PlaySound( "UI/buttonclick.wav" )
			--charmenu.open( dt )
			f:Close()
		end
		play.OnCursorEntered = function() surface.PlaySound( "UI/buttonrollover.wav" ) end

		-- Settings button
		local settings = vgui.Create( "DButton", f )
		settings:SetText( "Settings" )
		settings:SetFont( buttonFont )
		settings:SetTextColor( buttonTextColor )

		settings:SizeToContents()
		settings.w, settings.h = settings:GetSize()
		settings:SetSize( buttonWidth, settings.h )
		settings.w, settings.h = settings:GetSize()

		settings:SetPos( sw/2 - settings.w/2, play.y + settings.h + padding*2 )
		settings.x, settings.y = settings:GetPos()

		settings.Paint = function( self )
			theme.sharpbutton( self, buttonColor )
		end
		settings.DoClick = function( self )
			surface.PlaySound( "UI/buttonclick.wav" )
		end
		settings.OnCursorEntered = function() surface.PlaySound( "UI/buttonrollover.wav" ) end

		-- Workshop button
		local ws = vgui.Create( "DButton", f )
		ws:SetText( "Steam Workshop" )
		ws:SetFont( buttonFont )
		ws:SetTextColor( buttonTextColor )

		ws:SizeToContents()
		ws.w, ws.h = ws:GetSize()
		ws:SetSize( buttonWidth, ws.h )
		ws.w, ws.h = ws:GetSize()

		ws:SetPos( sw/2 - ws.w/2, settings.y + ws.h + padding*2 )
		ws.x, ws.y = ws:GetPos()

		ws.Paint = function( self )
			theme.sharpbutton( self, buttonColor )
		end
		ws.DoClick = function( self )
			surface.PlaySound( "UI/buttonclick.wav" )
			gui.OpenURL( Quantum.WorkshopLink )
		end
		ws.OnCursorEntered = function() surface.PlaySound( "UI/buttonrollover.wav" ) end

		-- Discord server invite button
		local inv = vgui.Create( "DButton", f )
		inv:SetText( "Discord Invite" )
		inv:SetFont( buttonFont )
		inv:SetTextColor( buttonTextColor )

		inv:SizeToContents()
		inv.w, inv.h = inv:GetSize()
		inv:SetSize( buttonWidth, inv.h )
		inv.w, inv.h = inv:GetSize()

		inv:SetPos( sw/2 - inv.w/2, ws.y + inv.h + padding*2 )
		inv.x, inv.y = inv:GetPos()

		inv.Paint = function( self )
			theme.sharpbutton( self, buttonColor )
		end
		inv.DoClick = function( self )
			surface.PlaySound( "UI/buttonclick.wav" )
			gui.OpenURL( Quantum.DiscordInvite )
		end
		inv.OnCursorEntered = function() surface.PlaySound( "UI/buttonrollover.wav" ) end

		-- Quit button
		local quit = vgui.Create( "DButton", f )
		quit:SetText( "Disconnect" )
		quit:SetFont( buttonFont )
		quit:SetTextColor( buttonTextColor )

		quit:SizeToContents()
		quit.w, quit.h = quit:GetSize()
		quit:SetSize( buttonWidth, quit.h )
		quit.w, quit.h = quit:GetSize()

		quit:SetPos( sw/2 - quit.w/2, inv.y + quit.h + padding*2 )
		quit.x, quit.y = quit:GetPos()

		quit.Paint = function( self )
			theme.sharpbutton( self, buttonColor )
		end
		quit.DoClick = function( self )
			surface.PlaySound( "UI/buttonclick.wav" )
			surebox.open( "You are about to leave the server.", self:GetParent(), function() 
				LocalPlayer():ConCommand("disconnect")
			end)
		end
		quit.OnCursorEntered = function() surface.PlaySound( "UI/buttonrollover.wav" ) end

	end
end

return main