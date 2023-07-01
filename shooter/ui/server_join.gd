extends CanvasLayer

signal server_menu_close;
signal server_menu_join;

@onready var itemlist = $Control/VBoxContainer/ItemList
@onready var newserver = $Control/VBoxContainer/HBoxContainer2/NewServerEdit

const SERVERS_FILE = "user://servers.json"


func load_servers():
	if not FileAccess.file_exists(SERVERS_FILE):
		return
		
	var data = JSON.parse_string(FileAccess.get_file_as_string(SERVERS_FILE))
	itemlist.clear()
	for server in data:
		itemlist.add_item(server)


func save_servers():
	var servers:Array = []
	for idx in range(itemlist.item_count):
		servers.append(itemlist.get_item_text(idx))
	var f = FileAccess.open(SERVERS_FILE, FileAccess.WRITE)
	f.store_string(JSON.stringify(servers, "  "))


func _on_back_button_button_down():
	server_menu_close.emit()


func _on_join_server_button_button_down():
	if not itemlist.is_anything_selected():
		return
	var server = itemlist.get_item_text(itemlist.get_selected_items()[0])
	server_menu_join.emit(server)


func _on_add_server_button_button_down():
	if len(newserver.text) > 0:
		itemlist.add_item(newserver.text)
		save_servers()

func _on_delete_server_button_button_down():
	for idx in itemlist.get_selected_items():
		itemlist.remove_item(idx)
		
	save_servers()


func _on_ready():
	load_servers()
