--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

include( "shared.lua" )

local pos
local ang
local mdlHeight
local p, q

local txtW, txtH 
local stationTbl
local stationName 

local barW, barH
local scale = Quantum.Client.ResolutionScale
local padding = 10 * scale

local txtAlpha = 0
local plDist

function ENT:Draw()
	stationTbl = Quantum.Station.Get( self:GetNWInt( "q_station_id" ) )

	if( stationTbl ) then
		stationName = stationTbl.name

		self:DrawModel() 

		if( stationTbl.showname == true ) then
			pos, ang = self:GetPos(), self:GetAngles()

			p, q = self:GetRenderBounds()
			mdlHeight = q.z - p.z

			pos = pos + ang:Up() * (mdlHeight + 20)

			-- rotate around axis
			ang:RotateAroundAxis( ang:Forward(), 90 )
			ang:RotateAroundAxis( ang:Right(), 90 )

			ang.y = LocalPlayer():EyeAngles().y - 90

			-- distance calc
			plDist = LocalPlayer():GetPos():Distance( self:GetPos() )
			txtAlpha = Lerp( plDist/400, 255, 0 )

			if( txtAlpha > 0 ) then
				cam.Start3D2D( pos, ang, 0.15 )
					surface.SetTextColor( Color( 255, 255, 255, txtAlpha ) )
					surface.SetFont( "q_title" )
					txtW, txtH = surface.GetTextSize( stationName )

					barW, barH = txtW + padding, txtH + padding

					surface.SetTextPos( -txtW/2, 0 )
					surface.DrawText( stationName )
				cam.End3D2D()
			end
		end
	end
end