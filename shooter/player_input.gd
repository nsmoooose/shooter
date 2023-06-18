extends MultiplayerSynchronizer

@export var direction:Vector2 = Vector2()

func _ready():
	# Only process for the local player.
	set_process(get_multiplayer_authority() == multiplayer.get_unique_id())


func _process(_delta):
	direction = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")

