extends Control

#É alimentado dados da arma ao trocar de arma
func update_weapon_ui(weapon_name,weapon_current_ammo,weapon_reserve_ammo):
	$Weapon_info/Label.text = str(weapon_name)+ " : "
	$Weapon_info/Label.text += str(weapon_current_ammo)+"/"+str(weapon_reserve_ammo)

func update_class_ui(pl_cl):
	$Class_info/Label.text = "Class: "+str(pl_cl)
