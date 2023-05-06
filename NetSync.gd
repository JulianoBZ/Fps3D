extends MultiplayerSynchronizer

@onready var loaded_map = ""

@export var load_map:String:
	set(val):
		if is_multiplayer_authority():
			load_map = val
		else:
			get_parent().loaded_map = val
