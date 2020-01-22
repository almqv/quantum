--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

local qrender = {}

function qrender.CreateMdl( mdl, vec, ang )

	Quantum.Debug( "CSEnt created." )

	local ent = ClientsideModel( mdl )
	ent:SetPos( vec )
	ent:SetAngles( ang )

	return ent

end

function qrender.SetModel( ent, model )
	if( ent:GetModel() != model ) then
		ent:SetModel( model )
	else
		return
	end
end

function qrender.delCSent( ent )
	if( IsValid(ent) ) then
		Quantum.Debug( "CSEnt removed." )
		ent:Remove()
	end
end

return qrender