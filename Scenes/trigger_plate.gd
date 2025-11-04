extends StaticBody2D

signal plate_triggered


func _on_area_trigger_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("can_trigger_plate"):
		emit_signal("plate_triggered")


func _on_area_trigger_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("can_trigger_plate"):
		print("Area Exited")
