extends Area2D

var direction: Vector2

func _on_timer_timeout() -> void:
	queue_free()
