extends Node3D
class_name Weapon_Node

#Player define o jogador que disparou e raycast serve para a lógica da arma
var player
var raycast_path
var is_equipped = false

func _ready():
	pass # Replace with function body.

#Até o momento o raycast serve para alimentar a lógica da arma
func set_raycast(rc):
	raycast_path = rc

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#shoot()
	pass

#func shoot():
#	if Input.is_action_just_pressed("shoot") && is_equipped == true:
#		$WeaponLogic.shoot(raycast_path.get_collider())

