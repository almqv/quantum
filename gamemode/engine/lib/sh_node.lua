--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

Quantum.Node = {} -- lib
Quantum.Nodes = {} -- container for vars
Quantum.NodesLocations = {}

function Quantum.Node.AddNodeType(id, entclass)
	Quantum.NodeType[id] = entclass	-- for plugins and such
end

function Quantum.Node.Create( nodeid, tbl ) 
	local node = {
		name = tbl.name || "Unknown Node",
		model = tbl.model || "error", -- will create the infamous error model 
		type = tbl.type || Quantum.NodeType.resource,
		toolids = tbl.toolids || {}, -- if it's empty then you can use all sweps/tools
		canGather = tbl.canGather || false,
		give = tbl.give || {}, 
		giveprobability = tbl.giveprobability || 1,
		health = tbl.health || Quantum.DefaultNodeHealth,
		respawn = tbl.respawn || Quantum.DefaultNodeRespawnTimer
	}

	node.id = nodeid
	Quantum.Nodes[nodeid] = node
	return node
end

function Quantum.Node.Get( nodeid )
	return Quantum.Nodes[nodeid]
end

if SERVER then

	function Quantum.Node.Spawn( nodeid, vec, ang )
		local node = Quantum.Node.Get( nodeid )

		local ent = ents.Create( node.type )
		ent.node = node
		ent.respawndelay = node.respawn || 30
		ent.probability = node.probability || 1
		ent:SetModel( node.model )
		ent:SetPos( vec )
		ent:SetAngles( ang )

		ent:SetNWString( "q_node_id", nodeid )
		ent:SetHealth( node.health )

		ent:Spawn()
	end

	function Quantum.Node.Remove( ent )
		local nodeTbl = ent.node

		if( ent.node != nil ) then
			local nodeid = nodeTbl.id
			local pos, ang = ent:GetPos(), ent:GetAngles()
			
			timer.Simple( ent.respawndelay, function() 
				Quantum.Node.Spawn( nodeid, pos, ang, nodeTbl.respawn, nodeTbl.probability ) -- respawn it after x seconds
			end)

			ent:Remove() -- remove the node
		else
			Quantum.Error( "Node table is nil! Aborting..." )
			return
		end
	end

	function Quantum.Node.GetAllEntities()
		local out = {}

		for k, nodetype in pairs( Quantum.NodeType ) do
			for k, node in pairs( ents.FindByClass(nodetype) ) do
				out[#out + 1] = node	
			end
		end

		return out
	end

	function Quantum.Node.RemoveAll()
		for k, node in pairs( Quantum.Node.GetAllEntities() ) do
			Quantum.Node.Remove( node )
		end
	end

	function Quantum.Node.RemoveAllPerma()
		for k, node in pairs( Quantum.Node.GetAllEntities() ) do
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
				Quantum.Node.Spawn( v.id, v.pos, v.ang )
			else
				Quantum.Error( "Tried to spawn an invalid node ('" .. v.id .. "')!" )
			end
		end
	end

	function Quantum.Node.UpdateAll()
		Quantum.Debug( "Updating all nodes..." )
		Quantum.Node.RemoveAllPerma()
		Quantum.Node.SpawnAllRegistered()
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
		local n = math.Rand( 0.001, 1 )
		if( n <= prob ) then
			local index = math.random( 1, #tbl )
			return tbl[index].item, tbl[index].amount || 1
		end
	end

	function Quantum.Node.Gather( pl, tool, ent, dmgInfo )
		local nodeTbl = ent.node

		if( ent.node != nil ) then
			if( !nodeTbl.canGather ) then return end
			local nodeid = nodeTbl.id
			local toolids = nodeTbl.toolids

			if( toolids != nil ) then
				local canGather = false
				-- This is fucking retarded.
				if( #toolids > 0 ) then
					for i, t in pairs( toolids ) do
						if( tool == t ) then
							canGather = true
							break
						end
					end
				else
					canGather = true
				end

				if( canGather ) then

					if( dmgInfo != nil ) then
						ent:SetHealth( ent:Health() - dmgInfo:GetDamage() )
						if( ent:Health() <= 0 ) then
							Quantum.Node.Remove( ent ) 
						end
					end

					local loot, amount = randomizeLootTable( nodeTbl.give, nodeTbl.giveprobability )
					if( loot != nil ) then
						if( !Quantum.Server.Settings.ItemsGatheredSpawnInWorld ) then
							Quantum.Server.Inventory.GiveItem( pl, loot, amount )
							local itemTbl = Quantum.Item.Get( loot )
							Quantum.Notify.ItemGathered( pl, itemTbl, amount )
						else
							local eyepos = pl:GetEyeTraceNoCursor()
							if( eyepos.Entity == ent ) then
								local pos = LerpVector( 0.75, eyepos.StartPos, eyepos.HitPos )

								Quantum.Server.Item.SpawnItem( pos, loot, amount )
							end
						end
					else
						return
					end
				end
			end
		end
	end
end