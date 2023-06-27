extends CharacterBody3D

# https://www.youtube.com/watch?v=77Tsd0OuPc8
# https://github.com/devloglogan/MultiplayerFPSTutorial/blob/main/Player.gd

@export var speed:float = 7.0
@export var jump_velocity:float = 4.5

@onready var camera:Camera3D = $Camera3D
@onready var input = $PlayerInput

@export var player:int = 1:
	set(id):
		player = id
		# Give authority over the player input to the appropriate peer.
		$PlayerInput.set_multiplayer_authority(id)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity:float = ProjectSettings.get_setting("physics/3d/default_gravity")
var look_sensitivity:float = ProjectSettings.get_setting("player/look_sensitivity")
var friction:float = ProjectSettings.get_setting("player/friction")
var reach:float = ProjectSettings.get_setting("player/reach")


func _enter_tree():
	set_multiplayer_authority(str(name).to_int())


func _ready():
	if not is_multiplayer_authority():
		return

	camera.make_current()
		
	# Only process for the local player.
	set_process(get_multiplayer_authority() == multiplayer.get_unique_id())


func _physics_process(delta):
	if not is_multiplayer_authority():
		return

	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	var direction = (transform.basis * Vector3(input.direction.x, 0, input.direction.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed * delta * friction)
		velocity.z = move_toward(velocity.z, 0, speed * delta * friction)
	
	move_and_slide()


func intersect_ray(player_reach: float):
	var query = PhysicsRayQueryParameters3D.create(camera.global_position,
		camera.global_position - camera.global_transform.basis.z * player_reach)
	return get_world_3d().direct_space_state.intersect_ray(query)


func _unhandled_input(event):
	if not is_multiplayer_authority():
		return

	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * look_sensitivity)
		camera.rotate_x(-event.relative.y * look_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)

	if event.is_action_pressed("activate"):
		var collision = intersect_ray(reach)
		if collision:
			if collision.collider.has_method("activate"):
				collision.collider.activate()

	if event.is_action_pressed("inspect"):
		get_node("Camera3D/knife").inspect()

	if event.is_action_pressed("shoot"):
		get_node("Camera3D/knife").attack()

		var collision = intersect_ray(reach)
		if collision:
			if collision.collider.has_method("activate"):
				collision.collider.activate()
