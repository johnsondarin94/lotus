extends StaticBody2D

const MOVABLE_SCENE := preload("res://Scenes/Objects/moveable_block.tscn")


func _on_trigger_plate_plate_triggered() -> void:
	call_deferred("replace_block")

func replace_block() -> void:
	var moveable := MOVABLE_SCENE.instantiate()
	moveable.global_position = global_position
	moveable.linear_velocity = Vector2.ZERO
	get_parent().add_child(moveable)
	queue_free()
