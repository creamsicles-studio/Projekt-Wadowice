extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# You can add initialization code here
	pass  # 'pass' is a placeholder indicating that the function is empty

func _physics_process(delta: float) -> void:
	const move_speed := 4.0
	# Assuming %path_follow_3d is a placeholder for a PathFollow3D node reference
	# Make sure to replace %path_follow_3d with the correct node path or variable
	$Path3D/PathFollow3D.progress += move_speed * delta
