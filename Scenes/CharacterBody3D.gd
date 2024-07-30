extends CharacterBody3D

@onready var head = $Head
var  sensitivity = 0.1

const SPEED = 5.0
const JUMP_VELOCITY = 4.5


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event):
		if event is  InputEventMouseMotion:
			rotate_y(deg_to_rad(-event.relative.x*sensitivity))
			head.rotate_x(deg_to_rad(event.relative.y*sensitivity))
		
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	
	# Fix input inversion by inverting the x and y directions.
	input_dir.x = -input_dir.x
	input_dir.y = -input_dir.y

	# Calculate the direction in world space.
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	# Move the character and handle sliding.
	move_and_slide()
