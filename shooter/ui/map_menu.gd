extends CanvasLayer

signal map_garden_day
signal map_garden_night
signal map_warm_up_room1
signal map_menu_close


func _on_garden_day_button_button_down():
	map_garden_day.emit()


func _on_garden_night_button_button_down():
	map_garden_night.emit()


func _on_warm_up_room_1_button_button_down():
	map_warm_up_room1.emit()


func _on_back_button_button_down():
	map_menu_close.emit()
