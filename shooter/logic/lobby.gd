extends Node

# Reference from:
# https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html

# Player info, associate ID to data
var all_players = {}

func _ready():
	multiplayer.peer_connected.connect(_player_connected)
	multiplayer.peer_disconnected.connect(_player_disconnected)
	multiplayer.connected_to_server.connect(_connected_ok)
	multiplayer.connection_failed.connect(_connected_fail)
	multiplayer.server_disconnected.connect(_server_disconnected)


func _player_connected(id):
	# Called on both clients and server when a peer connects. Send my info to it.
	var player_info = GameOptions.load_config()["player"]
	register_player.rpc(id, player_info)

func _player_disconnected(id):
	# Erase player from info.
	all_players.erase(id)

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
	all_players[id] = info
