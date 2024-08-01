extends CharacterBody3D

# Movement parameters
@export var speed: float = 5.0  # Default movement speed
@export var sprint_speed: float = 10.0  # Speed while sprinting
@export var jump_velocity: float = 4.5  # Jumping velocity
@export var max_sprint_duration: float = 7.0  # Maximum sprint duration in seconds
@export var sprint_cooldown_duration: float = 10.0  # Cooldown duration after sprinting in seconds

# Internal state variables
var gravity: float = 10.0
var is_sprinting: bool = false
var sprint_timer: float = 0.0
var sprint_cooldown_timer: float = 0.0
var can_sprint: bool = true

func _ready() -> void:
	# Initialize sprinting state
	sprint_cooldown_timer = 0.0
	can_sprint = true

func _physics_process(delta: float) -> void:
	# Update physics for each frame
	handle_gravity(delta)
	handle_jumping()
	handle_sprinting(delta)
	handle_movement(delta)
	move_and_slide()

# Apply gravity to the character when not on the floor
func handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

# Apply jump velocity if the jump action is pressed and the character is on the floor
func handle_jumping() -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

# Manage sprinting mechanics, including cooldowns
func handle_sprinting(delta: float) -> void:
	if not can_sprint:
		sprint_cooldown_timer += delta
		if sprint_cooldown_timer >= sprint_cooldown_duration:
			can_sprint = true
			sprint_cooldown_timer = 0.0

	if is_on_floor():
		if Input.is_action_pressed("sprint") and can_sprint:
			if sprint_timer < max_sprint_duration:
				is_sprinting = true
				sprint_timer += delta
			else:
				# Reset sprinting state and start cooldown period
				is_sprinting = false
				can_sprint = false
				sprint_cooldown_timer = 0.0
				sprint_timer = 0.0
		else:
			is_sprinting = false

# Handle character movement based on input and sprinting state
func handle_movement(delta: float) -> void:
	var input_dir: Vector2 = Input.get_vector("left", "right", "up", "down")
	input_dir.x = -input_dir.x  # Invert X direction for correct movement
	input_dir.y = -input_dir.y  # Invert Y direction for correct movement
	
	# Calculate movement direction in the 3D space
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	var current_speed: float = speed
	if is_sprinting:
		current_speed = sprint_speed

	if direction.length_squared() > 0:  # Only move if direction is valid
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		# Apply deceleration when no input is given
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
