extends CanvasLayer

const OPTIONS_FILE = "user://options.json"

@onready var playername = $Control/MarginContainer/VBoxContainer/TabContainer/Player/MarginContainer/HBoxContainer/PlayerNameTextEdit

signal game_options_apply
signal game_resume


func _on_ready():
	if not FileAccess.file_exists(OPTIONS_FILE):
		return

	var data = JSON.parse_string(FileAccess.get_file_as_string(OPTIONS_FILE))
	playername.text = data["player"]["name"]


func _on_apply_button_button_down():
	var options: Dictionary = {
		"player": {
			"name": playername.text
		}
	}

	var f = FileAccess.open(OPTIONS_FILE, FileAccess.WRITE)
	f.store_string(JSON.stringify(options, "  "))

	game_options_apply.emit()


func _on_back_button_button_down():
	game_resume.emit()
