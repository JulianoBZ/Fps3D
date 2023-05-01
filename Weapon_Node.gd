extends Node3D
class_name Weapon_Node

var player
var raycast_path
var is_equipped = false
var damage = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_raycast(rc):
	raycast_path = rc

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#shoot()
	pass

#func shoot():
#	if Input.is_action_just_pressed("shoot") && is_equipped == true:
#		$WeaponLogic.shoot(raycast_path.get_collider())
