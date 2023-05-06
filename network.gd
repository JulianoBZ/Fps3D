extends Node

@onready var loaded_map = ""

func _ready():
		# We only need to spawn players on the server.
	if not multiplayer.is_server():
		return
	#multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(del_player)
	#multiplayer.connected_to_server.connect(add_player)
	#multiplayer.peer_connected.connect(server_received_connection)
	
	###########################################################
	# Spawn already connected players.
	#for id in multiplayer.get_peers():
	#	add_player(id)
	## Spawn the local player unless this is a dedicated server export.
	#if not OS.has_feature("dedicated_server"):
	#	add_player(1)


func start_server(PORT):
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer server.")
		return
	multiplayer.multiplayer_peer = peer
	Global.MP_ID = 1
	return true

func connect_to_server(IP_address, PORT):
	if str(IP_address) == "":
		OS.alert("Need a remote to connect to.")
		return
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(IP_address, PORT)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer client.")
		return
	multiplayer.multiplayer_peer = peer
	return true
	#get_tree().add_child(load(loaded_map).instantiate())
	
###################################################################

#func peer_connected_to_server():
#	print(Network.sync.loaded_map)
#	sync.loaded_map = loaded_map
#	Global.level.add_child(load(Network.loaded_map).instantiate())

#func server_received_connection(id):
#	if id != 1:
#		rpc_id(id,"set_map",Network.loaded_map)
#	pass

#@rpc("authority","call_remote")
#func set_map(map):
#	Network.loaded_map = map
#	print(Network.loaded_map)
#	get_parent().get_node("Main_Scene").hide()

func add_player(id: int):
	var player_node = preload("res://Player_Node.tscn").instantiate()
	# Set player id.
	player_node.name = str(id)
	player_node.set_multiplayer_authority(id, true)
	Global.Players.add_child(player_node)
	## Randomize character position.
	#player_node.position = $Spawns.get_child(randi_range(0,3)).position
	#player_node.name = str(id)
	#$Players.add_child(player_node, true)

func del_player(id: int):
	if not Global.Players.has_node(str(id)):
		return
	Global.Players.get_node(str(id)).queue_free()

func _exit_tree():
	if not multiplayer.is_server():
		return
	multiplayer.peer_connected.disconnect(add_player)
	multiplayer.peer_disconnected.disconnect(del_player)
