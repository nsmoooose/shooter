extends CanvasLayer

@onready var command = $VSplitContainer/Panel/VBoxContainer/HBoxContainer/CommandTextEdit
@onready var history = $VSplitContainer/Panel/VBoxContainer/History

signal console_close

var commands = {}

func console_activate():
	visible = true
	command.grab_focus()


func cmd_help():
	for name in commands:
		history.add_text(name + ":  " + commands[name]["desc"] + "\n")


func cmd_quit():
	get_tree().quit()


func cmd_exit():
	console_close.emit()


func _ready():
	commands["exit"] = {"call": cmd_exit, "desc": "Exits the console"}
	commands["help"] = {"call": cmd_help, "desc": "Shows help about known commands"}
	commands["quit"] = {"call": cmd_quit, "desc": "Quits this game"}


func _input(event):
	if command.has_focus() and event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_ESCAPE:
			get_viewport().set_input_as_handled()
			console_close.emit()

		if event.keycode == KEY_ENTER:
			get_viewport().set_input_as_handled()

			var cmd = command.text
			command.text = ""

			if cmd in commands:
				commands[cmd]["call"].call()
			else:
				history.add_text("ERROR: '" + cmd + "' is not a known command.\n")
