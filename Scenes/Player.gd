extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@export var cam_sens : float
@onready var camera_origion: Node3D = $"Camera Origion"

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	var look_direction = Input.get_vector("R_Left", "R_Right", "R_Up", "R_Down")
	camera_origion.rotation += Vector3(look_direction.y, look_direction.x, 0) * cam_sens
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("L_Left", "L_Right", "L_Up", "L_Down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
