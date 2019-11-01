--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

local intro = {}

local log = Quantum.Client.Menu.GetAPI( "dialogue" )
local theme = local log = Quantum.Client.Menu.GetAPI( "themes" )

local scenes = {
    ["rp_truenorth_v1a_livin"] = {
        [1] = { 
            fov = 80,
            velocity = 10,
            pos1 = Vector(6879, 4135, 72),
            pos2 = Vector(8760, 2740, 86),
            ang1 = Angle(7, 122, 0),
            ang2 = Angle(1, -104, 0) 
        },
        [2] = {
            fov = 60,
            velocity = 8,
            pos1 = Vector( 8917, 2194, 83 ),
            pos2 = Vector( 8312, 2265, 83 ),
            ang1 = Angle( 2, -123, 0 ),
            ang2 = Angle( 3, -41, 0 )
        }
    }
}

function intro.open( dt )
    local chars = dt.cont
    local resScale = Quantum.Client.ResolutionScale
    local sw, sh = ScrW(), ScrH()
    local padding = 10 * resScale
    local padding_s = 4 * resScale

    if( !f ) then

        Quantum.Client.IsInMenu = true -- hide the hud

        local f = vgui.Create( "DFrame" )
        f:SetSize( sw, sh )
        f:SetTitle( "" )
        f.Paint = function( self, w, h ) 
            surface.SetDrawColor( Color( 20, 20, 20, 255 ) )
            local height = 90 * resScale
            surface.DrawRect( 0, 0, w, 90 * resScale )
            surface.DrawRect( 0, h - height, w, height )
        end
        f:SetDraggable( false )
        f:MakePopup()
        function f:OnClose() 
            Quantum.Client.IsInMenu = false 
            Quantum.Client.Cam.Stop() -- stop the cinematic
        end

        local skip = vgui.Create( "DButton", f )
        skip:SetText( "Skip Intro" )
        skip:SetFont( "q_button_m" )
        skip:SetTextColor( Color( 255, 255, 255, 255 ) )
        skip:SizeToContents()
        skip.Paint = function( self ) theme.skipbutton( self ) end

        Quantum.Client.Cam.Start( scenes[game.GetMap()], false ) -- start the cinematic

        local logdata = {
            [1] = {
                title = "Welcome!",
                text = "Welcome to the server! This server is running the Quantum framework which was developed by AlmTech.\n\nDuring this awesome cinematic you will be shown what you can do on the server. Starting with the basics."
            },
            [2] = {
                title = "Classes & Professions",
                text = "You can learn a profession at any teacher NPC. Professions unlocks certian abilities to craft, cook and gather certain resources."
            },
            [3] = {
                title = "Classes & Professions",
                text = "Some character classes are better at certain things but worse at other things."
            }
        }

        local box = log.createinfobox( logdata, f )
    end
end

return intro