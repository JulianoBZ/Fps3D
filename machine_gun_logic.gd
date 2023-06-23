extends Weapon_Node

var fire_rate = 0.05
@onready var fire_timer = $fire_timer
@onready var animation_player = get_parent().get_node("AnimationPlayer")

@onready var bullet_impact = preload("res://Weapons/bullet_impact.tscn")

var weapon_name = "Machine Gun"
var ammo_reserve_max = 200
var ammo_reserve = 200
var ammo_clip_max = 200
var ammo_clip = 200

var damage = 3
var can_fire = true

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

func Fire(rc):
	#Checagem se o jogador é a autoridade multiplayer, se está equipado, e se está pressionando botão de tiro
	if Input.is_action_pressed("shoot") && get_parent().is_equipped == true && get_parent().get_parent().get_parent().get_parent().get_parent().sync.is_multiplayer_authority():
		if can_fire && ammo_clip > 0:
			#Tira 1 bala do pente
			ammo_clip -= 1
			get_parent().get_parent().update_weapon_state(ammo_reserve,ammo_clip)
			
			#Calcula desvio
			var deviation_x = randf_range(-1,1)
			var deviation_y = randf_range(-1,1)
			rc.set_rotation_degrees(Vector3(deviation_x,deviation_y,0))
			
			#Verifica quem foi atingido e aplica dano
			var target = rc.get_collider()
			if target != null && target.is_in_group("Player"):
				target.take_damage.rpc_id(target.get_multiplayer_authority(), damage, str(get_parent().player.name))
				#print(get_parent().player.multiplayer.is_multiplayer_authority())
				
			if get_parent().player.sync.get_multiplayer_authority() == 1:
				#Spawnar um efeito no local de impacto
				spawn_bullet_impact(rc.get_collision_point())
			else:
				rpc_id(1,"impact_from_server",rc.get_collision_point())
			
			#Reseta o desvio do raycast
			#rc.set_rotation_degrees(Vector3(0,0,0))
		
			#Timer de taxa de disparo
			fire_timer.start(fire_rate)
			can_fire = false

@rpc("any_peer","call_local")
func impact_from_server(col):
	spawn_bullet_impact(col)

func spawn_bullet_impact(collision):
	var bi = QAL.bullet_impact.instantiate()
	Global.Effects.add_child(bi, true)
	bi.global_position = collision
	#bi.look_at(rc.get_collision_point() + rc.get_collision_normal())

func _on_fire_timer_timeout():
	can_fire = true

