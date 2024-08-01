extends CanvasLayer

# Reference to the Label node within the CanvasLayer
@onready var velocity_label: Label = $Label

# Variable to hold the velocity data
var velocity: float = 0.0

func _ready() -> void:
	# Initialization if needed
	pass

func _process(_delta: float) -> void:
	# Update the label text with the current velocity
	velocity_label.text = "Velocity: %.2f" % velocity

# Function to update the velocity
func set_velocity(new_velocity: float) -> void:
	velocity = new_velocity
