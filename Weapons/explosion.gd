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

#func _process(delta):
#	if has_overlapping_bodies() && body_limiter == 1:
#		apply_damage()
#		body_limiter -= 1

func _physics_process(_delta):
	#if multiplayer.is_server() && body_limiter == 1:
		#$CollisionShape3D.set_deferred("disabled",true)
		#bodies = get_overlapping_bodies()
		#print("Bodies: ",bodies)
		#for b in bodies:
			#if b.is_in_group("Player"):
				#apply_damage(b)
#				print("Bodies Server: ",b)
#		body_limiter = 0
	pass

func apply_damage(body):
	if multiplayer.is_server():
		#print("Shooter:",shooter," Body: ",body)
		if body.is_inside_tree():
			$RayCast3D.target_position = body.global_position
			#############
			Draw3d.line(global_position, body.global_position)
			############
			#print("Current: ",global_position,"Target: ",each.global_position)
			var distance = abs(global_position.distance_to(body.global_position))
			#print("Distance: ",distance)
			var damage = floor(splash_damage / distance)
			#if multiplayer.get_unique_id() == 1:
			#print("NET ID: ",multiplayer.get_unique_id()," SHOOTER: ",shooter)
			if body.sync.get_multiplayer_authority() == 1:
				#print("body Auth: ",body.get_multiplayer_authority())
				body.take_damage(damage)
			else:
				#print("body Auth: ",body.get_multiplayer_authority())
				body.take_damage.rpc_id(body.sync.get_multiplayer_authority(), damage)
			#body.take_damage(damage)
			#print("Damage: ",damage)

func _on_animated_sprite_3d_animation_finished():
	queue_free()
	pass

func _on_body_entered(body):
	if multiplayer.is_server() && is_inside_tree():
		#print("Overlapping Bodies: ",get_overlapping_bodies())
#		bodies = get_overlapping_bodies()
#		for b in bodies:
		if body.is_in_group("Player"):
			print("Bodies Server: ",body)
			apply_damage(body)
		#print("NET ID: ",multiplayer.get_unique_id())
		#apply_damage(body)
	#	self.hide()
		#print("Signal Body: ",body)
	#monitoring = false
	pass

#func apply_damage():
#	if damage_limiter == 1:
#		bodies = get_overlapping_bodies()
#		print(bodies)
#		
#		for each in bodies:
#			if each.is_in_group("Player") && each.name != shooter:
#				print("Shooter:",shooter)
#				if each.is_inside_tree():
#					$RayCast3D.target_position = each.global_position
#					#############
#					#var normal_distance = $RayCast3D.global_position.distance_to($RayCast3D.get_collision_normal())
#					#print("Normal Distance: ",normal_distance)
#					#print("Collision Point: ",$RayCast3D.get_collision_point())
#					Draw3d.line(global_position, each.global_position)
#					############
#					#print("Current: ",global_position,"Target: ",each.global_position)
#					var distance = abs(global_position.distance_to(each.global_position))
#					print("Distance: ",distance)
#					var damage = floor(splash_damage / distance)
#					each.take_damage(damage)
#					print("Damage: ",damage)
#		damage_limiter -= 1


func _on_area_entered(area):
	#if multiplayer.get_unique_id() == 1 && is_inside_tree():
	#	apply_damage(area.get_parent())
	pass # Replace with function body.
