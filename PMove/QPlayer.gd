extends CharacterBody3D

#Network
@onready var sync = $Player_Sync
@onready var camera = $Head/Camera3D
@onready var weapon_manager_path = $Head/Weapons
#var Network_ID

#Stats
@export var player_class : int
@export var primary_weapon : String
@export var secondary_weapon : String
var melee_weapon
var head
var speedLabel
var grounded = false
var wishJump = false
@export var health = 100
@onready var Cmd = $Cmd

# Movement Varabiles
var deltaTime : float
@export var gravity  : float = 20
@export var friction : float = 6
@export var moveSpeed              : float = 10   # Ground move speed
@export var runAcceleration        : float = 20    # Ground accel
@export var runDeacceleration      : float = 10    # Deacceleration that occurs when running on the ground
@export var airAcceleration        : float = 1.0   # Air accel
@export var airDeacceleration      : float = 10.0   # Deacceleration experienced when opposite strafing
@export var airControl             : float = 0.1   # How precise air control is
@export var jumpSpeed              : float = 8.0   # The speed at which the characters up axis gains when hitting jump
@export var holdJumpToBhop         : bool = true  # When enabled allows player to just hold jump button to keep on bhopping perfectly
var playerFriction         : float = 0.0

# All Vector Varabiles
var moveDirection : Vector3 = Vector3()
var moveDirectionNorm : Vector3 = Vector3()
var playerVelocity : Vector3 = Vector3()
var playerTopVelocity : float = 0.0

#All node path exports
@export var headPath: NodePath
@export var speedReadout: NodePath
@export var mouseSens = .1

func _ready():
	#print("QPlayer Primary: ",primary_weapon)
	
	
	
	sync.set_multiplayer_authority(str(name).to_int())
	camera.current = sync.is_multiplayer_authority()
	
	#print("Player Scene Authority: ",sync.get_multiplayer_authority())
	############################################
	if sync.is_multiplayer_authority():
		$Head/HUD.show()
		$Head/HUD.update_class_ui(Global.desired_class)
		head = get_node(headPath) #Gets the head
		speedLabel = get_node(speedReadout) #Gets the UI Element
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) #Sets the mouse to captured
		
		primary_weapon = Global.desired_primary
		sync.primary_weapon = primary_weapon
		
		secondary_weapon = Global.desired_secondary
		sync.secondary_weapon = secondary_weapon

