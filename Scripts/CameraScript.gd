extends Node3D

@export var sensitivity: float = 0.1  # Mouse sensitivity for camera control
@export var max_head_angle: float = 70.0  # Maximum pitch angle for the head
@export var min_head_angle: float = -10.0  # Minimum pitch angle for the head

@onready var camera: Camera3D = $Camera  # Reference to the Camera3D node

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED  # Capture the mouse for camera control

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		# Rotate the head around the X-axis (pitch) based on mouse Y movement
		var new_head_rotation: float = rotation_degrees.x + event.relative.y * sensitivity
		rotation_degrees.x = clamp(new_head_rotation, min_head_angle, max_head_angle)
		
		# Rotate the parent (typically the player character) around the Y-axis (yaw) based on mouse X movement
		get_parent().rotate_y(deg_to_rad(-event.relative.x * sensitivity))
