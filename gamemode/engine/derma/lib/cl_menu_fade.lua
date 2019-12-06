--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

local fade = {}

local scale = Quantum.Client.ResolutionScale
local padding = math.Round( 10 * scale )
local padding_s = math.Round( 4 * scale )

local sw, sh = ScrW(), ScrH()

local theme = Quantum.Client.Menu.GetAPI("theme")

local function changeAlpha( clr, alpha )
	return Color( clr.r, clr.g, clr.b, alpha )
end

function fade.transition( parent, dt, start_delay, mid_delay, end_delay, inColor, isBlur, startFunc, endFunc )
	local color = inColor || Color( 0, 0, 0, 255 )

	local p = vgui.Create( "DPanel" )
	p.frac = startFrac || 0
	p.time = 0
	p.fadeIn = true
	p.starttime = CurTime()
	p:SetSize( sw, sh )
	p:SetPos( 0, 0 )
	p:MakePopup() -- make it so the player cant move around
	p.Paint = function( self, w, h )

		if( isBlur ) then theme.renderblur( self, Lerp( self.frac, 0, 4 ), Lerp( self.frac, 0, 8 ) ) end -- render blur 
		surface.SetDrawColor( changeAlpha( color, 255 * self.frac ) )

		surface.DrawRect( 0, 0, w, h )
	end

	p.Think = function( self )
		self.time = CurTime() - self.starttime

		if( self.fadeIn ) then self.frac = Lerp( self.time / start_delay, 0, 1 ) else self.frac = Lerp( self.time / end_delay, 1, 0 ) end

		if( self.time >= start_delay && self.fadeIn ) then

			parent:Remove() -- remove the parent
			Quantum.Client.Cam.Stop() -- stop the cinematic (if it exists)

			if( !self.recordedMidStart ) then
				self.midtrans_start = CurTime()
				self.recordedMidStart = true
			end

			if( !self.runnedStartFunc ) then
				if( CurTime() - self.midtrans_start >= mid_delay ) then
					startFunc( dt )
					self.runnedStartFunc = true

					self.fadeIn = false				-- reset the timer and invert the fading process
					self.time = 0
					self.starttime = CurTime()
				end
			end

			Quantum.Debug("[Fade] First part done.")

		elseif( self.time >= end_delay && !self.fadeIn ) then

			if( !self.runnedEndFunc ) then 

				endFunc( dt )
				self.runnedEndFunc = true
				self:Remove() -- remove the panel when done
				Quantum.Debug( "[Fade] Finished transition." )

			end

		end
	end
end

return fade