extends StaticBody2D

@export var dialogue_id: String
@export var item_pickup: InventoryItem

var player_in_area: bool = false

func _ready() -> void:
	add_to_group("path_blockers")
	
	if item_pickup:
		if WorldState.is_item_collected(item_pickup.item_id):
			queue_free()

func collect(inventory: Inventory):
	if item_pickup.item_consumable:
		var player = Global.get_player_reference()
		item_pickup.on_use(player)
		queue_free()
		return
		
	inventory.add_item(item_pickup)
	WorldState.mark_item_as_collected(item_pickup.item_id)
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method('player'):
		print("player in area")
		player_in_area = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method('player'):
		print("Player out of Area")
		player_in_area = false 

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if player_in_area && event.is_action_pressed("action"):
		var player = Global.get_player_reference()
		if item_pickup:
			Dialogic.VAR.set('item_name', item_pickup.item_name)
			Dialogic.start("item_pickup")
			
			collect(player.get_inventory())
		
		if dialogue_id:
			Dialogic.start(dialogue_id)
