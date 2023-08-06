extends ConsoleCommand

class_name ConsoleClear

func help() -> String:
	return "Clear console content"

func execute() -> String:
	get_parent().console_clear.emit()
	return ""
