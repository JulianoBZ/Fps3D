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

#Baseado na cena de arma, pega os dados da cena da arma para cálculos
func set_weapon(wn):
	weapon_node = wn
	var w = weapon_node
	#weapon_name = str(weapon_name)
	#w.set_raycast(raycast)
	if w != null:
		add_child(w, true)
	#ammo_reserve_max = w.get_node("WeaponLogic").ammo_reserve_max
	#ammo_reserve = w.get_node("WeaponLogic").ammo_reserve
	#ammo_clip_max = w.get_node("WeaponLogic").ammo_clip_max
	#ammo_clip = w.get_node("WeaponLogic").ammo_clip
	#eq_anim
	#uneq_anim
	#weapon_name = w.get_node("WeaponLogic").weapon_name
	#w.player = get_parent().get_parent().get_parent()
	
func update_weapon_state(ar,ac):
	ammo_reserve = ar
	ammo_clip = ac

func add_ammo():
	ammo_clip = ammo_reserve_max
