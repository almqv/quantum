--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

Quantum.Dialogue = {}

Quantum.DialogueTbl = {}

function Quantum.Dialogue.Create( id, tbl )
	tbl = tbl || {}
	local dialogue = {
		bye = tbl.bye || "Nevermind, goodbye.",
	}

	Quantum.DialogueTbl[id] = dialogue
	return dialogue
end


function Quantum.Dialogue.AddQuestion( id, qid, q )
	if CLIENT then
		if( Quantum.DialogueTbl[id] == nil ) then
			Quantum.Error("Dialogue '" .. tostring(id) .. "' does not exist! Can not add question to it.")
			return 
		else
			Quantum.DialogueTbl[id][qid] = {
				question = q || "...",
				response = {}
			}
			return qid
		end
	end
end

function Quantum.Dialogue.AddResponse( id, qid, tbl, order )
	if CLIENT then
		table.insert(Quantum.DialogueTbl[id][qid].response, order, {
			text = tbl.text || "...",
			func = tbl.func, -- function to be ran on the client side
			newqID = tbl.newqID -- if it leads to a new question, then forward it to its id, if nil then terminate conversation
		})	
	end
end


function Quantum.Dialogue.Get( id )
	if CLIENT then
		Quantum.Debug("Dialogue fetch:")
		PrintTable(Quantum.DialogueTbl)
		return Quantum.DialogueTbl[id]
	else
		Quantum.Error("Can not fetch dialogue table from serverside!")
	end
end