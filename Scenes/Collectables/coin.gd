extends StaticBody2D

@export var coin: InventoryItem
var player_in_area: bool = false

func _ready() -> void:
	if GameState.is_coin_collected(coin.item_id):
		queue_free()
		
func collect():
	print("Made it here ")
	#InventoryManager.add_item(coin)
	GameState.mark_coin_as_collected(coin.item_id)
	queue_free()
	

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if player_in_area && event.is_action_pressed("action"):
		collect()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = false
