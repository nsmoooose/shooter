extends StaticBody3D

@onready var anim_player = $AnimationPlayer


@rpc("call_local")
func knife_flip():
	anim_player.stop()
	anim_player.play("knife_flip")


func inspect():
	knife_flip.rpc()
