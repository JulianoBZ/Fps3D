extends Area3D

@onready var bodies = get_overlapping_bodies()
var splash_damage = 30

var body_limiter = 1
var damage_limiter = 1
var shooter

@onready var can_damage = true

func _ready():
	$AnimatedSprite3D.frame = 0
	$AnimatedSprite3D.play("explosion")
	if multiplayer.is_server():
		$Timer.start()


func apply_damage(body):
	if multiplayer.is_server():
		if body.is_inside_tree():
			$RayCast3D.target_position = body.global_position
			#############
			#Draw3d.line(global_position, body.global_position)
			############
			var distance = abs(global_position.distance_to(body.global_position))
			var damage = floor(splash_damage / distance)
			$RayCast3D.look_at(body.global_position)
			if body.sync.get_multiplayer_authority() == 1:
				body.take_damage(damage)
				body.take_knockback(Vector3(-$RayCast3D.global_rotation.y/PI,$RayCast3D.global_rotation.x/PI,0), damage*1.5, damage*2)
			else:
				body.take_damage.rpc_id(body.sync.get_multiplayer_authority(), damage)
				body.take_knockback.rpc_id(body.sync.get_multiplayer_authority(),Vector3(-$RayCast3D.global_rotation.y/PI,$RayCast3D.global_rotation.x/PI,0), damage*1.5, damage*2)

func _on_animated_sprite_3d_animation_finished():
	queue_free()
	pass

func _on_body_entered(body):
	if multiplayer.is_server() && is_inside_tree() && !$Timer.is_stopped():
		if body.is_in_group("Player"):
			#print("Bodies Server: ",body)
			apply_damage(body)
	pass
