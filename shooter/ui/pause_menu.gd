extends CanvasLayer

signal game_resume
signal game_options
signal game_leave_server

func _on_resume_button_button_down():
	game_resume.emit()

func _on_settings_button_button_down():
	game_options.emit()

func _on_leave_button_button_down():
	game_leave_server.emit()
