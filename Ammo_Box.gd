extends RigidBody3D

func _on_area_3d_body_entered(body):
	if body.is_in_group("Player"):
		body.max_ammo()
		if multiplayer.is_server():
			queue_free()
