extends Node3D

@onready var timer = $Timer

func _ready():
	if multiplayer.is_server():
		timer.wait_time = 0.05
		timer.start()
		#$MeshInstance3D.set_scale(Vector3(0.1,0.1,0.1))

func _on_timer_timeout():
	if multiplayer.is_server():
		queue_free()
