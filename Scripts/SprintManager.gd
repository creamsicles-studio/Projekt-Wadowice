extends Node

@export var sprint_speed: float = 10.0 # Sprint speed
@export var max_sprint_duration: float = 7.0 # Maximum sprint duration
@export var sprint_cooldown_duration: float = 10.0 # Sprint cooldown duration

var is_sprinting: bool = false # Flag indicating if the player is currently sprinting
var sprint_timer: float = 0.0 # Timer to keep track of sprint duration
var sprint_cooldown_timer: float = 0.0 # Timer to manage sprint cooldown
var can_sprint: bool = true # Flag indicating if the player can currently sprint

@onready var velocity_ui = $"../VelocityUI" # Reference to the CanvasLayer node

func _ready() -> void:
	sprint_cooldown_timer = 0.0 # Initialize cooldown timer
	can_sprint = true # Reset sprint availability

func _process(delta: float) -> void:
	# Handle sprint cooldown
	if not can_sprint:
		sprint_cooldown_timer += delta
		if sprint_cooldown_timer >= sprint_cooldown_duration:
			can_sprint = true # Allow sprinting again
			sprint_cooldown_timer = 0.0 # Reset cooldown timer

func start_sprint() -> void:
	if can_sprint:
		is_sprinting = true
		if sprint_timer < max_sprint_duration:
			sprint_timer += get_process_delta_time()
		else:
			# Sprint duration expired, stop sprinting and start cooldown
			is_sprinting = false
			can_sprint = false
			sprint_cooldown_timer = 0.0
			sprint_timer = 0.0

func stop_sprint() -> void:
	is_sprinting = false
	if sprint_timer > 0:
		sprint_timer = max(sprint_timer - get_process_delta_time(), 0) # Decrease sprint timer

func update_velocity_ui(velocity_magnitude: float) -> void:
	# Update the UI to display the current velocity
	velocity_ui.set_velocity(velocity_magnitude)
