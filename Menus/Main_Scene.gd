extends Node2D

@onready var map_test = preload("res://Mapping/world.tscn").instantiate()
@onready var map_test_path = "res://Mapping/world.tscn"

var PORT = 1233

var preset_names = []
var total_names = 0
var rnd = RandomNumberGenerator.new()
@onready var name_file = 'res://Menus/preset_names.txt'

func _ready():
	load_names(name_file)
	var name_number = rnd.randi_range(0,total_names-1)
	$Nickname/Player_name_insert.text = preset_names[name_number]
	for adress in IP.get_local_addresses():
		if adress.split(".").size() == 4 && adress.begins_with("192"):
			$self_ip.text = str(adress)
			$IP_address_insert.text = str(adress)

func load_names(file):
	var f = FileAccess.open(file, FileAccess.READ)
	var index = 1
	while not f.eof_reached(): # iterate through all lines until the end of file is reached
		var line = f.get_line()
		preset_names.append(str(line))
		index += 1
	f.close()
	total_names = index
	return

##############################################

func _on_host_button_pressed():
	Global.P_Name = $Nickname/Player_name_insert.text
	if (Network.start_server(PORT) == true):
		#Network.connect_to_server(str($IP_address_insert.text), 1234)
		Network.loaded_map = map_test_path
		start_game(load(Network.loaded_map).instantiate())
		

func _on_join_button_pressed():
	Global.P_Name = $Nickname/Player_name_insert.text
	if (Network.connect_to_server(str($IP_address_insert.text), PORT)) == true:
		self.hide()
	#start_game(Network.loaded_map)
	#print(Network.loaded_map)

func start_game(map):
	Global.level.add_child(map)
	self.hide()

func _on_main_connect_pressed():
	if (Network.connect_to_server("192.168.0.15", 1234) == true):
		#print(Network.connect_to_server("192.168.0.15", 1234))
		#Network.rpc_id(1,"request_server_list",multiplayer.get_unique_id())
		$Server_list.text = str(Global.server_list)
