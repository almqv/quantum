--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

Quantum.Dialogue = {}

Quantum.DialogueTbl = {}

function Quantum.Dialogue.Create( id, tbl )
	local dialogue = {
		bye = tbl.bye || "Nevermind, goodbye.",
		options = tbl.options || {}
	}

	Quantum.DialogueTbl[id] = dialogue
	return dialogue
end

function Quantum.Dialogue.AddQuestion( id, qid, q )
	Quantum.DialogueTbl[id][qid] = {
		question = q || "...",
		response = {}
	}
	return qid
end

function Quantum.Dialogue.AddResponse( id, qid, tbl, order )
	table.insert(Quantum.DialogueTbl[id][qid].response, order, {
		text = tbl.text || "...",
		func = tbl.func,
		newqID = tbl.newqID
	})	
end