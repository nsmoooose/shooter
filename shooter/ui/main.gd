extends Node3D

func _on_hud_game_quit():
	get_tree().quit()

func _on_hud_game_start():
	get_tree().change_scene_to_file("res://game.tscn")
