extends Node3D

const PORT:int = 4433

func load_level(level_name: String):
	for x in $Network.get_children():
		x.queue_free()
	
	var scene:Resource = load(level_name)
	var instance:Node3D = scene.instantiate()
	$Network.add_child(instance)

func _on_pause():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$HUD/PauseMenu.visible = true	
	
func _on_pause_menu_game_resume():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$HUD/PauseMenu.visible = false

func _on_hud_game_quit():
	get_tree().quit()

func _on_hud_game_start():
	for x in $Network.get_children():
		x.queue_free()

	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer server.")
		return
	multiplayer.multiplayer_peer = peer

	load_level("res://levels/level_01.tscn")

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$HUD/MainMenu.visible = false
	$Crosshair.visible = true
	
func _on_hud_game_join():
	for x in $Network.get_children():
		x.queue_free()

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$HUD/MainMenu.visible = false
	$Crosshair.visible = true

	var peer = ENetMultiplayerPeer.new()
	peer.create_client("127.0.0.1", PORT)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer client.")
		return

	multiplayer.multiplayer_peer = peer

func _process(_delta):
	if !$HUD/MainMenu.visible and Input.is_action_just_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			_on_pause_menu_game_resume()
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			$HUD/PauseMenu.visible = true	
