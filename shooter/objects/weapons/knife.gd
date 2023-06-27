extends StaticBody3D

@onready var anim_player = $AnimationPlayer


@rpc("call_local")
func knife_flip():
	anim_player.stop()
	anim_player.play("knife_flip")


func inspect():
	knife_flip.rpc()


@rpc("call_local")
func knife_stab():
	anim_player.stop()
	anim_player.play("stab")

func attack():
	knife_stab.rpc()
