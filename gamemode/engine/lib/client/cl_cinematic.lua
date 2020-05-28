--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

				Quantum.Client.Cam = {}

function Quantum.Client.Cam.InvertAngle( ang ) return Angle( ang.x, -ang.y, ang.z ) end -- Flip the camera 180* relative to target

function Quantum.Client.Cam.Stop() 
	hook.Remove( "CalcView", "Quantum_Cinematic" )
	Quantum.Client.Cam.Temp = nil -- remove the var becuase it is unneeded
end

function Quantum.Client.Cam.Start( scene, loop, drawviewer )
	drawviewer = drawviewer || false
	if( scene == nil ) then
		Quantum.Error( "Scene does not exist! Aborting..." )
		return
	end

	local frac = 0
	local time -- speed of the camera ( how long till it reaches its finish point )
	local fov 
	Quantum.Client.Cam.Temp = {}
	Quantum.Client.Cam.Temp.Finished = false
	Quantum.Client.Cam.Temp.scene_index = 1

	local view = {} -- calcview vector data

	hook.Remove( "CalcView", "Quantum_Cinematic" ) -- if a cinematic is already running; cancel it

	hook.Add( "CalcView", "Quantum_Cinematic", function( ply, pos, ang, fov )
		time = scene[Quantum.Client.Cam.Temp.scene_index].velocity || 5
		fov = scene[Quantum.Client.Cam.Temp.scene_index].fov || 20
		frac = math.Clamp( frac + FrameTime()/time, 0, 1 )
		if( frac <= 0 ) then return end

		scene[Quantum.Client.Cam.Temp.scene_index].pos2 = scene[Quantum.Client.Cam.Temp.scene_index].pos2 || scene[Quantum.Client.Cam.Temp.scene_index].pos1 -- if there is no finish pos then make it stay still at starting pos
		scene[Quantum.Client.Cam.Temp.scene_index].ang2 = scene[Quantum.Client.Cam.Temp.scene_index].ang2 || scene[Quantum.Client.Cam.Temp.scene_index].ang1

		view.origin = LerpVector( frac, scene[Quantum.Client.Cam.Temp.scene_index].pos1, scene[Quantum.Client.Cam.Temp.scene_index].pos2 )
		view.angles = LerpAngle( frac, scene[Quantum.Client.Cam.Temp.scene_index].ang1, scene[Quantum.Client.Cam.Temp.scene_index].ang2 )
		view.fov = fov
		view.drawviewer = drawviewer

		if( view.origin:IsEqualTol( scene[Quantum.Client.Cam.Temp.scene_index].pos2, 1 ) ) then
			if( Quantum.Client.Cam.Temp.scene_index + 1 <= #scene ) then
				frac = 0
				Quantum.Client.Cam.Temp.scene_index = Quantum.Client.Cam.Temp.scene_index + 1
			else
				Quantum.Client.Cam.Temp.Finished = true -- tell the menu that the scene is finished
			end
			if( Quantum.Client.Cam.Temp.scene_index > #scene ) then -- if all scenes are finished, loop them if loop is enabled
				Quantum.Client.Cam.Temp.scene_index = 1 
			end 
			-- otherwise it will just stop at the end.
		end

		return view
	end)
end

