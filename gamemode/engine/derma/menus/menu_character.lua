--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

local menu = {}

local net = include( "../lib/cl_network.lua" )

function menu.open( dt )
    local sw, sh = ScrW(), ScrH()
    if( !f ) then
        local f = vgui.Create( "DFrame" )
        f:SetTitle( "Character Menu" )
        f:SetSize( sw, sh )
        f:MakePopup()

        local txt = vgui.Create( "DTextEntry", f )
        txt:SetText( "Enter name here" )
        txt:SizeToContents()
        txt:SetPos( 100, 100 )

        local b = vgui.Create( "DButton", f )
        b:SetText( "Create Char" )
        b:SizeToContents()
        b.DoClick = function()
            net.RunNetworkedFunc( "createChar", { name = txt:GetValue() } )
        end
    end
end

return menu