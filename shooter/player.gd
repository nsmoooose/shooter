extends CharacterBody3D

# https://www.youtube.com/watch?v=77Tsd0OuPc8
# https://github.com/devloglogan/MultiplayerFPSTutorial/blob/main/Player.gd

@export var speed:float = 7.0
@export var jump_velocity:float = 4.5

@onready var camera:Camera3D = $Camera3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity:float = ProjectSettings.get_setting("physics/3d/default_gravity")
var look_sensitivity:float = ProjectSettings.get_setting("player/look_sensitivity")
var friction:float = ProjectSettings.get_setting("player/friction")
var reach:float = ProjectSettings.get_setting("player/reach")

signal pause
signal unpause

func _ready():
	camera.make_current()

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
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			unpause.emit()
		else:
			pause.emit()
		
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * look_sensitivity)
		camera.rotate_x(-event.relative.y * look_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)

	if event.is_action_pressed("activate"):
		var space = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create($Camera3D.global_position,
			$Camera3D.global_position - $Camera3D.global_transform.basis.z * reach)
		var collision = space.intersect_ray(query)
		if collision:
			if collision.collider.has_method("activate"):
				collision.collider.activate()

	if event.is_action_pressed("inspect"):
		get_node("Camera3D/knife").activate()
