extends Node3D

@export var activated:bool = false
@export var lamp:Node3D

@rpc("any_peer", "call_local")
func toggle():
	if not lamp:
		return

	activated = !activated
	if lamp.has_method("toggle"):
		lamp.toggle()
	for n in lamp.get_children():
		if n.has_method("toggle"):
			n.toggle()


func activate():
	toggle.rpc()
	if activated:
		$AnimationPlayer.play("on")
	else:
		$AnimationPlayer.play("off")
