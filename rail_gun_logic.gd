extends Weapon_Node

var fire_rate = 1.6
@onready var fire_timer = $fire_timer
@onready var animation_player = get_parent().get_node("AnimationPlayer")

@onready var bullet_impact = preload("res://Weapons/bullet_impact.tscn")
@onready var coil = preload("res://Weapons/coil.tscn")
@onready var trail = preload("res://Weapons/rail_trail.tscn")

var weapon_name = "Gauss Gun"
var ammo_reserve_max = 20
var ammo_reserve = 20
var ammo_clip_max = 20
var ammo_clip = 20

var damage = 80
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
			
			#Verifica quem foi atingido e aplica dano
			var target = rc.get_collider()
			if target != null && target.is_in_group("Player"):
				target.take_damage.rpc_id(target.get_multiplayer_authority(), damage, str(get_parent().player.name))
				#print(get_parent().player.multiplayer.is_multiplayer_authority())
			
			#Spawnar um efeito no local de impacto
			rpc_id(1,"coil_from_server",rc.get_collision_point(),self.global_position)
			#Reseta o desvio do raycast
			#rc.set_rotation_degrees(Vector3(0,0,0))
		
			#Timer de taxa de disparo
			fire_timer.start(fire_rate)
			can_fire = false

@rpc("any_peer","call_local")
func coil_from_server(col,s_pos):
	var trail_scale = s_pos.distance_to(col) * 0.5
	draw_coil(col,s_pos,trail_scale)

func draw_coil(collision,start_pos,trail_scale):
	var t = QAL.trail.instantiate()
	Global.Effects.add_child(t, true)
	t.scale.y = trail_scale
	#print(t.height)
	
	t.look_at_from_position((start_pos + collision)*0.5,collision)
	t.rotation_degrees.x += 90
	pass

@rpc("any_peer","call_local")
func spawn_bullet_impact(collision):
	var bi = bullet_impact.instantiate()
	Global.add_child(bi, true)
	bi.global_position = collision
	#bi.look_at(rc.get_collision_point() + rc.get_collision_normal())

func _on_fire_timer_timeout():
	can_fire = true


