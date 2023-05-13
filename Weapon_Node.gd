extends Node3D
class_name Weapon_Node

#Player define o jogador que disparou e raycast serve para a lógica da arma
var player
var raycast_path
var is_equipped = false


func _ready():
	set_raycast(get_parent().raycast)
	player = get_parent().get_parent().get_parent().get_parent()

#Até o momento o raycast serve para alimentar a lógica da arma
func set_raycast(rc):
	raycast_path = rc

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	is_equipped = get_parent().is_equipped
	pass

#func shoot():
#	if Input.is_action_just_pressed("shoot") && is_equipped == true:
#		$WeaponLogic.shoot(raycast_path.get_collider())

