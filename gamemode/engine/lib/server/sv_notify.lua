--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

Quantum.Notify = {}

local function makeColorAString( clr )
	return "Color(" .. tostring( clr.r ) .. "," .. tostring( clr.g ) .. "," .. tostring( clr.b ) .. ")"
end

local baseClr = Color( 220, 220, 220 )

function Quantum.Notify.ItemPickup( pl, item, amount )
	local amtStr = ""
	if( amount > 1 ) then amtStr = tostring(amount) .. "x " end

	local itemColor = item.rarity.color || baseClr
	local itemName = item.name || "[ERROR name=nil]"

	local luaArgs = makeColorAString(baseClr) .. ",'You picked up '," .. makeColorAString(baseClr) .. ",'" .. tostring(amtStr) .. "'," .. makeColorAString(itemColor) .. ","  .. "'" .. tostring(itemName) .. "'"
	local luaFunc = "chat.AddText(" .. luaArgs .. ")"

	pl:SendLua( luaFunc ) 
end

function Quantum.Notify.Deny( pl, text )

	local luaArgs = makeColorAString( Color( 245, 20, 20 ) ) .. ",'" .. tostring( text ) .. "'"
	local luaFunc = "chat.AddText(" .. luaArgs .. ")"

	pl:SendLua( luaFunc ) 
end

function Quantum.Notify.Info( pl, text )
	local luaArgs = makeColorAString( Color( 245, 245, 245 ) ) .. ",'" .. tostring( text ) .. "'"
	local luaFunc = "chat.AddText(" .. luaArgs .. ")"

	pl:SendLua( luaFunc ) 
end