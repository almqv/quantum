--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

local menu = {}

local net = Quantum.Client.Menu.GetAPI( "net" )
local page = Quantum.Client.Menu.GetAPI( "page" )
local theme = Quantum.Client.Menu.GetAPI( "theme" )

local resScale = Quantum.Client.ResolutionScale
local sw, sh = ScrW(), ScrH()
local padding = 10 * resScale
local padding_s = 4 * resScale


local pages = {
    charCreate = function( parent )
        local pW, pH = parent:GetSize()
        local args = {
            CloseButtonText = "Return",
            CloseButtonFont = "q_text",
        }
        local p, c = page.New( parent, args )
        p:SetVisible( true )
		p.w, p.h = p:GetSize()

        c:SetSize( 85 * resScale, 25 * resScale )
        c.w, c.h = c:GetSize()
        c:SetPos( (p.w - c.w) - padding*4, (p.h - c.h) - padding*4 )
        c.DoClick = function()
            surface.PlaySound( "UI/buttonclick.wav" )
            parent.page:SetVisible( true )
            p:Remove()
        end

        local banner = vgui.Create( "DImage", p )
        banner:SetImage( Quantum.Client.ServerBannerPath )
        banner:SizeToContents()
        banner.w, banner.h = banner:GetSize()
        banner:SetSize( (banner.w * resScale)/2.8, (banner.h * resScale)/2.8 )
        banner.w, banner.h = banner:GetSize()
        banner:SetPos( (p.w - banner.w) + padding*2, 0 )

		local ip = vgui.Create( "DPanel", p ) -- input panel
		ip:SetSize( 400 * resScale, p.h * 0.9 )
		ip.w, ip.h = ip:GetSize()
		ip:SetPos( padding*4, p.h/2 - ip.h/2 )
		ip.Paint = function( self ) theme.blurpanel(self) end
        ip.x, ip.y = ip:GetPos()

        local header = vgui.Create( "DLabel", p )
        header:SetText( "Character Creation" )
        header:SetFont( "q_header" )
        header:SetTextColor( Color( 255, 255, 255, 255 ) )
        header:SizeToContents()
        header.w, header.h = header:GetSize()
        header:SetPos( (ip.x + ip.w/2) - header.w/2, header.h/2 )

        -- character model panel
        local mdl = vgui.Create( "DModelPanel", p )
		mdl:SetSize( 600 * resScale, 1000 * resScale )
		mdl.w, mdl.h = mdl:GetSize()
		mdl:SetPos( p.w/2 - mdl.w/2, p.h/2 - mdl.h/2 )
		mdl:SetFOV( 55 )
		function mdl:LayoutEntity( ent ) return end

		local inputs = {}
		
        local name = vgui.Create( "DTextEntry", p )
        name:SetText( "" )
        name:SetFont( "q_button2" )
        name:SetTextColor( Color( 255, 255, 255, 255 ) )
        name:SetSize( 300 * resScale, 40 * resScale )
        name.w, name.h = name:GetSize()
        name:SetPos( p.w/2 - name.w/2, p.h*0.85 - name.h/2 )
        name.Paint = function( self ) 
            theme.blurpanel( self ) 
            self:DrawTextEntryText( Color( 255, 255, 255, 255 ), Color( 150, 150, 150, 255 ), Color( 100, 100, 100, 255 ) )
        end
        --function name:OnChange() inputs.name = self:GetValue() end

		-- input panel contens --

        local rheader = vgui.Create( "DLabel", ip )
        rheader:SetText("Select Race")
        rheader:SetFont( "q_button2" )
        rheader:SetTextColor( Color( 255, 255, 255, 255 ) )
        rheader:SizeToContents()
        rheader.w, rheader.h = rheader:GetSize()
        rheader:SetPos( ip.w/2 - rheader.w/2, rheader.h )
        rheader.x, rheader.y = rheader:GetPos()

        local gbuttons = {}

        gbuttons.female = vgui.Create( "DButton", ip )
        local selectedGenderButton = gbuttons.female -- select itself
		gbuttons.female:SetText( "Female" )
		gbuttons.female:SetTextColor( Color( 0, 0, 0, 255 ) )
		gbuttons.female:SetFont( "q_button2" )
		gbuttons.female.Paint = function( self, w, h ) 
            theme.sharpbutton( self ) 
			if( selectedGenderButton == self ) then
                surface.SetDrawColor( 100, 100, 100, 100 )
                surface.DrawRect( 0, 0, w, h )
			end
        end
        gbuttons.female:SizeToContents()
		gbuttons.female.w, gbuttons.female.h = gbuttons.female:GetSize()
		gbuttons.female:SetPos( (ip.w - gbuttons.female.w) - padding - gbuttons.female.w/2, rheader.y + gbuttons.female.h + padding )
        gbuttons.female.x, gbuttons.female.y = gbuttons.female:GetPos()
		gbuttons.female.DoClick = function( self ) 
            if( selectedGenderButton ~= self ) then
                selectedGenderButton = self
                surface.PlaySound( "UI/buttonclick.wav" )
            end
		end

		gbuttons.male = vgui.Create( "DButton", ip )
        selectedGenderButton = gbuttons.male
		gbuttons.male:SetText( "Male" )
		gbuttons.male:SetTextColor( Color( 0, 0, 0, 255 ) )
		gbuttons.male:SetFont( "q_button2" )
		gbuttons.male:SetSize( gbuttons.female:GetSize() )
		gbuttons.male.w, gbuttons.male.h = gbuttons.male:GetSize() 
		gbuttons.male:SetPos( padding + gbuttons.male.w/2, rheader.y + gbuttons.male.h + padding )

		gbuttons.male.Paint = function( self, w, h ) 
            theme.sharpbutton( self ) 
			if( selectedGenderButton == self ) then
                surface.SetDrawColor( 100, 100, 100, 100 )
                surface.DrawRect( 0, 0, w, h )
			end
		end
        gbuttons.male.DoClick = function( self )
            if( selectedGenderButton ~= self ) then
                selectedGenderButton = self
                surface.PlaySound( "UI/buttonclick.wav" )
            end
        end

		
		
        --- set the model
        mdl:SetModel( Quantum.Models.Player.Male[1] ) -- set the char model
		local minv, maxv = mdl.Entity:GetRenderBounds()
		local eyepos = mdl.Entity:GetBonePosition( mdl.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) )
		eyepos:Add( Vector( 40, 0, -15 ) )
		mdl:SetCamPos( eyepos - Vector( -10, 0, -2 ) )
		mdl:SetLookAt( eyepos )

        return p, c
    end
}

