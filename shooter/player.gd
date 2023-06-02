extends CharacterBody3D

# https://www.youtube.com/watch?v=77Tsd0OuPc8
# https://github.com/devloglogan/MultiplayerFPSTutorial/blob/main/Player.gd

@export var speed = 10.0
@export var jump_velocity = 4.5

@onready var camera:Camera3D = $Camera3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var look_sensitivity = ProjectSettings.get_setting("player/look_sensitivity")
var friction:float = ProjectSettings.get_setting("player/friction")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed * delta * friction)
		velocity.z = move_toward(velocity.z, 0, speed * delta * friction)
	
	move_and_slide()

	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_VISIBLE
		
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * look_sensitivity)
		camera.rotate_x(-event.relative.y * look_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
	if event.is_action_pressed("activate"):
		get_node("Camera3D/knife").activate()

