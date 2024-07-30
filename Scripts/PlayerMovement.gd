extends CharacterBody3D

@export var speed: float = 5.0  # Movement speed
@export var jump_velocity: float = 4.5  # Velocity when jumping

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta  # Apply gravity when in the air

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity  # Jump when the action is pressed and on the floor

	var input_dir: Vector2 = Input.get_vector("left", "right", "up", "down")
	input_dir.x = -input_dir.x
	input_dir.y = -input_dir.y

	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
