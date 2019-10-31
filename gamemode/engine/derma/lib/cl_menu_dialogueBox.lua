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

function log.createinfobox( text, parent )
    local box = vgui.Create( "DPanel", parent )
    box:SetSize( 250 * scale, 80 * scale )
    box.Paint = function( self ) theme.panel( self, Color( 0, 0, 0, 100 ) )
    box.w, box.h = box:GetSize()

    local scroll = vgui.Create( "DScrollPanel", box )
    --scroll:SetSize()

    return box
end