extends CanvasLayer

signal game_start
signal game_options
signal game_quit

func _on_start_button_button_down():
	game_start.emit()

func _on_settings_button_button_down():
	game_options.emit()

func _on_quit_button_button_down():
	game_quit.emit()
