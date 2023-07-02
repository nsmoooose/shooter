extends CanvasLayer

@onready var command = $VSplitContainer/Panel/VBoxContainer/HBoxContainer/CommandTextEdit

signal console_close


func console_activate():
	visible = true
	command.grab_focus()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if command.has_focus() and event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_ESCAPE:
			get_viewport().set_input_as_handled()
			console_close.emit()

		if event.keycode == KEY_ENTER:
			get_viewport().set_input_as_handled()

			# TODO Process the text entered
