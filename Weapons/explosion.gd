extends Area3D

var bodies = []
var splash_damage = 50

var body_limiter = 1
var damage_limiter = 1
var shooter : Node

func _process(_delta):
	if has_overlapping_bodies() && body_limiter == 1:
		apply_damage()
		body_limiter -= 1

func apply_damage():
	if damage_limiter == 1:
		$AnimatedSprite3D.frame = 0
		$AnimatedSprite3D.play("explosion")
		bodies = get_overlapping_bodies()
		print(bodies)
		
		for each in bodies:
			if each.is_in_group("Player") && each != shooter:
				print("Shooter:",shooter)
				$RayCast3D.target_position = each.global_position
				#############
				var normal_distance = $RayCast3D.global_position.distance_to($RayCast3D.get_collision_normal())
				print("Normal Distance: ",normal_distance)
				############
				print("Current: ",global_position,"Target: ",each.global_position)
				var distance = abs(global_position.distance_to(each.global_position))
				print("Distance: ",distance)
				var damage = floor(splash_damage * distance)
				each.take_damage(damage)
				print("Damage: ",damage)
		damage_limiter -= 1
		

func _on_animated_sprite_3d_animation_finished():
	self.queue_free()
