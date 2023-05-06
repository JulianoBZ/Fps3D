extends MultiplayerSynchronizer

@export var authority:int:
	set(val):
		if is_multiplayer_authority():
			set_multiplayer_authority(val)
		else:
			get_parent().set_multiplayer_authority(val)

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
