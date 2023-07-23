extends CanvasLayer

@onready var players = $Control/VBoxContainer/players


func update_player_list(updated_player_list):
	for node in players.get_children():
		node.queue_free()

	var res = preload("res://ui/player_status_row.tscn")
	for player in updated_player_list:
		var instance: Node = res.instantiate()
		players.add_child(instance)
