extends RigidBody3D

var shooter :Node
var exception_applied = false

var direct_damage = 30

var explosion = preload("res://Weapons/explosion.tscn")

#func _ready():
	#add_collision_exception_with(shooter)

func _on_body_entered(_body):
	if _body != shooter:
		rpc("spawn_explosion",global_position)
		#self.queue_free()
		if _body.is_in_group("Player"):
			_body.take_damage.rpc_id(_body.get_multiplayer_authority(), direct_damage)
			rpc("spawn_explosion",global_position)
		#self.queue_free()
	pass # Replace with function body.

@rpc("any_peer","call_local")
func spawn_explosion(pos):
	var ex = explosion.instantiate()
	Global.Effects.add_child(ex, true)
	ex.global_position = pos
	ex.shooter = shooter
	self.queue_free()
