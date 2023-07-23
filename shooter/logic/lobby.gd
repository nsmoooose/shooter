extends Node

# Reference from:
# https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html

# Player info, associate ID to data
var player_info = {}

# Info we send to other players
var my_info = { name = "Johnson Magenta", favorite_color = Color8(255, 0, 255) }


func _ready():
	multiplayer.peer_connected.connect(_player_connected)
	multiplayer.peer_disconnected.connect(_player_disconnected)
	multiplayer.connected_to_server.connect(_connected_ok)
	multiplayer.connection_failed.connect(_connected_fail)
	multiplayer.server_disconnected.connect(_server_disconnected)


func _player_connected(id):
	# Called on both clients and server when a peer connects. Send my info to it.
	register_player.rpc(id, my_info)

func _player_disconnected(id):
	# Erase player from info.
	player_info.erase(id)

func _connected_ok():
	# Only called on clients, not server. Will go unused; not useful here.
	pass

func _server_disconnected():
	# Server kicked us; show error and abort.
	pass

func _connected_fail():
	# Could not even connect to server; abort.
	pass

@rpc("any_peer", "call_local")
func register_player(id, info):
	# Get the id of the RPC sender and store the info.
	player_info[id] = info
