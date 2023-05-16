extends RigidBody3D

var shooter
var exception_applied = false

var direct_damage = 30

var explosion = preload("res://Weapons/explosion.tscn")

#func _ready():
#	add_collision_exception_with(shooter)

func _on_body_entered(_body):
	if _body.name == shooter:
		add_collision_exception_with(_body)
	if _body.name != shooter:
		#print("Grenade Body: ",_body," Shooter: ",shooter)
		if shooter == str(1):
			spawn_explosion(global_position,shooter)
		else:
			rpc_id(1,"explosion_from_server",global_position,shooter)
		#self.queue_free()
		if _body.is_in_group("Player") && (str(_body.get_multiplayer_authority()) != shooter):
			#_body.take_damage(direct_damage)
			if shooter == str(1):
				spawn_explosion(global_position,shooter)
			else:
				rpc_id(1,"explosion_from_server",global_position,shooter)
	#self.queue_free()
	pass # Replace with function body.

@rpc("any_peer","call_local")
func explosion_from_server(pos,sht):
	spawn_explosion(pos,sht)

#@rpc("any_peer","call_local")
func spawn_explosion(pos,sht):
	var ex = explosion.instantiate()
	Global.Effects.add_child(ex, true)
	ex.global_position = pos
	ex.shooter = sht
	self.queue_free()
