extends Node3D

const PORT:int = 4433

func network_host():
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer server.")
		return
	multiplayer.multiplayer_peer = peer


func network_join():
	var peer = ENetMultiplayerPeer.new()
	peer.create_client("127.0.0.1", PORT)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer client.")
		return

	multiplayer.multiplayer_peer = peer


func game_ui_setup():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$HUD/MapMenu.visible = false
	$HUD/MainMenu.visible = false
	$Crosshair.visible = true


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
	$HUD/MainMenu.visible = false
	$HUD/MapMenu.visible = true
	

func _on_hud_game_join():
	game_ui_setup()
	network_join()


func _process(_delta):
	if !$HUD/MainMenu.visible and Input.is_action_just_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			_on_pause_menu_game_resume()
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			$HUD/PauseMenu.visible = true	


func _on_map_menu_map_garden_day():
	network_host()
	game_ui_setup()
	load_level("res://maps/garden_by_day.tscn")


func _on_map_menu_map_garden_night():
	network_host()
	game_ui_setup()
	load_level("res://maps/garden_by_night.tscn")


func _on_map_menu_map_menu_close():
	$HUD/MapMenu.visible = false
	$HUD/MainMenu.visible = true
