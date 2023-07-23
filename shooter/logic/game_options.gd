class_name GameOptions

const OPTIONS_FILE = "user://options.json"

static func load_config() -> Dictionary:
	if not FileAccess.file_exists(GameOptions.OPTIONS_FILE):
		var my_default_info = {
			"player": {
				"name": "player"
			}
		}
		return my_default_info

	var data = JSON.parse_string(FileAccess.get_file_as_string(OPTIONS_FILE))
	return data

static func save_config(options: Dictionary) -> void:
	var f = FileAccess.open(OPTIONS_FILE, FileAccess.WRITE)
	f.store_string(JSON.stringify(options, "  "))
