extends CanvasLayer

@onready var command = $VSplitContainer/Panel/VBoxContainer/HBoxContainer/CommandTextEdit
@onready var history = $VSplitContainer/Panel/VBoxContainer/History

signal console_close

var commands = {}

func console_activate():
	visible = true
	command.grab_focus()
	
	
func cmd_clear():
	history.clear()


func cmd_help():
	history.append_text("[b]Help about commands that can be used.[/b]\n\n")
	for name in commands:
		history.append_text("  [b][color=green]%-20s[/color][/b] %s\n" % [name, commands[name]["desc"]])
	history.append_text("\n")


func cmd_quit():
	get_tree().quit()


func cmd_exit():
	console_close.emit()


func cmd_info():
	history.append_text("[b]Local system IP addresses:[/b]\n\n")
	for x in IP.get_local_addresses():
		history.append_text("  %s\n" % x)
	history.append_text("\n")


func _ready():
	commands["clear"] = {"call": cmd_clear, "desc": "Clear console content"}
	commands["exit"] = {"call": cmd_exit, "desc": "Exits the console"}
	commands["help"] = {"call": cmd_help, "desc": "Shows help about known commands"}
	commands["info"] = {"call": cmd_info, "desc": "Shows information about the current game"}
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
				history.append_text("ERROR: '" + cmd + "' is not a known command.\n")
