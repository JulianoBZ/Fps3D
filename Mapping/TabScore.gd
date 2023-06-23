extends Control


func _process(_delta):
	
	if Input.is_action_pressed("Tab"):
		show()
	#	print("TAB")
	else:
		hide()
	
	for n in $TabContainer.get_children():
		n.queue_free()
	for each in Global.get_node("PlayerInfo").get_children():
		if each.name != "PlayerInfoSpawner":
			var tp = QAL.tab_player.instantiate()
			$TabContainer.add_child(tp)
			tp.get_node("PName").text = str(each.P_Name)
			tp.get_node("PKD").text = str(each.kills)+"/"+str(each.deaths)
			tp.get_node("PPing").text = str(each.ping)
