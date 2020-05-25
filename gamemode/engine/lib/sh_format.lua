--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

Quantum.Format = {}

local function addMoneyVal( num )
	return Quantum.Money.Prefix .. tostring( num ) .. Quantum.Money.Surfix
end

function Quantum.Format.Money( num )
	if( num == nil ) then return addMoneyVal( 0 ) end
	
	if( num >= 1e14 ) then 
		return addMoneyVal( num ) 
	elseif( num <= -1e14 ) then
		return addMoneyVal( "-" .. tostring( math.abs( num ) ) )
	end

	num = tostring( math.abs( num ) )
	local sep = sep || ","
	local dp = string.find( num, "%." ) || #num + 1

	for i = dp - 4, 1, -3 do
		num = num:sub( 1, i ) .. sep .. num:sub( i + 1 )
	end

	return ( negative && "-" || "" ) .. addMoneyVal( num )
end
