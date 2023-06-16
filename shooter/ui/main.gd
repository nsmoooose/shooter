extends Node3D

func load_level(level_name: String):
	for x in $Level.get_children() + $HUD.get_children():
		x.queue_free()
	
	var scene:Resource = load(level_name)
	var instance:Node3D = scene.instantiate()
	$Level.add_child(instance)
	
	var player:Resource = load("res://player.tscn")
	var player_instance = player.instantiate()
	player_instance.pause.connect(_on_pause)
	player_instance.unpause.connect(_on_unpause)
	$Players.add_child(player_instance)
	
	$Camera3D.queue_free()
	
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
	load_level("res://levels/level_01.tscn")
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
