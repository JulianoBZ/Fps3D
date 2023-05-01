extends Control


func update_weapon_ui(weapon_name):
	$Label.text = str(weapon_name)+ " : "
	#$Label.text += str(weapon_ammo)
