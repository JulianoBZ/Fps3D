extends Node

@onready var loaded_map = ""

func _ready():
		# We only need to spawn players on the server.
	if not multiplayer.is_server():
		return
	#multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(del_player)
	multiplayer.connected_to_server.connect(connected_to_server)
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
	peer.create_server(PORT, Global.server_slots)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer server.")
		return
	multiplayer.multiplayer_peer = peer
	#Conectando com o servidor de listagem
	connect_to_server("192.168.0.15", 1234)
	Global.is_hosting = true
	
	add_player(1,Global.P_Name)
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

func connected_to_server():
	rpc_id(1,"add_player",multiplayer.get_unique_id(),Global.P_Name)
	if Global.is_hosting == true:
		rpc_id(1,"add_server_to_list",[Global.server_address,Global.server_name])
	else:
		rpc_id(1,"request_server_list", multiplayer.get_unique_id())
#	print(Network.sync.loaded_map)
#	sync.loaded_map = loaded_map
#	Global.level.add_child(load(Network.loaded_map).instantiate())

#func server_received_connection(id):
#	add_player(id)
#	if id != 1:
#		rpc_id(id,"set_map",Network.loaded_map)
#	pass

#@rpc("authority","call_remote")
#func set_map(map):
#	Network.loaded_map = map
#	print(Network.loaded_map)
#	get_parent().get_node("Main_Scene").hide()

@rpc("any_peer","call_local")
func add_player(id: int, P_Name: String):
	var p_node = QAL.player_node.instantiate()
		# Set player id and name
	p_node.name = str(id)
	p_node.P_Name = P_Name
		#Não faço ideia, mas se eu não insiro no nó desse jeito, o programa não reconhece que ele existe
	Global.get_node("PlayerInfo").add_child(p_node, true)

func del_player(id: int):
	if not Global.Players.has_node(str(id)):
		return
	Global.Players.get_node(str(id)).queue_free()

func _exit_tree():
	if not multiplayer.is_server():
		return
	multiplayer.peer_connected.disconnect(add_player)
	multiplayer.peer_disconnected.disconnect(del_player)

func push_data(data):
	rpc("add_server_to_list",data)

@rpc("call_remote")
func add_server_to_list(data):
	pass

func retrieve_info():
	rpc_id(1,"send_server_list")

@rpc("call_remote","any_peer")
func request_server_list(id):
	pass

@rpc("call_remote","any_peer")
func receive_server_list(list):
	Global.server_list = list
