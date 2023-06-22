extends MeshInstance3D

func _ready():
	show()
	$AnimationPlayer.play("fade_out")

func _on_animation_player_animation_finished(_anim_name):
	if multiplayer.is_server():
		queue_free()
