extends Node3D

@export var activated:bool = false
@export var lamp:Node3D

func toggle():
	if not lamp:
		return

	if lamp.has_method("toggle"):
		lamp.toggle()
	for n in lamp.get_children():
		if n.has_method("toggle"):
			n.toggle()
	
func activate():
	toggle()