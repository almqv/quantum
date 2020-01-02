--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

local iteminfo = {}

local scale = Quantum.Client.ResolutionScale
local padding = math.Round( 10 * scale )
local padding_s = math.Round( 4 * scale )

local theme = Quantum.Client.Menu.GetAPI( "theme" )

local function resizePanel( p )
	p:SizeToChildren( true, true )
	p.w, p.h = p:GetSize() 
	p:SetSize( p.w + padding_s, p.h + padding_s )
	p.w, p.h = p:GetSize()
	return p.w, p.h
end

function iteminfo.dropamount( p, page, itemPanel )
	local index = p.index
	local item = p.item
	local amountInSlot = p.amount

	local dropAmount = 0

	local back = vgui.Create( "DPanel", page )
	back:SetSize( page:GetSize() )
	back.w, back.h = back:GetSize()
	back.Paint = function( self ) theme.renderblur( self, 4, 8 ) end

	local dp = vgui.Create( "DPanel", back )
	dp:SetSize( 300 * scale, 120 * scale )
	dp.w, dp.h = dp:GetSize()
	dp:SetPos( back.w/2 - dp.w/2, back.h/2 - dp.h/2 )
	dp.Paint = function( self ) theme.sharpblurpanel( self ) end ---- DROP NET HERE ----

	local spacing = padding*4

	local amountEntry = vgui.Create( "DNumberWang", dp )
	amountEntry:SetValue( amountInSlot )
	amountEntry:SetFont( "q_item_option_dropval" )
	amountEntry:SetTextColor( Color( 255, 255, 255, 255 ) )
	amountEntry:SizeToContents()
	amountEntry.w, amountEntry.h = amountEntry:GetSize()
	amountEntry:SetSize( amountEntry.w + padding, amountEntry.h + padding )
	amountEntry.w, amountEntry.h = amountEntry:GetSize()
	amountEntry:SetContentAlignment( 5 )

	amountEntry:SetPos( dp.w/2 - amountEntry.w/2, dp.h/2 - amountEntry.h/2 )
	amountEntry.Paint = function( self )
		self:DrawTextEntryText( Color( 255, 255, 255, 255 ), Color( 200, 200, 200, 255 ), Color( 150, 150, 150, 255 ) )
		theme.borderpanel( self, Color( 150, 150, 150, 190 ) )
	end

	amountEntry:SetMax( amount )
	amountEntry:SetMin( 1 )
	amountEntry:SetDecimals( 0 )

	local drop = vgui.Create( "DButton", dp )
	drop:SetText( "Drop" )
	drop:SetFont( "q_item_option_dropbutton" )
	drop:SizeToContents()
	drop.w, drop.h = drop:GetSize()
	drop:SetPos( spacing, dp.h - drop.h - padding )
	drop.x, drop.y = drop:GetPos()

	drop.Paint = function( self ) theme.iteminfobutton( self ) end
	drop.DoClick = function( self )
		surface.PlaySound( "UI/buttonclick.wav" )
		back:Remove()

		dropAmount = math.Clamp( amountEntry:GetValue(), 1, amountInSlot )

		if( dropAmount >= item.stack && itemPanel != nil ) then 
			itemPanel.RemoveItem()
		else
			itemPanel.SetItemAmount( amountInSlot - dropAmount )
		end

		Quantum.Client.InventoryNet.DropItem( item.id, index, dropAmount )
		
	end

	local cancel = vgui.Create( "DButton", dp )
	cancel:SetText( "Cancel" )
	cancel:SetFont( "q_item_option_dropbutton" )
	cancel:SizeToContents()
	cancel.w, cancel.h = cancel:GetSize()
	cancel:SetPos( dp.w - cancel.w - spacing, dp.h - cancel.h - padding )
	cancel.x, cancel.y = cancel:GetPos()

	cancel.Paint = function( self ) theme.iteminfobutton( self ) end
	cancel.DoClick = function( self )
		surface.PlaySound( "UI/buttonclick.wav" )
		back:Remove()
	end

end

