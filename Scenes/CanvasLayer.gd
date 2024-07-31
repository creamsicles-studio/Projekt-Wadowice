extends CanvasLayer

# Maximum sprint duration
@export var max_sprint_duration: float = 7.0

# Reference to the sprint bar
@onready var sprint_bar: ProgressBar = $Control/SprintBar

# Reference to the player character
var player: Node = null

func _ready() -> void:
	# Find the player character node
	player = get_parent().get_node("CharacterBody3D")
	if not player:
		print("CharacterBody3D node not found")
		return
	# Initialize the sprint bar
	sprint_bar.max_value = max_sprint_duration
	sprint_bar.value = max_sprint_duration

func _process(_delta: float) -> void:
	if not player:
		return

	# Get player state
	var is_sprinting = player.is_sprinting
	var sprint_timer = player.sprint_timer
	var sprint_cooldown_timer = player.sprint_cooldown_timer
	var can_sprint = player.can_sprint

	# Update the sprint bar
	if is_sprinting:
		# Decrease the sprint bar value while sprinting
		sprint_bar.value = max_sprint_duration - sprint_timer
	elif not can_sprint:
		# Increase the sprint bar value during cooldown
		sprint_bar.value = (sprint_cooldown_timer / player.sprint_cooldown_duration) * max_sprint_duration
	else:
		# Reset the sprint bar to full value when sprint is fully recharged
		sprint_bar.value = max_sprint_duration
