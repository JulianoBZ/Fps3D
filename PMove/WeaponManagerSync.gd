extends MultiplayerSynchronizer

@onready var current_weapon:int:
	set(val):
		if get_parent().player_path.is_multiplayer_authority():
			current_weapon = val
		else:
			get_parent().current_weapon = val

@onready var primary_weapon:Node:
	set(val):
		if get_parent().player_path.is_multiplayer_authority():
			primary_weapon = val
		else:
			get_parent().primary_weapon = val
