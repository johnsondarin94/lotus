extends Area2D

var damage: int = 1
var direction: Vector2
var attack_type: String

const PACKED_SCENE = preload("res://Scenes/Attacks/dagger_stab.tscn")
	
func _on_life_timer_timeout() -> void:
	if attack_type == "DASH_ATTACK":
		var instance = PACKED_SCENE.instantiate()
		add_child(instance)
		instance.position = global_position
		queue_free()	
	else:
		queue_free()
