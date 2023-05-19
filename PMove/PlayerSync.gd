extends MultiplayerSynchronizer

@export var authority:int:
	set(val):
		if is_multiplayer_authority():
			set_multiplayer_authority(val)
		else:
			get_parent().set_multiplayer_authority(val)

@export var health:int:
	set(val):
		if is_multiplayer_authority():
			health = val
		else:
			get_parent().health = val

@export var position:Vector3:
	set(val):
		if is_multiplayer_authority():
			position = val
		else:
			get_parent().position = val

@export var rotation:Vector3:
	set(val):
		if is_multiplayer_authority():
			rotation = val
		else:
			get_parent().rotation = val

@export var camera:Camera3D:
	set(val):
		if is_multiplayer_authority():
			camera = val
		else:
			get_parent().camera = val

@export var primary_weapon:String:
	set(val):
		if is_multiplayer_authority():
			primary_weapon = val
		else:
			get_parent().primary_weapon = val

@export var secondary_weapon:String:
	set(val):
		if is_multiplayer_authority():
			secondary_weapon = val
		else:
			get_parent().secondary_weapon = val

@export var current_weapon:int:
	set(val):
		if is_multiplayer_authority():
			current_weapon = val
		else:
			get_parent().get_node("Head/Weapons").current_weapon = val
