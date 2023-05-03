extends Node2D

@onready var map_test = preload("res://Mapping/world.tscn").instantiate()

func _on_button_pressed():
	get_parent().add_child(map_test)
	self.hide()
