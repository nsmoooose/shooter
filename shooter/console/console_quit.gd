extends ConsoleCommand

class_name ConsoleQuit

func help() -> String:
	return "Quits this game"

func execute() -> String:
	get_tree().quit()
	return ""
