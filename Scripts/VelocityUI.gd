extends CanvasLayer

# Reference to the Label node within the CanvasLayer
@onready var velocity_ui: Label = $VelocityUI

# Variable to store the current velocity
var velocity: float = 0.0

func _ready() -> void:
	# Initialization code can be added here if needed
	pass

func _process(delta: float) -> void:
	# Update the label's text to display the current velocity
	velocity_ui.text = "Velocity: %.2f" % velocity

# Method to set a new velocity value
func set_velocity(new_velocity: float) -> void:
	velocity = new_velocity
