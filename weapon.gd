extends Node3D
class_name Weapon

@export var type = 3
@export var raycast = Node
var weapon_node
var ammo_reserve_max
var ammo_reserve
var ammo_clip_max
var ammo_clip = 0
var eq_anim
var uneq_anim
var weapon_name = ""
var is_equipped = false

func set_weapon(wn):
	weapon_node = wn
	var w = weapon_node
	add_child(w)
	weapon_name = str(w.name)
	w.set_raycast(raycast)
	
