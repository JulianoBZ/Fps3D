extends Node3D

@onready var player_body = preload("res://PMove/QPlayer.tscn")

@export var class_group = ButtonGroup

var player_class_group
# Called when the node enters the scene tree for the first time.
func _ready():
	$Camera3D.make_current()
	player_class_group = class_group
	
	Global.world_camera = $Camera3D
	Global.world_spawn_hud = $Spawn_HUD
	###########################
#	# We only need to spawn players on the server.
#	if not multiplayer.is_server():
#		return
#	multiplayer.peer_connected.connect(add_player)
#	#multiplayer.peer_disconnected.connect(del_player)
#	# Spawn already connected players.
#	for id in multiplayer.get_peers():
#		add_player(id)
#	# Spawn the local player unless this is a dedicated server export.
#	if not OS.has_feature("dedicated_server"):
#		add_player(1)
	############################

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("m"):
		for each in Global.Players.get_children():
			if each.name == str(multiplayer.get_unique_id()):
				each.queue_free()
		$Camera3D.make_current()
		$Spawn_HUD.show()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	

func _on_spawn_button_pressed():
	
	if multiplayer.is_server():
		Global.desired_class = str(player_class_group.get_pressed_button().name)
		print(Global.desired_class)
		$Spawn_HUD.hide()
		spawn_player(multiplayer.get_unique_id())
	else:
		Global.desired_class = str(player_class_group.get_pressed_button().name)
		print(Global.desired_class)
		$Spawn_HUD.hide()
		rpc_id(1,"spawn_from_server",multiplayer.get_unique_id())

@rpc("any_peer","call_remote")
func spawn_from_server(id):
	spawn_player(id)

func spawn_player(id):
	# Randomize character position.
	var player_b = player_body.instantiate()
	player_b.set_multiplayer_authority(id, true)
	#for each in Global.Players.get_children():
	#	if str(each.name) == str(id):
	player_b.name = str(id)
	Global.Players.add_child(player_b, true)
	player_b.position = $Spawns.get_child(randi_range(0,3)).position
	print(player_b.position)

###################################################

#func _exit_tree():
#	if not multiplayer.is_server():
#		return
#	multiplayer.peer_connected.disconnect(add_player)
#	multiplayer.peer_disconnected.disconnect(del_player)


#func add_player(id: int):
#	var player_node = preload("res://Player_Node.tscn").instantiate()
#	# Set player id.
#	player_node.Network_ID = id
#	player_node.name = str(id)
#	$Players.add_child(player_node)
#	## Randomize character position.
#	#player_node.position = $Spawns.get_child(randi_range(0,3)).position
#	#player_node.name = str(id)
#	#$Players.add_child(player_node, true)


#func del_player(id: int):
#	if not $Players.has_node(str(id)):
#		return
#	$Players.get_node(str(id)).queue_free()

