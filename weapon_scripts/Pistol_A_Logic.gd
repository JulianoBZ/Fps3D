extends Weapon_Node

var fire_rate = 0.15
@onready var timer = $Timer

var weapon_name = "USP"
var ammo_reserve_max = 60
var ammo_reserve = 60
var ammo_clip_max = 15
var ammo_clip = 15
var eq_anim
var uneq_anim

var can_fire = true


func _ready():
	timer.one_shot = true
	
func _process(_delta):
	shoot(get_parent().raycast_path)

func shoot(rc):
	if Input.is_action_pressed("shoot") && get_parent().is_equipped == true:
		if can_fire:
			var target = rc.get_collider()
			if target != null && target.is_in_group("Enemy"):
				target.health -= 10
				print(target,weapon_name)
			timer.start(fire_rate)
			can_fire = false



func _on_timer_timeout():
	can_fire = true

