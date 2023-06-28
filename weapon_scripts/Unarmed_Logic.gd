extends Weapon_Node

var fire_rate = 0.3
@onready var timer = $Timer

var weapon_name = "Fists"
var ammo_reserve_max = 0
var ammo_reserve = 0
var ammo_clip_max = 0
var ammo_clip = 0
var eq_anim
var uneq_anim

var range = 3.2
var damage = 10
var can_fire = true

func _ready():
	timer.one_shot = true

#Sempre calcula se shoot() está disponível baseado em can_fire e raycast inserido
func _process(_delta):
	Fire(get_parent().raycast_path)

func Fire(rc):
	if Input.is_action_pressed("shoot") && get_parent().is_equipped == true:
		if can_fire:
			var target = rc.get_collider()
			#Só aplica o dano se o target estiver dentro de um range
			if target != null && target.is_in_group("Enemy") && get_parent().player.global_position.distance_to(target.global_position) < range:
				target.take_damage.rpc_id(target.get_multiplayer_authority(), damage, str(get_parent().player.name))
			timer.start(fire_rate)
			can_fire = false



func _on_timer_timeout():
	can_fire = true

