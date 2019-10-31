--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

local log = {}
local scale = Quantum.Client.ResolutionScale
local padding = 10 * scale
local padding_s = 4 * scale

local theme = Quantum.Client.Menu.GetAPI( "theme" )

function log.createinfobox( title, text, parent )
    local fw, fh = parent:GetSize()
    local box = vgui.Create( "DPanel", parent )
    box:SetSize( 775 * scale, 200 * scale )
    box.Paint = function( self ) theme.blurpanel( self, Color( 0, 0, 0, 0 ) ) end
    box.w, box.h = box:GetSize()
    box:SetPos( fw/2 - box.w/2, fh*0.8 - box.h/2 ) -- fix this bug pls
    box.x, box.y = box:GetSize()

    local header = vgui.Create( "DLabel", parent )
    header:SetText( title )
    header:SetFont( "q_header_s" )
    header:SetTextColor( Color( 255, 255, 255, 220 ) )
    header:SizeToContents()
    header.w, header.h = header:GetSize()
    header:SetPos( box.x - box.w/2 + header.w/2, box.y )

    local scroll = vgui.Create( "DScrollPanel", box )
    scroll:SetSize( box:GetSize() )
    scroll.Paint = function( self ) end
    local sb = scroll:GetVBar()
    sb.Paint = function( self ) end
    function sb.btnGrip:Paint() 
        theme.button( self, Color( 0, 0, 0, 80 ) ) 
    end
    sb.btnUp:SetSize(0,0)
    sb.btnDown:SetSize(0,0)


    return box
end

return log