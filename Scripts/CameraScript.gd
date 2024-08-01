extends Node3D

# Camera control parameters
@export var sensitivity: float = 0.1  # Sensitivity of mouse movement for controlling the camera
@export var max_head_angle: float = 70.0  # Maximum pitch angle (up/down) for the camera
@export var min_head_angle: float = -10.0  # Minimum pitch angle (up/down) for the camera

# Node references
@onready var camera_3d: Camera3D = $Camera3D  # Reference to the Camera3D node

func _ready() -> void:
	# Set mouse mode to captured, so the cursor is hidden and used for camera control
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		# Update the head's pitch (X-axis rotation) based on mouse Y movement
		var new_head_rotation: float = rotation_degrees.x + event.relative.y * sensitivity
		rotation_degrees.x = clamp(new_head_rotation, min_head_angle, max_head_angle)
		
		# Update the parent's yaw (Y-axis rotation) based on mouse X movement
		get_parent().rotate_y(deg_to_rad(-event.relative.x * sensitivity))