func _input(event):
	if sync.is_multiplayer_authority():
		#This will rotate the head based off mouse movement
		if event is InputEventMouseMotion:
			rotate_y(deg_to_rad(-event.relative.x * mouseSens))
			head.rotate_x(deg_to_rad(-event.relative.y * mouseSens))
			head.rotation.x = clamp(head.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _physics_process(delta):
	#sync.health = health
	
	if sync.is_multiplayer_authority():
		camera.current = sync.is_multiplayer_authority()
		
		
		deltaTime = delta
		# Quit the Game
		if Input.is_action_just_pressed("ui_cancel"):
			get_tree().quit()
		
		#Calls all functions based off if player is on the ground or not
		QueueJump()
		if is_on_floor():
			GroundMove()
		else:
			AirMove()
		
		#This will move the player
		set_velocity(playerVelocity)
		set_up_direction(Vector3.UP)
		move_and_slide()
		
		#Show the players current speed
		speedLabel.text = str(playerVelocity.length())
		speedLabel.text += "\n "+str(" X: ",rotation_degrees.y," - "," Y: ",$Head.rotation_degrees.x)
		
		
		##################
		sync.position = position
		sync.rotation = rotation
		
		sync.primary_weapon = primary_weapon
		sync.secondary_weapon = secondary_weapon
		
		$Label3D.text = str(sync.get_multiplayer_authority())+"/"+str(health)
		
		if Input.is_action_just_pressed("kys"):
			take_damage(100,str(self.name))
			health -= 100
		
		if health <= 0:
			#if multiplayer.is_server():
			#	death()
			#else:
			death()
			#rpc_id(1,"death_from_server")
				
###############################################################

#Qualquer peer pode chamar a função de dano
@rpc("any_peer")
func take_damage(dmg,from):
	health -= dmg
	if health <= 0:
		rpc_id(1,"score_kill_from_server",from)
		death()

#O servidor apaga o avatar do jogador e manda o jogador para a tela de seleção
@rpc("any_peer","call_local")
func death_from_server(dead):
	#rpc_id(id,"death")
	Global.get_node("PlayerInfo").get_node(str(dead)).deaths += 1
	queue_free()

func spawn_ammo_box(pos):
	var ab = QAL.ammo_box.instantiate()
	Global.Effects.add_child(ab, true)
	ab.global_position = pos

#Jogador sendo mandado para a tela de seleção
#@rpc("any_peer","call_local")
func death():
	spawn_ammo_box(global_position)
	Global.world_camera.make_current()
	Global.world_spawn_hud.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#if !multiplayer.is_server():
	#queue_free()
	rpc_id(1,"death_from_server",self.name)

@rpc("any_peer","call_local")
func score_kill_from_server(from):
	Global.get_node("PlayerInfo").get_node(str(from)).kills += 1

#get_parent().player.take_knockback(Vector3(get_parent().raycast_path.global_rotation.y/PI,
#									-get_parent().raycast_path.global_rotation.x/PI,0),20,10)

func max_ammo():
	$Head/Weapons.max_ammo()

@rpc("any_peer")
func take_knockback(wishdir,speed, accel,type):
	print("Wish Degs: ",wishdir)
	#Type 1 = Shotgun
	#Type 2 = Explosão
	match type:
		1:
			wishdir.y /= 90
			
			#Não me pergunte por que 90, mas funcionou
			#Pegando os seno e cosseno dos radianos do grau X fornecido
			var dir = wishdir.x + 90
			var cos = cos(deg_to_rad(dir))
			var sen = sin(deg_to_rad(dir))
			
			#Pega a wishdir.y e faz uma relação onde  quanto mais Y, menos X/Z, e vice versa
			var relative = wishdir.y
			var y_check
			if relative < 0:
				relative = abs(relative)
			y_check = abs(relative - 1)
			
			wishdir.z = sen * (y_check)
			wishdir.x = cos * (y_check)
			
		2:
			var dir = wishdir.x + 180
			var cos = cos(deg_to_rad(dir))
			var sen = sin(deg_to_rad(dir))
			
			wishdir.z = cos
			wishdir.x = sen
			wishdir.y /= 90
	
	
	accelerate(wishdir, speed, accel)


############################################################
func set_cmd():
	if sync.is_multiplayer_authority():
		#Sets forward move and right move
		Cmd._set_forwardMove(-transform.basis.z * (Input.get_action_strength("forward") - Input.get_action_strength("backwards")))
		Cmd._set_rightMove(-transform.basis.x * (Input.get_action_strength("left") - Input.get_action_strength("right")))

func QueueJump():
	if sync.is_multiplayer_authority():
		#This lets you queue the next jump
		if holdJumpToBhop:
			wishJump = Input.is_action_pressed("jump")
			return
		
		if Input.is_action_just_pressed("jump"):
			wishJump = true
		
		if Input.is_action_just_released("jump"):
			wishJump = false;

func AirMove():
	if sync.is_multiplayer_authority():
		#Allows for movement to slightly increase as you move through the air
		var wishdir : Vector3
		#var wishvel : float = airAcceleration
		var accel : float
		
		set_cmd()
		
		wishdir = Cmd.forwardmove + Cmd.rightmove
		
		var wishspeed = wishdir.length()
		wishspeed *= moveSpeed
		
		wishdir.normalized()
		moveDirectionNorm = wishdir
		
		var wishspeed2 = wishspeed
		if playerVelocity.dot(wishdir) < 0:
			accel = airDeacceleration
		else:
			accel = airAcceleration
		
		accelerate(wishdir, wishspeed, airAcceleration); # accel
		
		playerVelocity.y -= gravity * deltaTime

func GroundMove():
	if sync.is_multiplayer_authority():
		#Allows for normal movement on the ground
		var wishdir : Vector3
		var wishvel : Vector3
		
		if !wishJump:
			ApplyFriction(2.0)
		else:
			ApplyFriction(0)
		
		set_cmd()
		
		wishdir = Cmd.forwardmove + Cmd.rightmove
		wishdir.normalized()
		moveDirectionNorm = wishdir
		
		var wishspeed = wishdir.length()
		wishspeed *= moveSpeed
		
		accelerate(wishdir, wishspeed, runAcceleration)
		
		playerVelocity.y = 0
		
		if wishJump:
			playerVelocity.y = jumpSpeed
			wishJump = false
			$AudioStreamPlayer.play()
		
		speedLabel.text += str("Direction: ",wishdir)

func ApplyFriction(t : float):
	if sync.is_multiplayer_authority():
		#Applys friction based off t
		var vec : Vector3 = playerVelocity
		var vel : float
		var speed : float
		var newspeed : float
		var control : float
		var drop : float
		
		vec.y = 0.0
		speed = vec.length()
		drop = 0.0
		
		if is_on_floor():
			if speed < runDeacceleration:
				control = runDeacceleration
			else:
				control = speed
			
			drop = control * friction * deltaTime * t;
		
		newspeed = speed - drop;
		playerFriction = newspeed;
		if newspeed < 0:
			newspeed = 0
		if speed > 0:
			newspeed /= speed
		
		playerVelocity.x *= newspeed
		playerVelocity.z *= newspeed
	

func accelerate(wishdir : Vector3, wishspeed : float, accel : float):
	if sync.is_multiplayer_authority():
		#Allows the player to accelerate faster
		var addspeed : float
		var accelspeed : float
		var currentspeed : float
		
		currentspeed = playerVelocity.dot(wishdir)
		addspeed = wishspeed - currentspeed
		if addspeed <= 0:
			return
		accelspeed = accel * deltaTime * wishspeed;
		if accelspeed > addspeed:
			accelspeed = addspeed
		
		playerVelocity.x += accelspeed * wishdir.x
		playerVelocity.y += accelspeed * wishdir.y
		playerVelocity.z += accelspeed * wishdir.z
	

