extends MultiplayerSynchronizer

@export var weapon_node:Node:
	set(val):
		if get_parent().player_path.is_multiplayer_authority():
			weapon_node = val
		else:
			get_parent().weapon_node = val

@export var is_equipped:bool:
	set(val):
		if get_parent().player_path.is_multiplayer_authority():
			is_equipped = val
		else:
			get_parent().is_equipped = val
