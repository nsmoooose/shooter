extends ConsoleCommand

class_name ConsoleExit

@export var node_to_hide : Node

func help() -> String:
	return "Exits the console"

func execute() -> String:
	if node_to_hide:
		node_to_hide.hide()
	return ""
