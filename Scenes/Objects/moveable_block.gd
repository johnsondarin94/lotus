extends RigidBody2D


var friction: float = 15.0

func _ready() -> void:
	add_to_group("can_trigger_plate")
		
func _physics_process(delta: float) -> void:
	linear_velocity *= (1.0 - friction * delta)
