extends Node3D

var current_weapon

var pistol_a = preload("res://Weapons/Pistol_A.tscn").instantiate()
var rifle_a = preload("res://Weapons/Rifle_A.tscn").instantiate()
var melee = preload("res://Weapons/unarmed.tscn").instantiate()

# Inicializa o loadout e inicia com a arma primária selecionada
func _ready():
	current_weapon = 1
	set_loadout(rifle_a,pistol_a,melee)
	change_weapon()
	pass # Replace with function body.

#Inicializa o loadout
func set_loadout(wn1,wn2,wn3):
	$Primary.set_weapon(wn1)
	$Secondary.set_weapon(wn2)
	$Melee.set_weapon(wn3)
	wn1.player = get_parent().get_parent()
	wn2.player = get_parent().get_parent()
	wn3.player = get_parent().get_parent()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
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
			each.get_child(0).is_equipped = true
		else:
			each.get_child(0).is_equipped = false
			each.hide()

