--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

local theme ={}
local scale = Quantum.Client.ResolutionScale
local padding = 10 * scale
local padding_s = 4 * scale

function theme.panel( p, color )
    local w, h = p:GetSize()
    local clr = color || Color( 0, 0, 0, 100 )
    local bclr = Color( 50, 50, 50, 105 ) 

    draw.RoundedBox( 6, 0, 0, w, h, bclr ) -- border
    draw.RoundedBox( 4, padding_s/2, padding_s/2, w - padding_s, h - padding_s, clr ) -- inner
end

function theme.button( b, color )
    local w, h = b:GetSize()
    local clr = color || Color( 225, 44, 52, 255 )
    local bclr = Color( 50, 50, 50, 255 ) 

    if( b:IsHovered() ) then
        bclr = Color( 205, 205, 205, 255 )
    else
        bclr = Color( 50, 50, 50, 255 ) 
    end
    draw.RoundedBox( 6, 0, 0, w, h, bclr ) -- border
    draw.RoundedBox( 4, padding_s/2, padding_s/2, w - padding_s, h - padding_s, clr ) -- inner
end

return theme