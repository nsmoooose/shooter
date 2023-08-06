extends CanvasLayer

@onready var command = $VSplitContainer/BlurPanel/MarginContainer/VBoxContainer/HBoxContainer/CommandTextEdit
@onready var history = $VSplitContainer/BlurPanel/MarginContainer/VBoxContainer/History

signal console_close

var commands = {}

func console_activate():
	visible = true
	command.grab_focus()

func _input(event):
	if command.has_focus() and event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_ESCAPE:
			get_viewport().set_input_as_handled()
			console_close.emit()

		if event.keycode == KEY_ENTER:
			get_viewport().set_input_as_handled()

			var cmd = command.text
			command.text = ""

			var child = find_child(cmd)
			if child != null:
				history.append_text(child.execute())
			else:
				history.append_text("ERROR: '" + cmd + "' is not a known command.\n")


func _on_console_manager_console_clear() -> void:
	history.clear()