function iteminfo.giveoptions( p, page )
	
	local itemPanel = p:GetParent()
	local index = itemPanel.index
	local item = itemPanel.item
	local amount = item.amount
	local parWidth, parHeight = itemPanel:GetSize()

	local options = vgui.Create( "DPanel", page )
	options:SetSize( 100 * scale, 80 * scale )
	options.w, options.h = options:GetSize()

	options.item = item
	options.amount = amount
	options.index = index

	options:SetVisible( false )
	options.Paint = function( self )
		theme.iteminfopanel( self )
	end
	options.Open = function()
		page.showtooltips = false
		if( page.shownOption != nil ) then
			page.shownOption:SetVisible( false )
			page.shownOption:SetPos( 0, 0 )
		end
		page.shownOption = options
		options.w, options.h = resizePanel( options ) -- resize itself so everything fits
		options:SetVisible( true )
		options:SetPos( gui.MouseX() - options.w/2, gui.MouseY() - ( options.h + padding ) )
	end
	options.Close = function()
		if( page.shownOption == options ) then
			page.shownOption = nil
			page.showtooltips = true
			options:SetVisible( false )
			options:SetPos( 0, 0 )
		elseif( page.shownOption != nil ) then
			page.shownOption.Close()
		end
	end
	---- all of the option panels ----
	local xbasepos, ybasepos = padding_s, padding_s -- everything needs to be a bit to the side on both axises

	local ypos = ybasepos
	local yspacing = padding/4

	local op = {}

	---- Allways create the title for the item ----
	op.title = vgui.Create( "DLabel", options )
	op.title:SetText( item.name || "ERROR name=nil" )
	op.title:SetTextColor( theme.color.setalpha( item.rarity.color || Color( 255, 255, 255, 255 ), 255 ) )
	op.title:SetFont( "q_tooltip_title" )
	op.title:SizeToContents()
	op.title.w, op.title.h = op.title:GetSize()
	op.title:SetPos( xbasepos, ypos )
	op.title.x, op.title.y = op.title:GetPos()

	ypos = ypos + op.title.h + yspacing -- do the spacing thing

	if( item.equipable ) then -- Equip

		op.equip = vgui.Create( "DButton", options )
		op.equip:SetText( "Equip" )
		op.equip:SetFont( "q_item_option_button" )
		op.equip:SizeToContents()
		op.equip.w, op.equip.h = op.equip:GetSize()
		op.equip:SetPos( xbasepos, ypos )
		op.equip.x, op.equip.y = op.equip:GetPos()
		op.equip.Paint = function( self )
			theme.iteminfobutton( self )
		end
		op.equip.DoClick = function( self )
			surface.PlaySound( "UI/buttonclick.wav" )
			options.Close()

			---- EQUIP NET HERE ----
		end
		ypos = ypos + op.equip.h + yspacing

	elseif( item.usefunction != nil ) then

		op.use = vgui.Create( "DButton", options )
		op.use:SetText( "Use Item" )
		op.use:SetFont( "q_item_option_button" )
		op.use:SizeToContents()
		op.use.w, op.use.h = op.use:GetSize()
		op.use:SetPos( xbasepos, ypos )
		op.use.x, op.use.y = op.use:GetPos()
		op.use.Paint = function( self )
			theme.iteminfobutton( self )
		end
		op.use.DoClick = function( self )
			surface.PlaySound( "UI/buttonclick.wav" )

			p:GetParent().RemoveItem()

			options.Close()
			
			---- USE NET HERE ----
		end
		ypos = ypos + op.use.h + yspacing

	elseif( !item.soulbound ) then -- Drop
		op.drop = vgui.Create( "DButton", options )
		op.drop:SetText( "Drop" )
		op.drop:SetFont( "q_item_option_button" )
		op.drop:SizeToContents()
		op.drop.w, op.drop.h = op.drop:GetSize()
		op.drop:SetPos( xbasepos, ypos )
		op.drop.x, op.drop.y = op.drop:GetPos()
		op.drop.Paint = function( self )
			theme.iteminfobutton( self )
		end
		op.drop.DoClick = function( self )
			surface.PlaySound( "UI/buttonclick.wav" )
			options.Close()

			if( amount > 1 ) then
				iteminfo.dropamount( options, page, itemPanel )
			else
				p:GetParent().RemoveItem()
				---- DROP NET HERE ----
				Quantum.Client.InventoryNet.DropItem( item.id, index, amount )

			end
		end
		ypos = ypos + op.drop.h + yspacing

	end

	op.close = vgui.Create( "DButton", options )
	op.close:SetText( "Cancel" )
	op.close:SetFont( "q_item_option_button" )
	op.close:SizeToContents()
	op.close.w, op.close.h = op.close:GetSize()
	op.close:SetPos( xbasepos, ypos )
	op.close.x, op.close.y = op.close:GetPos()
	op.close.Paint = function( self )
		theme.iteminfobutton( self )
	end
	op.close.DoClick = function( self )
		surface.PlaySound( "UI/buttonclick.wav" )
		options.Close()
	end

	-- center all of the option panels --
	options.w, options.h = resizePanel( options )
	for i, optionPanel in pairs( op ) do
		optionPanel:SetPos( options.w/2 - optionPanel.w/2, optionPanel.y )
	end
	options.w, options.h = resizePanel( options )
	return options

