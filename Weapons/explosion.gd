extends Area3D

@onready var bodies = []
var splash_damage = 30

var frame_limiter = 0
var damage_limiter = 1
var shooter

@onready var can_damage = true

func _ready():
	show()
	$AnimatedSprite3D.frame = 0
	$AnimatedSprite3D.play("explosion")
	if multiplayer.is_server():
		$Timer.start()

func _physics_process(_delta):
	if frame_limiter < 3 && multiplayer.is_server() && is_inside_tree():
		bodies = self.get_overlapping_bodies()
		for body in bodies:
			if body.is_in_group("Player"):
				apply_damage(body)
	frame_limiter += 1


func apply_damage(body):
	if multiplayer.is_server():
		if body.is_inside_tree():
			$RayCast3D.target_position = body.global_position
			#############
			#Draw3d.line(global_position, body.global_position)
			#############
			var distance = abs(global_position.distance_to(body.global_position))
			var damage = floor(splash_damage / distance)
			$RayCast3D.look_at(body.global_position)
			print($RayCast3D.rotation_degrees)
			if body.sync.get_multiplayer_authority() == 1:
				body.take_damage(damage, str(shooter))
				body.take_knockback(Vector3($RayCast3D.rotation_degrees.y,$RayCast3D.rotation_degrees.x,0), damage*2, damage*4,2)
			else:
				body.take_damage.rpc_id(body.sync.get_multiplayer_authority(), damage, str(shooter))
				body.take_knockback.rpc_id(body.sync.get_multiplayer_authority(),Vector3($RayCast3D.rotation_degrees.y,$RayCast3D.rotation_degrees.x,0), damage*2, damage*4,2)

func _on_animated_sprite_3d_animation_finished():
	if multiplayer.is_server():
		queue_free()

#func _on_body_entered(body):
#	if multiplayer.is_server() && is_inside_tree() && !$Timer.is_stopped():
#		if body.is_in_group("Player"):
#			#print("Bodies Server: ",body)
#			apply_damage(body)
#	pass
