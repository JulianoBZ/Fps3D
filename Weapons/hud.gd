extends Control

#É alimentado dados da arma ao trocar de arma
func update_weapon_ui(weapon_name,weapon_current_ammo,weapon_reserve_ammo):
	$Label.text = str(weapon_name)+ " : "
	$Label.text += str(weapon_current_ammo)+"/"+str(weapon_reserve_ammo)
	