end

function iteminfo.givetooltip( p, page )
	local item = p:GetParent().item
	local parWidth, parHeight = p:GetParent():GetSize()
	

	local tooltip = vgui.Create( "DPanel", page )
	tooltip:SetSize( 100 * scale, 80 * scale ) -- placeholder size
	tooltip.w, tooltip.h = tooltip:GetSize()
	tooltip.item = item
	tooltip:SetVisible( false )
	tooltip.Paint = function( self )
		theme.iteminfopanel( self )
	end

	tooltip.Think = function( self ) -- prevents tooltip from showing when a item is showing its options
		if( page.showtooltips != nil ) then
			self:SetVisible( page.showtooltips )
		else
			self:SetVisible( true )
		end
	end

	function tooltip:CreateInfo()
		local pw, ph = self:GetSize()
		local amountStr = ""
		if( self.item.amount > 1 ) then amountStr = " (x" .. tostring( self.item.amount ) .. ")" end

		local title = vgui.Create( "DLabel", self ) -- title label of the item
		title:SetText( self.item.name .. amountStr || "ERROR TITLE" )
		title:SetFont( "q_tooltip_title" )
		title:SetTextColor( theme.color.setalpha( self.item.rarity.color || Color( 255, 255, 255, 255 ), 255 ) )
		title:SizeToContents()
		title.w, title.h = title:GetSize()
		title:SetPos( padding_s, padding_s )
		title.x, title.y = title:GetPos() 

		local rare = vgui.Create( "DLabel", self )
		rare:SetText( self.item.rarity.txt || "ERROR RARITY" )
		rare:SetFont( "q_tooltip_rarity" )
		rare:SetTextColor( theme.color.setalpha( self.item.rarity.color || Color( 255, 255, 255, 255 ), 255 ) )
		rare:SizeToContents()
		rare.w, rare.h = rare:GetSize()
		rare:SetPos( title.x, title.y + title.h + padding_s )
		rare.x, rare.y = rare:GetPos()

		local desc = vgui.Create( "DLabel", self )
		desc:SetText( self.item.desc || "ERROR DESC" )
		desc:SetFont( "q_tooltip_desc" )
		desc:SetTextColor( Color( 205, 205, 205, 255 ) )
		desc:SizeToContents()
		desc.w, desc.h = desc:GetSize()
		desc:SetPos( title.x, rare.y + rare.h + padding_s )
		desc.x, desc.y = desc:GetPos()

		if( self.item.soulbound == true ) then
			local sb = vgui.Create( "DLabel", self )
			sb:SetText( "Soulbound" )
			sb:SetFont( "q_tooltip_rarity" )
			sb:SetTextColor( Color( 235, 64, 52, 255 ) )
			sb:SizeToContents()
			sb.w, sb.h = sb:GetSize()
			sb:SetPos( title.x, desc.y + desc.h + padding_s )
		end
		
		-- Correct the tooltips size so its content fits inside of it
		resizePanel( self )
	end

	p.ItemTooltipPanel = tooltip -- set the tooltip

	p.Think = function( self )
		self.ItemTooltipPanel:SetVisible( self:IsHovered() )
		if( self:IsHovered() ) then
			self.ItemTooltipPanel:SetPos( gui.MouseX() - tooltip.w/2, gui.MouseY() - ( tooltip.h + padding ) )
		end
	end

	return tooltip
end

return iteminfo