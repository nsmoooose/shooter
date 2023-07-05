extends Node3D

const PORT:int = 4433

@onready var console = $HUD/Console

var game_session_running:bool = false


func _unhandled_input(event):
	if event.is_action_pressed("console"):
		get_viewport().set_input_as_handled()
		console.console_activate()

	if event.is_action_pressed("player_stats") and game_session_running:
		get_viewport().set_input_as_handled()
		$HUD/PlayerStats.visible = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func network_host():
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer server.")
		return
	multiplayer.multiplayer_peer = peer


func network_join(server):
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(server, PORT)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer client.")
		return

	multiplayer.multiplayer_peer = peer


func game_ui_setup():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$HUD/MapMenu.visible = false
	$HUD/MainMenu.visible = false
	$HUD/Crosshair.visible = true
	game_session_running = true


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
	$HUD/ServerJoin.visible = true
	$HUD/MainMenu.visible = false


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


func _on_server_join_server_menu_close():
	$HUD/ServerJoin.visible = false
	$HUD/MainMenu.visible = true


func _on_server_join_server_menu_join(server):
	$HUD/ServerJoin.visible = false
	game_ui_setup()
	network_join(server)


func _on_pause_menu_game_leave_server():
	for x in $Network.get_children():
		x.queue_free()

	multiplayer.multiplayer_peer = null
	game_session_running = false

	$HUD/MainMenu.visible = true
	$HUD/PauseMenu.visible = false
	$HUD/Crosshair.visible = true


func _on_console_console_close():
	$HUD/Console.visible = false


func _on_player_stats_game_resume():
	$HUD/PlayerStats.visible = false