function menu.open( dt )
    Quantum.Client.IsInMenu = true -- hide the hud
    if( !f ) then
        local f = vgui.Create( "DFrame" )
        f:SetTitle( "" )
        f:SetSize( sw, sh )
        f.Paint = function( self, w, h )
            surface.SetDrawColor( 0, 0, 0, 120 )
            surface.DrawRect( 0, 0, w, h )
        end
        f:SetDraggable( false )
        f:ShowCloseButton( false )
        f:MakePopup()
        function f:OnClose()
            Quantum.Client.IsInMenu = false -- show the hud when closed
        end

        local args = {
            CloseButtonText = "Quit",
            CloseButtonFont = "q_text"
        }
        local p, c = page.New( f, args )
        f.page = p
        f.page:SetVisible( true )

        local clist = vgui.Create( "DScrollPanel", p )
        clist:SetSize( 380 * resScale, sh - padding*15 )
        clist.w, clist.h = clist:GetSize()
        clist:SetPos( (sw - clist.w) - padding*2, padding*6 )
        clist.x, clist.y = clist:GetPos()
        clist.Paint = function( self, w, h )
            theme.blurpanel( self )
        end

        local sbar = clist:GetVBar()
        sbar:SetSize( 0, 0 ) -- Remove the scroll bar

        --- Close/quit button stuff ---
        local cW, cH = c:GetSize()
        c:SetPos( (clist.x + clist.w) - cW, clist.y + clist.h + cH )
        c.Paint = function( self ) theme.button( self ) end
        c.DoClick = function() 
            surface.PlaySound( "UI/buttonclick.wav" )
            f:Close() 
        end
        ---

        local banner = vgui.Create( "DImage", p )
        banner:SetImage( Quantum.Client.ServerBannerPath )
        banner:SizeToContents()
        banner.w, banner.h = banner:GetSize()
        banner:SetSize( (banner.w * resScale)/2.8, (banner.h * resScale)/2.8 )
        banner:SetPos( padding, padding )

        local header = vgui.Create( "DLabel", p )
        header:SetText( "Characters" )
        header:SetFont( "q_header" )
        header:SizeToContents()
        local headerW, headerH = header:GetSize()
        header:SetPos( clist.x + ( clist.w/2 - headerW/2 ), (clist.y - headerH) + padding/2 )
        header:SetTextColor( Color( 255, 255, 255, 255 ) )
        header.Paint = function( self, w, h ) end

        local chars = {}
        
        local cpanels = {}
        local selectedChar 
        local errorMdl = "models/player.mdl"

		if( selectedChar ) then
			-- Char model
			local mdl = vgui.Create( "DModelPanel", p )
			mdl:SetSize( 600 * resScale, 1000 * resScale )
			mdl.w, mdl.h = mdl:GetSize()
			mdl:SetPos( p.w/2 - mdl.w/2, p.h/2 - mdl.h/2 )
			mdl:SetFOV( 55 )
			function mdl:LayoutEntity( ent ) return end

		else

			local titles = {
				"404 - Characters not found :(",
				"No Characters Found"
			}

			local info = vgui.Create( "DLabel", p )
			info:SetText( titles[ math.random( 1, #titles ) ] )
			info:SetFont( "q_header" )
			info:SizeToContents()

			info.w, info.h = info:GetSize()

			info:SetPos( p.w/2 - info.w/2, p.h/2 - info.h/2 )

		end

        for k, v in pairs( chars ) do
            cpanels[k] = vgui.Create( "DButton", clist )

            cpanels[k].char = v -- give the panel it's character
            if( !selectedChar ) then selectedChar = cpanels[1] end -- select the first one

            cpanels[k]:SetText( "" )
            cpanels[k]:SetSize( clist.w - padding, 100 * resScale )
            cpanels[k].w, cpanels[k].h = cpanels[k]:GetSize()
            cpanels[k]:SetPos( padding/2, (padding)*k + (cpanels[k].h * (k-1)) )
            cpanels[k].Paint = function( self, w, h )
                surface.SetDrawColor( 0, 0, 0, 0 )
                surface.DrawRect( 0, 0, w, h )
                if( cpanels[k] == selectedChar ) then
                    surface.SetDrawColor( 252, 186, 3, 100 )
                    surface.DrawOutlinedRect( 0, 0, w, h )
                end
            end
            cpanels[k].DoClick = function( self ) -- if you press the char, then select it
                selectedChar = self
                surface.PlaySound( "UI/buttonclick.wav" )
                mdl:SetModel( self.char.model || errorMdl )
            end

            local txt = vgui.Create( "DLabel", cpanels[k] )
            txt:SetText( v.name || "NAME" )
            txt:SetFont( "q_charNameText" )
            txt:SetTextColor( Color( 200, 200, 200, 220 ) )
            txt:SizeToContents()
            local txtW, txtH = txt:GetSize()
            txt:SetPos( padding, cpanels[k].h/4 - txtH/2 )
            local txtX, txtY = txt:GetPos()

            local lvl = vgui.Create( "DLabel", cpanels[k] )
            lvl:SetText( "Level " .. v.lvl .. " Citizen" )
            lvl:SetFont( "q_text2" )
            lvl:SetTextColor( Color( 180, 180, 180, 225 ) )
            lvl:SizeToContents()
            local lvlW, lvlH = lvl:GetSize()
            lvl:SetPos( txtX, txtY + lvlH )
        end

		if( selectedChar ) then
			mdl:SetModel( selectedChar.char.model ) -- set the char model
			local minv, maxv = mdl.Entity:GetRenderBounds()
			local eyepos = mdl.Entity:GetBonePosition( mdl.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) )
			eyepos:Add( Vector( 40, 0, -15 ) )
			mdl:SetCamPos( eyepos - Vector( -10, 0, -2 ) )
			mdl:SetLookAt( eyepos )
		end

        -- create char button
        local cr = vgui.Create( "DButton", p )
        cr:SetText("Create New Character")
        cr:SetFont( "q_button" )
        cr:SetTextColor( Color( 0, 0, 0, 255 ) )
        cr:SizeToContents()
        cr.w, cr.h = cr:GetSize()
        cr:SetPos( clist.x + ( clist.w/2 - cr.w/2 ), clist.y + ( ( clist.h - cr.h ) - padding*2 ) )
        cr.Paint = function( self ) 
            theme.sharpbutton( self )
        end
        cr.DoClick = function()
            surface.PlaySound( "UI/buttonclick.wav" )
            p:SetVisible( false )
            local crPage = pages.charCreate( f )
        end
        
        cr.OnCursorEntered = function() surface.PlaySound( "UI/buttonrollover.wav" ) end

		if( selectedChar ) then
			-- Delete char button
			local dl = vgui.Create( "DButton", p )
			dl:SetText("Delete Character")
			dl:SetFont( "q_text" )
			dl:SetTextColor( Color( 0, 0, 0, 255 ) )
			dl:SizeToContents()
			dl.w, dl.h = dl:GetSize()
			dl:SetPos( clist.x, clist.y + ( clist.h + dl.h ) )
			dl.Paint = function( self ) 
				theme.button( self )
			end
			dl.DoClick = function()
				surface.PlaySound( "UI/buttonclick.wav" )
				LocalPlayer():ChatPrint( "Comming soon!" )
			end
			
			dl.OnCursorEntered = function() surface.PlaySound( "UI/buttonrollover.wav" ) end
		end
    end
end

return menu