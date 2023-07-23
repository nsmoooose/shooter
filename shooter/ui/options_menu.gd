extends CanvasLayer

@onready var playername = $Control/MarginContainer/VBoxContainer/TabContainer/Player/MarginContainer/HBoxContainer/PlayerNameTextEdit

signal game_options_apply
signal game_resume


func _on_ready():
	var data = GameOptions.load_config()
	playername.text = data["player"]["name"]


func _on_apply_button_button_down():
	var options: Dictionary = {
		"player": {
			"name": playername.text
		}
	}

	GameOptions.save_config(options)

	game_options_apply.emit()


func _on_back_button_button_down():
	game_resume.emit()
