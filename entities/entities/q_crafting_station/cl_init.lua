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

function ENT:Draw()
	self:DrawModel() 

	pos, ang = self:GetPos(), self:GetAngles()

	p, q = self:GetRenderBounds()
	mdlHeight = q.z - p.z

	pos = pos + ang:Up() * (mdlHeight + 10)

	-- rotate around axis

	cam.Start3D2D( pos, ang, 0.15 )
		surface.SetTextColor( Color( 255, 255, 255 ) )
		surface.SetFont( "q_title" )
		surface.DrawText( "aihofhsdifhiosdfh" )
	cam.End3D2D()
end