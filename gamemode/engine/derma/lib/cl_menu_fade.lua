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

function fade.menuTransition( parent, dt, delay, inColor, isBlur, startFunc, endFunc )

	startFunc( dt )
	local color = inColor || Color( 0, 0, 0, 255 )

	local p = vgui.Create( "DPanel" )
	p.frac = startFrac || 0
	p.time = 0
	p.fadeIn = true
	p.starttime = CurTime()
	p:SetSize( sw, sh )
	p:SetPos( 0, 0 )
	p.Paint = function( self, w, h )

		if( isBlur ) then theme.renderBlur( self, Lerp( self.frac, 0, 4 ), Lerp( self.frac, 0, 8 ) ) end -- render blur 

		surface.SetDrawColor( color )
		surface.SetAlphaMultiplier( self.frac )

		surface.DrawRect( 0, 0, w, h )
	end

	p.Think = function( self )
		self.time = CurTime() - self.starttime

		if( self.fadeIn ) then self.frac = math.Clamp( self.time / delay, 0, 1 ) else self.frac = math.Clamp( self.time / delay, 1, 0 ) end

		if( self.time >= delay && self.fadeIn ) then
			self.fadeIn = false				-- reset the timer and invert the fading process
			self.time = 0
			parent:Remove() -- remove the parent
		elseif( self.time >= delay && !self.fadeIn ) then
			if( !self.runnedEndFunc ) then 
				endFunc( dt )
				self.runnedEndFunc = true
				self:Remove() -- remove the panel when done
			end
		end
	end
end

return fade