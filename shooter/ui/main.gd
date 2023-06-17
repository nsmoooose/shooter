extends Node3D

const PORT:int = 4433

func load_level(level_name: String):
	for x in $Network.get_children():
		x.queue_free()
	
	var scene:Resource = load(level_name)
	var instance:Node3D = scene.instantiate()
	$Network.add_child(instance)
	
	var player:Resource = load("res://player.tscn")
	var player_instance = player.instantiate()
	player_instance.pause.connect(_on_pause)
	player_instance.unpause.connect(_on_unpause)
	$Network.add_child(player_instance)
	
func _on_pause():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	var pause_res:Resource = load("res://ui/pause_menu.tscn")
	var pause_instance = pause_res.instantiate()
	$HUD.add_child(pause_instance)
	
	pause_instance.game_resume.connect(_on_unpause)
	
func _on_unpause():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	for x in $HUD.get_children():
		x.queue_free()

func _on_hud_game_quit():
	get_tree().quit()

func _on_hud_game_start():
	for x in $Network.get_children() + $HUD.get_children():
		x.queue_free()

	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer server.")
		return
	multiplayer.multiplayer_peer = peer

	load_level("res://levels/level_01.tscn")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$Crosshair.visible = true
	
func _on_hud_game_join():
	for x in $Network.get_children() + $HUD.get_children():
		x.queue_free()
	$Crosshair.visible = true

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	var peer = ENetMultiplayerPeer.new()
	peer.create_client("127.0.0.1", PORT)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer client.")
		return

	multiplayer.multiplayer_peer = peer
