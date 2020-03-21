--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

local intro = {}

local log = Quantum.Client.Menu.GetAPI( "dialogue" )
local theme = Quantum.Client.Menu.GetAPI( "theme" )
local fade = Quantum.Client.Menu.GetAPI( "fade" )

local scenes = { 
	["rp_truenorth_v1a_livin"] = {
		[1] = {
			fov = 70,
			velocity = 12,
			pos1 = Vector(5062.544434, 3264.783447, 136.604355),
			pos2 = Vector(5031.821777, 3866.334961, 120.090790),
			ang1 = Angle(0.370070, 90.952415, 0.000000),
			ang2 = Angle(0.898059, 56.421352, 0.000000) 
		},
		[2] = { 
			fov = 80,
			velocity = 12,
			pos1 = Vector(6879, 4135, 72),
			pos2 = Vector(8760, 2740, 86),
			ang1 = Angle(0.686861, -43.159401, 0.000000),
			ang2 = Angle(1, -104, 0) 
		},
		[3] = {
			fov = 70,
			velocity = 12,
			pos1 = Vector( 8917, 2194, 83 ),
			pos2 = Vector( 8312, 2265, 83 ),
			ang1 = Angle( 2, -123, 0 ),
			ang2 = Angle( 3, -41, 0 )
		}, 
		[4] = {
			fov = 70,
			velocity = 12,
			pos1 = Vector( 10860.154297, 3337.662109, 141.101013 ),
			pos2 = Vector( 10881.356445, 5483.074219, 132.792114 ),
			ang1 = Angle( 0.052806, 85.319626, 0.000000 ),
			ang2 = Angle( -0.105593, 90.978638, 0.000000 )
		},
		[5] = {
			fov = 60,
			velocity = 16,
			pos1 = Vector( 6830.229004, 9614.283203, 105.920792 ),
			pos2 = Vector( 6675.346191, 9711.740234, 102.549484 ),
			ang1 = Angle( 1.055771, 147.803604, 0.000000 ),
			ang2 = Angle( 1.055771, 149.803604, 0.000000 )
		},
		[6] = {
			fov = 60,
			velocity = 15,
			pos1 = Vector( 3114.608887, -13817.962891, 82.778885 ),
			pos2 = Vector( 5247.718262, -14413.496094, 74.946350 ),
			ang1 = Angle( 0.844603, -15.770578, 0.000000 ),
			ang2 = Angle( 2.006202, 37.927032, 0.000000 )
		},
		[7] = {
			fov = 60,
			velocity = 14,
			pos1 = Vector( 4964.591797, 4514.272461, 213.532272 ),
			pos2 = Vector( 5047.838379, 3216.407959, 128.219254 ),
			ang1 = Angle( 8.131199, -77.082695, 0.000000 ),
			ang2 = Angle( 0.422407, -89.520081, 0.000000 )
		}
	},

	["rp_dunwood_eu"] = {
		[1] = {
			fov = 80,
			velocity = 12,
			pos1 = Vector( 3900.0373535156, -3459.8254394531, 1928.1319580078 ),
			pos2 = Vector( 4706.26953125, -4947.5844726563, 1841.9495849609 ),
			ang1 = Angle( 4.5935039520264, -33.771461486816, 0 ),
			ang2 = Angle( 3.0622990131378, -4.2035503387451, 0 )
		},
		[2] = { 
			fov = 70,
			velocity = 12,
			pos1 = Vector( 3029.4631347656, 1975.4969482422, 323.03317260742 ),
			pos2 = Vector( 2984.1782226563, 1293.4967041016, 320.60958862305 ),
			ang1 = Angle( 2.5343189239502, -101.2608795166, 0 ),
			ang2 = Angle( 0.95032584667206, -131.14338684082, 0 )
		},
		[3] = {
			fov = 70,
			velocity = 12,
			pos1 = Vector( 763.47644042969, 45.709754943848, 320.53189086914 ),
			pos2 = Vector( 746.17907714844, 4470.6206054688, 341.65856933594 ),
			ang1 = Angle( -0.03213819861412, 90.368942260742, 0 ),
			ang2 = Angle( -0.29613819718361, 90.210556030273, 0 )
		}, 
		[4] = {
			fov = 70,
			velocity = 12,
			pos1 = Vector( -1109.5668945313, 3873.0493164063, 3774.078125 ),
			pos2 = Vector( -1102.1696777344, 4070.5539550781, 3973.8828125 ),
			ang1 = Angle( -36.716876983643, 146.30101013184, 0 ),
			ang2 = Angle( -46.009662628174, -143.79263305664, 0 )
		},
		[5] = {
			fov = 60,
			velocity = 16,
			pos1 = Vector( -9168.173828125, 3501.13671875, 8610.853515625 ),
			pos2 = Vector( -10148.767578125, -4350.7163085938, 1860.8051757813 ),
			ang1 = Angle( 48.132801055908, -50.447017669678, 0 ),
			ang2 = Angle( 21.969816207886, -154.96385192871, 0 )
		},
		[6] = {
			fov = 60,
			velocity = 15,
			pos1 = Vector( 8437.771484375, 13937.401367188, 1746.5352783203 ),
			pos2 = Vector( 3200.0029296875, 14697.87109375, 2583.8791503906 ),
			ang1 = Angle( -1.2141468524933, -164.51931762695, 0 ),
			ang2 = Angle( -29.039636611938, -123.28386688232, 0 )
		},
		[7] = {
			fov = 60,
			velocity = 14,
			pos1 = Vector( 2833.5769042969, 14572.4609375, 85.577995300293 ),
			pos2 = Vector( 4496.3881835938, 14495.8671875, 84.486724853516 ),
			ang1 = Angle( -0.63365286588669, -4.9319581985474, 0 ),
			ang2 = Angle( -2.0592522621155, 42.27123260498, 0 )
		}
	},
	["rp_southside_day"] = {
		[1] = {
			fov = 70,
			velocity = 12,
			pos1 = Vector( 1368.4291992188, 10858.263671875, 223.4137878418 ),
			pos2 = Vector( 696.99578857422, 10961.203125, 225.74652099609 ), 
			ang1 = Angle( 0.68631637096405, 165.18278503418, 0 ),
			ang2 = Angle( 0.26391625404358, 94.69450378418, 0 )
		},
		[2] = { 
			fov = 70,
			velocity = 16,
			pos1 = Vector( 5267.8354492188, -4528.1293945313, -237.05120849609 ),
			pos2 = Vector( 5230.59375, -5460.64453125, -247.05084228516 ),
			ang1 = Angle( 0.6544576883316, -113.82953643799, 0 ),
			ang2 = Angle( -0.71832829713821, 34.855682373047, 0 )
		},
		[3] = {
			fov = 70,
			velocity = 12,
			pos1 = Vector( 4746.53125, -820.14733886719, 245.23054504395 ),
			pos2 = Vector( 6370.482421875, -690.12646484375, 247.95965576172 ),
			ang1 = Angle( -1.5520542860031, 53.9260597229, 0 ),
			ang2 = Angle(  0.34874564409256, 132.33442687988, 0 )
		}, 
		[4] = {
			fov = 70,
			velocity = 12,
			pos1 = Vector( 11100.685546875, -13623.026367188, -142.84210205078 ),
			pos2 = Vector( 11690.620117188, -13346.670898438, -172.52095031738 ),
			ang1 = Angle( 2.8831143379211, 25.221273422241, 0 ),
			ang2 = Angle( 1.5103136301041, 28.336471557617, 0 )
		},
		[5] = { 
			-- this map is a pure 11/10
			-- for anyone reading this comment
			-- download it now
			fov = 60,
			velocity = 16,
			pos1 = Vector( 7247.7075195313, 5512.6494140625, 295.15692138672 ),
			pos2 = Vector( 7598.7036132813, 5533.30078125, 287.36376953125 ),
			ang1 = Angle( 2.0800724029541, -169.9822845459, 0 ),
			ang2 = Angle( 1.7104697227478, 13.814577102661, 0 )
		},
		[6] = {
			fov = 60,
			velocity = 15,
			pos1 = Vector( 8438.470703125, 7902.5375976563, 333.31167602539 ),
			pos2 = Vector( 7957.5356445313, 7892.7924804688, 295.12298583984 ),
			ang1 = Angle( 89, -0.53721868991852, 0 ),
			ang2 = Angle( -0.76005762815475, 114.73434448242, 0 )
		},
		[7] = {
			fov = 60,
			velocity = 14,
			pos1 = Vector( -1782.0749511719, 9614.71484375, 207.95947265625 ),
			pos2 = Vector( -1143.5295410156, 9264.28125, 215.28564453125 ),
			ang1 = Angle( -0.39047741889954, -46.171054840088, 0 ),
			ang2 = Angle( -0.39047738909721, -12.801494598389, 0 )
		}
	}
}


