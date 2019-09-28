--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

local menu = {}

local net = Quantum.Client.Menu.GetAPI( "net" )

function menu.open( dt )
    local sw, sh = ScrW(), ScrH()
    if( !f ) then
        local f = vgui.Create( "DFrame" )
        f:SetTitle( "Character Menu" )
        f:SetSize( sw, sh )
        f:MakePopup()

        local txt = vgui.Create( "DTextEntry", f )
        txt:SetText( "Enter name here" )
        txt:SetSize( 250, 25 )
        local txtW, txtH = txt:GetSize()
        txt:SetPos( sw/2 - txtW/2, sh/2 - txtH/2 )
        local txtX, txtY = txt:GetPos()

        local b = vgui.Create( "DButton", f )
        b:SetText( "Create Char" )
        b:SizeToContents()
        local bW, bH = b:GetSize()
        b:SetPos( sw/2 - bW/2, txtY - bH )
        b.DoClick = function()
            net.RunNetworkedFunc( "createChar", { name = txt:GetValue() } )
        end
    end
end

return menu