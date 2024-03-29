extends Node3D


func _ready():
	# We only need to spawn players on the server.
	if not multiplayer.is_server():
		return

	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(del_player)

	# Spawn already connected players.
	for id in multiplayer.get_peers():
		add_player(id)

	# Spawn the local player unless this is a dedicated server export.
	if not OS.has_feature("dedicated_server"):
		add_player(1)


func _exit_tree():
	pass

	# TODO Check if this is needed or properly disconnected.
	# if not multiplayer.is_server():
	#	return
	# multiplayer.peer_connected.disconnect(add_player)
	# multiplayer.peer_disconnected.disconnect(del_player)


func add_player(id: int):
	var nodes:Array[Node] = get_tree().get_nodes_in_group("spawnpoints")
	var pos = nodes[randi() % nodes.size()].global_position

	var character = preload("res://player.tscn").instantiate()
	character.player = id
	character.name = str(id)
	$Players.add_child(character, true)

	character.global_position = pos


func del_player(id: int):
	if not $Players.has_node(str(id)):
		return
	$Players.get_node(str(id)).queue_free()