function intro.open()
	local resScale = Quantum.Client.ResolutionScale
	local sw, sh = ScrW(), ScrH()
	local padding = 10 * resScale
	local padding_s = 4 * resScale

	if( !f ) then

		Quantum.Client.IsInMenu = true -- hide the hud

		local f = vgui.Create( "DFrame" )
		f:SetSize( sw, sh )
		f:SetTitle( "" )
		f:ShowCloseButton( false )
		f.Paint = function( self, w, h ) 
			surface.SetDrawColor( Color( 20, 20, 20, 255 ) )
			local height = 90 * resScale
			surface.DrawRect( 0, 0, w, 90 * resScale )
			surface.DrawRect( 0, h - height, w, height )
		end
		f:SetDraggable( false )
		f:MakePopup()
		function f:OnClose() 
			Quantum.Client.IsInMenu = false 
			Quantum.Client.Cam.Stop() -- stop the cinematic
		end
		f.w, f.h = f:GetSize()

		f.Think = function( self )
			if( Quantum.Client.Cam.Temp ) then
				if( Quantum.Client.Cam.Temp.Finished == true ) then -- if the scene is finished then close the menu and exit the cinematic
					fade.transition( f, {}, 1, 1, 1, Color( 0, 0, 0, 255 ), true, Quantum.EmptyFunction, function() 
					    Quantum.Client.IsInMenu = false 
					end)
				end 
			end
		end

		--- MUSIC ---
		--surface.PlaySound( "music/HL1_song10.mp3" ) -- too short
		--surface.PlaySound( "music/HL2_song23_SuitSong3.mp3" )
		--LocalPlayer():EmitSound("Quantum_Music_TriangeAtDawn") 

		local skip = vgui.Create( "DButton", f )
		skip:SetText( "Skip Intro" )
		skip:SetFont( "q_button_m" )
		skip:SetTextColor( Color( 255, 255, 255, 255 ) )
		skip:SizeToContents()
		skip.Paint = function( self ) theme.skipbutton( self, Color( 0, 0, 0, 0 ) ) end
		skip.w, skip.h = skip:GetSize()
		skip:SetPos( f.w - skip.w - padding, f.h - skip.h - padding )
		skip.DoClick = function( self ) 
			surface.PlaySound( "UI/buttonclick.wav" )
			fade.transition( f, {}, 1, 1, 2, Color( 0, 0, 0, 255 ), true, Quantum.EmptyFunction, function() 
				Quantum.Client.IsInMenu = false -- close intro but smoothly
			end)
		end
		skip.OnCursorEntered = function() surface.PlaySound( "UI/buttonrollover.wav" ) end

		if( scenes[ string.lower(game.GetMap()) ] ) then
			Quantum.Client.Cam.Start( scenes[string.lower(game.GetMap())], false ) -- start the cinematic
		else
			Quantum.Error( "Unable to get map scenes. Aborting cinematic intro..." )
			fade.transition( f, {}, 1, 1, 1, Color( 0, 0, 0, 255 ), true, Quantum.EmptyFunction, function() Quantum.Client.IsInMenu = false end )
			return 
		end

		local logdata = {
			[1] = {
				title = "Welcome!",
				text = "Welcome to the server! This server is running the Quantum framework which was developed by AlmTech.\n\nDuring this awesome cinematic you will be shown what you can do on the server. Starting with the basics."
			},
			[2] = {
				title = "Classes & Professions",
				text = "Professions are the core gameplay where they can unlock certian abilities to craft, cook and gather certain resources. You can learn a profession at any teacher NPC.\n\nYou can have the maximum of 2 professions and if you are skilled enough then some players might hire you."
			},
			[3] = {
				title = "Classes & Professions",
				text = "Professions are important where they could lead you to many opportunities.\nThe items produced by certain professions could be sold or traded to NPCs and other players. But keep in mind that everyone might not be as trustworthy as you would have thought."
			},
			[4] = {
				title = "Classes & Professions",
				text = "Character classes are also one of many key element to the core gameplay. Some character classes are better at certain things but worse at other things, but your class does not define your journey and you have the freedom to choose whatever you want to do."
			},
			[5] = {
				title = "Factions & Zones",
				text = "As a citizen on the server you can join or create your own faction. Factions are considered as an organization where players can band together to achieve goals and dominate a certain area on the map. But be aware that there exists more than one faction." 
			},
			[6] = {
				title = "Factions & Zones",
				text = "All factions can controll zones if they have enough resources. Some zones/areas of the map contain different resources than others, therefore they might be more valuable to the other factions.\nA zone can be taken over by any faction but there might be competition which might conclude in a war."
			},
			[7] = {
				title = "Questions & Help",
				text = "If you have any questions about the server just join our discord server and we will be more than happy to give you a answer. If you need help with something in-game then you might consider contacting a 'Server-Master' which are the moderators of the server. Good luck!"
			}
		}

		local box = log.createinfobox( logdata, f )
	end
end

return intro
