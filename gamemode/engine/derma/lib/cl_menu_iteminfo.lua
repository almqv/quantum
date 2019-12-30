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

function iteminfo.givetooltip( p )
	local item = p:GetParent().item
	local parWidth, parHeight = p:GetParent():GetSize()
	local amountStr = ""

	local tooltip = vgui.Create( "DPanel" )
	tooltip:SetSize( 100 * scale, 80 * scale )
	tooltip:SetVisible( false )
	tooltip.Paint = function( self )
		theme.itemtooltip( self, item )
	end

	if( item.amount > 1 ) then amountStr =  "x" .. tostring( item.amount ) end

	p.ItemInfoPanel = tooltip -- set the tooltip

	p.Think = function( self )
		self.ItemInfoPanel:SetVisible( self:IsHovered() )
		if( self:IsHovered() ) then
			self.ItemInfoPanel:SetPos( gui.MouseX(), gui.MouseY() - ( parHeight + padding )*2 )
		end
	end

	--p:SetToolTip( item.name .. " " .. amountStr .. "\n\n" .. item.desc )
	--p:SetTooltipPanel( tooltip )
	--p.pnlTooltipPanel = tooltip -- overwrite the default tooltip
	--p.strTooltipText = ""
end

return iteminfo