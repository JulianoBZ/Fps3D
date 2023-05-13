extends Node3D

var current_weapon

var pistol_a = preload("res://Weapons/Pistol_A.tscn").instantiate()
var rifle_a = preload("res://Weapons/Rifle_A.tscn").instantiate()
var melee = preload("res://Weapons/unarmed.tscn").instantiate()
var machine_gun = preload("res://Weapons/machine_gun.tscn")

var primary_weapon
var secondary_weapon
var melee_weapon

var primary_node:Node
var secondary_node:Node
var melee_node:Node

var has_loadout = false

# Inicializa o loadout e inicia com a arma primária selecionada
func _ready():
	#primary_weapon = get_parent().get_parent().primary_weapon
	#print("Primary:",primary_weapon)
	#match primary_weapon:
	#	"Machine Gun":
	#		primary_node = machine_gun
	#current_weapon = 1
	#set_loadout(primary_node,pistol_a,melee)
	#print(primary_node)
	#change_weapon()
	pass # Replace with function body.

#Inicializa o loadout
func set_loadout(wn1,wn2,wn3):
	$Primary.set_weapon(wn1)
	$Secondary.set_weapon(wn2)
	$Melee.set_weapon(wn3)
	

# Pergunta se o player já tem loadout definido, se não, o jogador local vai definir seu proprio loadout localmente
# já que quando é instanciado, ele funciona normalmente para os outros peers
func _process(delta):
	if has_loadout == false:
		primary_weapon = get_parent().get_parent().primary_weapon
		#print("Primary:",primary_weapon)
		match primary_weapon:
			"Machine Gun":
				primary_node = machine_gun.instantiate()
		current_weapon = 1
		set_loadout(primary_node,pistol_a,melee)
		
		has_loadout = true
	
	change_weapon()
	pass

#Troca de arma baseada no Input, e define se está equipada no loop for
func change_weapon():
	if Input.is_action_just_pressed("Primary") || current_weapon == 1:
		current_weapon = 1
		
	if Input.is_action_just_pressed("Secondary"):
		current_weapon = 2
		
	if Input.is_action_just_pressed("Empty"):
		current_weapon = 3
	
	for each in self.get_children():
		if each.type == current_weapon:
			each.is_equipped = true
			each.show()
			get_parent().get_node("HUD").update_weapon_ui(each.weapon_name,each.ammo_clip,each.ammo_reserve)
			each.is_equipped = true
		else:
			each.is_equipped = false
			each.hide()

