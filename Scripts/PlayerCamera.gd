extends CharacterBody3D

# Export variables allow for easy adjustment in the Godot editor.
@export var sensitivity: float = 0.1  # Mouse sensitivity for camera control
@export var max_head_angle: float = 70.0  # Maximum pitch angle for the head
@export var min_head_angle: float = -10.0  # Minimum pitch angle for the head

# Constants for movement and jumping.
const SPEED: float = 5.0
const JUMP_VELOCITY: float = 4.5

# Gravity value retrieved from project settings.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var head: Node3D = $Head  # Reference to the head node which controls camera rotation

func _ready() -> void:
	# Capture the mouse for controlling the camera.
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	# Handle mouse motion events for camera control.
	if event is InputEventMouseMotion:
		# Rotate the player character around the Y-axis (yaw) based on mouse X movement.
		rotate_y(deg_to_rad(-event.relative.x * sensitivity))
		
		# Calculate and clamp the new rotation for the head based on mouse Y movement.
		var current_head_rotation: float = head.rotation_degrees.x
		var new_head_rotation: float = current_head_rotation + event.relative.y * sensitivity
		new_head_rotation = clamp(new_head_rotation, min_head_angle, max_head_angle)
		
		# Apply the clamped rotation to the head.
		head.rotation_degrees.x = new_head_rotation

func _physics_process(delta: float) -> void:
	# Apply gravity if the character is in the air.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jumping when the jump action is pressed and the character is on the floor.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction for movement.
	var input_dir: Vector2 = Input.get_vector("left", "right", "up", "down")
	
	# Invert the input directions to match expected controls.
	input_dir.x = -input_dir.x
	input_dir.y = -input_dir.y

	# Convert the 2D input direction to 3D space.
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		# Set velocity based on movement direction.
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		# Smoothly decelerate the character when no input is detected.
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	# Move the character and handle sliding.
	move_and_slide()
