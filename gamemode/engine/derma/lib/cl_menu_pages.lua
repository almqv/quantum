--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

local page = {}
local scale = Quantum.Client.ResolutionScale

function page.New( args )

    args.w, args.h = args.w, args.h || ScrW(), ScrH()
    args.x, args.y = args.x, args.y || 0, 0

    local p = vgui.Create( "DPanel", args.parent )
    p.w, p.h = args.w, args.h
    p.x, p.y = args.x, args.y

    p:SetSize( p.w, p.h )
    p:SetPos( p.x, p.y )
    p.Paint = args.Paint || function( self, w, h )
        -- Draw nothing, unless this function is overwritten
    end
    p.OnClose = args.OnClose || function() end

    local close = vgui.Create( "DButton", p )
    close:SetSize( 50 * scale, 20 * scale )
    close.DoClick = function() p:Close() end
    close.Paint = args.CloseButtonPaint || function( self, w, h ) 
        surface.SetDrawColor( 255, 60, 60, 255 )
        surface.DrawRect( 0, 0, w, h )
    end

    return p
end

return page