extends Node3D

@onready var player = preload("res://PMove/QPlayer.tscn").instantiate()

@export var class_group = ButtonGroup

var player_class_group
# Called when the node enters the scene tree for the first time.
func _ready():
	$Camera3D.make_current()
	player_class_group = class_group

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

func _on_spawn_button_pressed():
	
	Global.desired_class = str(player_class_group.get_pressed_button().name)
	print(Global.desired_class)
	
	$Players.add_child(player)
	player.position = $Spawns.get_node("spawn1").position
	$Spawn_HUD.hide()
