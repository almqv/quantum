--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

Quantum.Node = {} -- lib
Quantum.Nodes = {} -- container for vars
Quantum.NodesLocations = {}

function Quantum.Node.Create( nodeid, tbl ) 
	local node = {
		name = tbl.name || "Unknown Node",
		model = tbl.model, 
		toolids = tbl.toolids || { "q_hands" },
		give = tbl.give || {},
		giveprobability = tbl.giveprobability || 1
	}

	node.id = nodeid
	Quantum.Nodes[nodeid] = node
	return node
end

function Quantum.Node.Get( nodeid )
	return Quantum.Nodes[nodeid]
end

if SERVER then

	function Quantum.Node.Spawn( nodeid, vec, ang, respawndelay, probability )
		local node = Quantum.Node.Get( nodeid )

		local ent = ents.Create( "q_node" )
		ent.node = node
		ent.respawndelay = respawndelay || 30
		ent.probability = probability || 1
		ent:SetModel( node.model )
		ent:SetPos( vec )
		ent:SetAngles( ang )

		ent:Spawn()
	end

	function Quantum.Node.Remove( ent )
		local nodeTbl = ent.node

		if( ent.node != nil ) then
			local nodeid = nodeTbl.id
			
			timer.Simple( ent.respawndelay, function() 
				Quantum.Node.Spawn( nodeid, ent:GetPos(), ent:GetAngles(), ent.respawndelay, ent.probability ) -- respawn it after x seconds
			end)

			ent:Remove() -- remove the node
		else
			Quantum.Error( "Node table is nil! Aborting..." )
			return
		end
	end

	function Quantum.Node.RemoveAll()
		for k, node in pairs( ents.FindByClass("q_node") ) do
			Quantum.Node.Remove( node )
		end
	end

	function Quantum.Node.RemoveAllPerma()
		for k, node in pairs( ents.FindByClass("q_node") ) do
			node:Remove()
		end
	end

	function Quantum.Node.Register( nodeid, vec, ang1 )
		Quantum.NodesLocations[ #Quantum.NodesLocations + 1 ] = { id = nodeid, pos = vec, ang = ang1 }
	end

	function Quantum.Node.SpawnAllRegistered()
		local nodeTbl
		for k, v in pairs( Quantum.NodesLocations ) do
			nodeTbl = Quantum.Node.Get( v.id )
			if( nodeTbl != nil ) then
				Quantum.Debug( "----Node-Spawning-Info----" )
				PrintTable(v)
				Quantum.Debug( "--------------------------" )
				Quantum.Node.Spawn( v.id, v.pos, v.ang, nodeTbl.respawndelay, nodeTbl.probability )
			else
				Quantum.Error( "Tried to spawn an invalid node ('" .. v.id .. "')!" )
			end
		end
	end

	hook.Add( "PlayerInitialSpawn", "Quantum_Init_Nodes_Load", function()  
		Quantum.Debug( "Spawning registered nodes..." )
		
		if( #player.GetAll() == 1 ) then -- spawn the stations when the first player joins
			Quantum.Node.SpawnAllRegistered()
		end
	end)

	hook.Add( "PlayerDisconnected", "Quantum_Nodes_RemoveOnNoPlayers", function() 
		Quantum.Debug( "Removing all nodes..." )
		if( #player.GetAll() - 1 <= 0 ) then
			Quantum.Node.RemoveAllPerma()
		end
	end)

	local function randomizeLootTable( tbl, prob )
		local n = math.Rand( 0.00000000001, 1 )
		Quantum.Debug( "Probability: " .. n .. " <= " .. prob )
		if( n <= prob ) then
			local index = table.random( 1, #tbl )
			return tbl[index].item, tbl[index].amount || 1
		end
	end

	function Quantum.Node.Gather( pl, tool, ent )
		local nodeTbl = ent.node

		if( ent.node != nil ) then
			local nodeid = nodeTbl.id
			local toolids = nodeTbl.toolids

			if( #toolids > 1 ) then
				local canGather = false

				for i, t in pairs( toolids ) do
					if( tool == t ) then
						canGather = true
						break
					end
				end

				if( canGather ) then
					local loot, amount = randomizeLootTable( nodeTbl.give, nodeTbl.giveprobability )

					if( loot != nil ) then
						Quantum.Server.Inventory.GiveItem( pl, loot, amount )
						local itemTbl = Quantum.Item.Get( loot )
						Quantum.Notify.ItemGathered( pl, itemTbl.name, amount )
					else
						return
					end
				end

			end
		end
	end
end