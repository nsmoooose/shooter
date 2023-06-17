@tool
extends CanvasLayer

@export var line_width:int = 2:
	set(new_width):
		line_width = new_width
		$CenterContainer/Control/h_left.width = line_width
		$CenterContainer/Control/h_right.width = line_width
		$CenterContainer/Control/v_top.width = line_width
		$CenterContainer/Control/v_bottom.width = line_width

@export var line_length:int = 20:
	set(new_length):
		line_length = new_length
		_update_crosshair()

@export var center_space:int = 5:
	set(new_center_space):
		center_space = new_center_space
		_update_crosshair()


func _update_crosshair():
	$CenterContainer/Control/h_left.points[0].x = 0 - (line_length + center_space)
	$CenterContainer/Control/h_left.points[0].y = 0
	$CenterContainer/Control/h_left.points[1].x = 0 - center_space
	$CenterContainer/Control/h_left.points[1].y = 0

	$CenterContainer/Control/h_right.points[0].x = 0 + center_space
	$CenterContainer/Control/h_right.points[0].y = 0
	$CenterContainer/Control/h_right.points[1].x = 0 + line_length + center_space
	$CenterContainer/Control/h_right.points[1].y = 0

	$CenterContainer/Control/v_top.points[0].x = 0
	$CenterContainer/Control/v_top.points[0].y = 0 - (line_length + center_space)
	$CenterContainer/Control/v_top.points[1].x = 0
	$CenterContainer/Control/v_top.points[1].y = 0 - center_space

	$CenterContainer/Control/v_bottom.points[0].x = 0
	$CenterContainer/Control/v_bottom.points[0].y = 0  + center_space
	$CenterContainer/Control/v_bottom.points[1].x = 0
	$CenterContainer/Control/v_bottom.points[1].y = 0  + line_length + center_space


func _ready():
	_update_crosshair()
