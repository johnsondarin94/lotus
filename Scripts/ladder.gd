extends StaticBody2D

@export var spawn_vector: Vector2i
@onready var player = Global.get_player_reference()
@onready var tilemap = get_parent().get_node("TileMapLayer")
var player_entered: bool = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_entered = true
		print("player entered")
		


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_entered = false
		print("player exited")


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if player_entered && event.is_action_pressed("action"):
		print("WOOOWOWO")
		var world_pos = tilemap.map_to_local(spawn_vector)
		player.position = world_pos
		
		
