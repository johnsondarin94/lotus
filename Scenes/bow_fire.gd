extends Node2D

var direction: Vector2



func _ready() -> void:
	var arrow_scene = preload("res://Scenes/arrow.tscn")
	var arrow_instance = arrow_scene.instantiate()
	
	arrow_instance.direction = get_bow_fire_direction()
	var player = Global.get_player_reference()
	if abs(arrow_instance.direction.x) > abs(arrow_instance.direction.y):
		arrow_instance.direction = Vector2.RIGHT if arrow_instance.direction.x > 0 else Vector2.LEFT
		if arrow_instance.direction == Vector2.RIGHT:
			arrow_instance.rotation = deg_to_rad(45.0) * arrow_instance.direction.x
		else: arrow_instance.rotation = deg_to_rad(135) * arrow_instance.direction.x
	else:
		arrow_instance.direction = Vector2.DOWN if arrow_instance.direction.y > 0 else Vector2.UP
		if arrow_instance.direction == Vector2.UP:
			arrow_instance.rotation = deg_to_rad(45.0) * arrow_instance.direction.y
		else: arrow_instance.rotation = deg_to_rad(135.0) * arrow_instance.direction.y
		
	arrow_instance.global_position = global_position
	player.get_tree().current_scene.add_child(arrow_instance)


func _on_lifetime_timeout() -> void:
	queue_free()
	

func get_bow_fire_direction() -> Vector2:
	return direction
