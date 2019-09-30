--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

local menu = {}

local net = Quantum.Client.Menu.GetAPI( "net" )
local page = Quantum.Client.Menu.GetAPI( "page" )

local resScale = Quantum.Client.ResolutionScale
local sw, sh = ScrW(), ScrH()
local padding = 10 * resScale


local pages = {
    charSelect = function( parent )
        local args = {
            CloseButtonText = "Back",
            CloseButtonFont = "q_text",
        }
        local p, c = page.New( parent, args )

        local clist = vgui.Create( "DPanel", p )
        clist:SetSize( 200 * resScale, sh - padding*10 )
        clist.w, clist.h = clist:GetSize()
        clist:SetPos( (sw - clist.w) - padding*2, sh/2 - clist.h/2 )
        clist.Paint = function( self, w, h )
            surface.SetDrawColor( 0, 0, 0, 200 )
            surface.DrawRect( 0, 0, w, h )
        end

        return p
    end,
    charCreate = function( parent )
        local pW, pH = parent:GetSize()
        local args = {
            CloseButtonText = "Return",
            CloseButtonFont = "q_text",
        }
        local p, c = page.New( parent, args )

        c:SetSize( 85 * resScale, 25 * resScale )
        local closeW, closeH = c:GetSize()
        c:SetPos( padding*4, (pH - closeH) - padding*4 )

        return p
    end
}

function menu.open( dt )
    
    if( !f ) then
        local f = vgui.Create( "DFrame" )
        f:SetTitle( "Character Menu" )
        f:SetSize( sw, sh )
        f.Paint = function( self, w, h )
            surface.SetDrawColor( 0, 0, 0, 190 )
            surface.DrawRect( 0, 0, w, h )
        end
        f:SetDraggable( false )
        f:MakePopup()

        local char = pages.charCreate( f ) -- test
    end
end

return menu