--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

local main = {}

local theme = Quantum.Client.Menu.GetAPI( "theme" )

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

function main.open(dt)

	if( !f ) then
		Quantum.Client.IsInMenu = true -- hide the hud

		local resScale = Quantum.Client.ResolutionScale
		local sw, sh = ScrW(), ScrH()
		local padding = 10 * resScale
		local padding_s = 4 * resScale

		local f = vgui.Create( "DFrame" )
		f:SetSize( sw, sh )
		f:SetTitle( "" )
		f:IsDraggable( false )
		f:MakePopup()
		f.Paint = function( self ) 
			theme.renderblur( self, 2, 7 )
		end
		f.OnClose = function( self )
			Quantum.Client.IsInMenu = false 
			Quantum.Client.Cam.Stop()
		end

		Quantum.Client.Cam.Start( scenes[ game.GetMap() ][math.random( 1, table.Count(scenes[ game.GetMap() ])) ], false )

	end
end

return main