extends Weapon_Node

var fire_rate = 0.1
@onready var fire_timer = $fire_timer
@onready var animation_player = get_parent().get_node("AnimationPlayer")

var weapon_name = "Ak47"
var ammo_reserve_max = 120
var ammo_reserve = 120
var ammo_clip_max = 30
var ammo_clip = 30
var eq_anim
var uneq_anim

var damage = 10
var can_fire = true


func _ready():
	fire_timer.one_shot = true

#Sempre calcula se shoot() está disponível baseado em can_fire e raycast inserido
func _process(_delta):
	shoot(get_parent().raycast_path)
	reload()
	if animation_player.is_playing && get_parent().is_equipped == false:
		animation_player.stop()

func shoot(rc):
	if Input.is_action_pressed("shoot") && get_parent().is_equipped == true:
		if can_fire && ammo_clip > 0:
			#Tira 1 bala do pente
			ammo_clip -= 1
			get_parent().get_parent().update_weapon_state(ammo_reserve,ammo_clip)
			var target = rc.get_collider()
			if target != null && target.is_in_group("Enemy"):
				target.health -= damage
				print(target,weapon_name)
			fire_timer.start(fire_rate)
			can_fire = false


func reload():
	if Input.is_action_just_pressed("reload") && get_parent().is_equipped == true:
		animation_player.play("reload")

func _on_fire_timer_timeout():
	can_fire = true


func _on_animation_player_animation_finished(anim_name):
	if ammo_reserve > ammo_clip_max:
		#Variavel auxiliar para calcular o quanto de munição deve ser recarregado
		var aux = 0
		aux = ammo_clip_max - ammo_clip
		ammo_reserve -= aux
		ammo_clip = ammo_clip_max
	else:
		ammo_clip = ammo_reserve
		ammo_reserve = 0
	get_parent().get_parent().update_weapon_state(ammo_reserve,ammo_clip)
