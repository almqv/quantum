--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

local menu = {}

function menu.open( dt )
    local sw, sh = ScrW(), ScrH()
    if( !f ) then
        local f = vgui.Create( "DFrame" )
        f:SetTitle( "Character Menu" )
        f:SetSize( sw, sh )

        local txt = vgui.Create( "DTextEntry" )
        txt:SetText( "Enter name here" )
        txt:SizeToContents()
        txt:SetPos( 100, 100 )

        local b = vgui.Create( "DButton" )
        b:SetText( "Create Char" )
        b:SizeToContents()
        b.DoClick = function()
            net.Start( "quantum_menu_button_net" )
                net.WriteString( "createchar" )
                net.WriteTable( { name = txt:GetValue() } )
            net.SendToServer()
        end
    end
end

return menu