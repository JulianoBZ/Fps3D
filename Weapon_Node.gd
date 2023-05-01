extends Weapon_Node

var raycast_path
var is_equipped = false
var damage = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_raycast(rc):
	raycast_path = rc

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	is_equipped = get_parent().is_equipped
	shoot()

func shoot():
	if Input.is_action_just_pressed("shoot") && is_equipped == true:
		var target = raycast_path.get_collider()
		if target.is_in_group("Enemy"):
			target.health -= 10
			print(target)
