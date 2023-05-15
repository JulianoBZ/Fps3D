extends Weapon_Node

var fire_rate = 0.85
@onready var raycast = $RayCast3D
@onready var barrel = get_parent().get_node("Root/Anchor/Body/Upper")
@onready var fire_timer = $fire_timer
@onready var animation_player = get_parent().get_node("AnimationPlayer")

@onready var grenade = preload("res://Weapons/grenade.tscn")

var weapon_name = "Grenade Launcher"
var ammo_reserve_max = 15
var ammo_reserve = 15
var ammo_clip_max = 15
var ammo_clip = 15

var damage = 3
var can_fire = true
var projectile_velocity = 30

var rand = RandomNumberGenerator.new()

func _ready():
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
	Fire(get_parent().raycast_path)
	if animation_player.is_playing && get_parent().is_equipped == false:
		animation_player.stop()

func Fire(_rc):
	#Checagem se o jogador é a autoridade multiplayer, se está equipado, e se está pressionando botão de tiro
	if Input.is_action_pressed("shoot") && get_parent().is_equipped == true && get_parent().get_parent().get_parent().get_parent().get_parent().sync.is_multiplayer_authority():
		if can_fire && ammo_clip > 0:
			#Tira 1 bala do pente
			ammo_clip -= 1
			get_parent().get_parent().update_weapon_state(ammo_reserve,ammo_clip)
			
			#Verifica quem foi atingido e aplica dano
			#var target = rc.get_collider()
			#if target != null && target.is_in_group("Enemy"):
			#	target.take_damage.rpc_id(target.get_multiplayer_authority(), damage)
				#print(get_parent().player.multiplayer.is_multiplayer_authority())
			
			#Spawnar um efeito no local de impacto
			var projectile_direction = $Fire_position.get_global_transform().basis.z
			var projectile_position = $Fire_position.global_position
			if get_multiplayer_authority() == 1:
				rpc("spawn_grenade",projectile_direction,$Fire_position.position,projectile_position)
			else:
				rpc_id(1,"spawn_grenade",projectile_direction,$Fire_position.position,projectile_position)
			#Timer de taxa de disparo
			fire_timer.start(fire_rate)
			can_fire = false
			
			#print(get_parent().player)
		

@rpc("any_peer","call_local")
func spawn_grenade(proj_dir,f_position,global_pos):
	var gr = grenade.instantiate()
	Global.Effects.add_child(gr, true)
	gr.global_position = global_pos
	gr.apply_impulse((-proj_dir * projectile_velocity),f_position)
	#gr.shooter = get_parent().player
	gr.add_collision_exception_with(get_parent().player)
	#bi.look_at(rc.get_collision_point() + rc.get_collision_normal())

func _on_fire_timer_timeout():
	can_fire = true

