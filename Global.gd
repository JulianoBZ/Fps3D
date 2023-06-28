extends Node

var player_class
var desired_class
var primary
var desired_primary
var secondary
var desired_secondary

var P_Name = "Player"

@onready var MP_ID = 0
@onready var level = $Level
@onready var Players = $Players
@onready var Effects = $Effects
@onready var world_camera = Node
@onready var world_spawn_hud = Node

#####Networking
var server_name = "Server"
var server_pass = ""
var server_address = ""
var server_slots = 6
var is_hosting = false

var server_list = []
