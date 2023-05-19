extends Timer

func _on_timeout():
	queue_free()
