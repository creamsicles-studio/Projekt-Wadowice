extends CanvasLayer

# Maksymalny czas sprintu
@export var max_sprint_duration: float = 7.0

# Odniesienie do wskaźnika sprintu
@onready var sprint_bar: ProgressBar = $Control/SprintBar

# Referencja do postaci
var player: Node = null

func _ready() -> void:
	# Znalezienie referencji do postaci
	player = get_parent().get_node("CharacterBody3D")
	if not player:
		print("Nie znaleziono węzła CharacterBody3D")
		return
	# Inicjalizacja wskaźnika sprintu
	sprint_bar.max_value = max_sprint_duration
	sprint_bar.value = max_sprint_duration

func _process(delta: float) -> void:
	if not player:
		return

	# Aktualizacja wskaźnika sprintu
	var is_sprinting = player.is_sprinting
	var sprint_timer = player.sprint_timer
	var sprint_cooldown_timer = player.sprint_cooldown_timer
	var can_sprint = player.can_sprint

	if is_sprinting:
		sprint_bar.value = max_sprint_duration - sprint_timer
	elif not can_sprint:
		sprint_bar.value = max_sprint_duration - sprint_cooldown_timer
	else:
		sprint_bar.value = max_sprint_duration
