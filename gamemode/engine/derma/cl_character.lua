--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

local function char_derma()
    local sw, sh = ScrW(), ScrH()
    if( !f ) then
        local f = vgui.Create( "DFrame" )
        f:SetTitle( "Character Derma" )
        f:SetSize( sw, sh )
    end
end