extends StaticBody3D


func activate():
	get_node("AnimationPlayer").play("knife_flip")
