--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

                Quantum.Client.Cam = {}

function Quantum.Client.Cam.InvertAngle( ang ) return Angle( -ang.x, ang.y, -ang.z ) end -- Flip the camera 180* relative to target

function Quantum.Client.Cam.Start( scene, fov, velocity, loop )
    local frac = 0
    local time = velocity || 10 -- speed of the camera ( how long till it reaches its finish point )
    local scene_index = 1

    scene.pos2 = scene.pos2 || scene.pos1 -- if there is no finish pos then make it stay still at starting pos
    scene.ang2 = scene.ang2 || scene.ang1

    hook.Remove( "CalcView", "Quantum_Cinematic" ) -- if a cinematic is already running; cancel it

    hook.Add( "CalcView", "Quantum_Cinematic", function( ply, pos, ang, fov ) 
        frac = math.Clamp( frac + FrameTime()/velocity, 0, 1 )
        if( frac <= 0 ) then return end

        local view = {
            origin = LerpVector( frac, scene.pos1[scene_index], scene.pos2[scene_index] ),
            angles = LerpAngle( frac, scene.ang1[scene_index], scene.ang2[scene_index] ),
            fov = fov,
            drawviewer = true
        }

        if( view.origin:IsEqualTol( scene.pos2[scene_index], 2 ) ) then
            frac = 0
            scene_index = scene_index + 1
            if( scene_index > #scene.pos1 && loop ) then scene_index = 1 end -- if all scenes are finished, loop them if loop is enabled
            -- otherwise it will just stop at the end.
        end

        return view
    end)
end

function Quantum.Client.Cam.Stop() 
    hook.Remove( "CalcView", "Quantum_Cinematic" )
    Quantum.Debug( "Stopped cinematic." )
end