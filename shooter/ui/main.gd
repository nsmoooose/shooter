extends Node3D

func load_level(level_name: String):
	for x in $Level.get_children() + $HUD.get_children():
		x.queue_free()
	
	var scene = load(level_name)
	var instance = scene.instantiate()
	$Level.add_child(instance)
	
	var player = load("res://player.tscn")
	instance = player.instantiate()
	$Level.add_child(instance)
	
	$Camera3D.queue_free()

func _on_hud_game_quit():
	get_tree().quit()

func _on_hud_game_start():
	load_level("res://levels/level_01.tscn")
