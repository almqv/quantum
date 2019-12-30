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

function iteminfo.givetooltip( p, page )
	local item = p:GetParent().item
	local parWidth, parHeight = p:GetParent():GetSize()
	

	local tooltip = vgui.Create( "DPanel", page )
	tooltip:SetSize( 100 * scale, 80 * scale ) -- placeholder size
	tooltip.w, tooltip.h = tooltip:GetSize()
	tooltip.item = item
	tooltip:SetVisible( false )
	tooltip.Paint = function( self )
		theme.itemtooltip( self, item )
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
		

		-- Correct the tooltips size so its content fits inside of it
		self:SizeToChildren( true, true )
		self.w, self.h = self:GetSize() 
		self:SetSize( self.w + padding_s, self.h + padding_s )
		self.w, self.h = self:GetSize()
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