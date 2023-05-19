extends Weapon_Node


var fire_rate = 0.8
@onready var fire_timer = $fire_timer
@onready var animation_player = get_parent().get_node("AnimationPlayer")

@onready var bullet_impact = preload("res://Weapons/bullet_impact.tscn")

var weapon_name = "Shotgun"
var ammo_reserve_max = 24
var ammo_reserve = 24
var ammo_clip_max = 24
var ammo_clip = 24

var damage = 6
var can_fire = true

var rand = RandomNumberGenerator.new()

func _ready():
	for each in $Raycasts.get_children():
		var deviation_x = randf_range(-3,3)
		var deviation_y = randf_range(-3,3)
		each.set_rotation_degrees(Vector3(deviation_x,deviation_y,0))
	fire_timer.one_shot = true
	initialize_weapon_manager()

func initialize_weapon_manager():
	get_parent().get_parent().weapon_name = weapon_name
	get_parent().get_parent().ammo_reserve_max = ammo_reserve_max
	get_parent().get_parent().ammo_reserve = ammo_reserve
	get_parent().get_parent().ammo_clip_max = ammo_clip_max
	get_parent().get_parent().ammo_clip = ammo_clip

#Sempre calcula se shoot() está disponível baseado em can_fire e raycast inserido
func _process(_delta):
	if Input.is_action_pressed("shoot") && get_parent().is_equipped == true && get_parent().get_parent().get_parent().get_parent().get_parent().sync.is_multiplayer_authority():
		Fire(get_parent().raycast_path,1)
		fire_timer.start(fire_rate*1)
		can_fire = false
	if Input.is_action_pressed("shoot2") && get_parent().is_equipped == true && get_parent().get_parent().get_parent().get_parent().get_parent().sync.is_multiplayer_authority():
		Fire(get_parent().raycast_path,2)
		get_parent().player.take_knockback(Vector3(get_parent().player.rotation_degrees.y,get_parent().player.get_node("Head").rotation_degrees.x,0),30,30)
		#print(get_parent().player.get_node("Head").rotation_degrees.x," - ", get_parent().player.rotation_degrees.y)
		fire_timer.start(fire_rate*2)
		can_fire = false
		#Referencia
		#body.take_knockback(Vector3(-$RayCast3D.global_rotation.y/PI,$RayCast3D.global_rotation.x/PI,0), damage*1.5, damage*2)
	if animation_player.is_playing && get_parent().is_equipped == false:
		animation_player.stop()

func Fire(rc,type):
	#Checagem se o jogador é a autoridade multiplayer, se está equipado, e se está pressionando botão de tiro
		if can_fire && ammo_clip > type && can_fire:
			#Tira 1 bala do pente
			ammo_clip -= type
			get_parent().get_parent().update_weapon_state(ammo_reserve,ammo_clip)
			
			#Desvio das pellets de acordo com o tipo de tiro
			var dev = 3 * type
			
			for x in range(type):
				for each in $Raycasts.get_children():
					each.global_position = rc.global_position
					
					#Calcula desvio
					var deviation_x = randf_range(-dev,dev)
					var deviation_y = randf_range(-dev,dev)
					each.set_rotation_degrees(Vector3(deviation_x,deviation_y,0))
					
					#Verifica quem foi atingido e aplica dano
					var target = each.get_collider()
					if target != null && target.is_in_group("Player"):
						target.take_damage.rpc_id(target.get_multiplayer_authority(), damage)
						#print(get_parent().player.multiplayer.is_multiplayer_authority())
					
					#Spawnar um efeito no local de impacto
					rpc("spawn_bullet_impact",each.get_collision_point())

@rpc("any_peer","call_local")
func spawn_bullet_impact(collision):
	var bi = bullet_impact.instantiate()
	Global.Effects.add_child(bi, true)
	bi.global_position = collision

func _on_fire_timer_timeout():
	can_fire = true

