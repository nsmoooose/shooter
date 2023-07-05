extends CanvasLayer

signal game_resume


func _on_leave_button_button_down():
	game_resume.emit()
