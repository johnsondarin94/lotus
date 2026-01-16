extends StaticBody2D

@export var dialogue_id: String
@export var item_pickup: InventoryItem

var player_in_area: bool = false

func _ready() -> void:
	add_to_group("path_blockers")
	
	if item_pickup and WorldState.is_item_collected(item_pickup.item_id):
		queue_free()

# Called when the player enters the interaction area
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method('player'):
		print("Player in area ✅")
		player_in_area = true

# Called when the player leaves the interaction area
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method('player'):
		print("Player out of area ❌")
		player_in_area = false

# Called for all input events (keyboard included)
func _input(event: InputEvent) -> void:
	if player_in_area and event.is_action_pressed("action"):
		interact()

# Handles interaction logic
func interact() -> void:
	var player = Global.get_player_reference()
	
	if item_pickup:
		Dialogic.VAR.set('item_name', item_pickup.item_name)
		Dialogic.start("item_pickup")
		collect(player.get_inventory())
	elif dialogue_id:
		Dialogic.start(dialogue_id)

# Collects the item and updates world state
func collect(inventory: Inventory) -> void:
	if item_pickup.item_consumable:
		var player = Global.get_player_reference()
		item_pickup.on_use(player)
		queue_free()
		return
		
	inventory.add_item(item_pickup)
	WorldState.mark_item_as_collected(item_pickup.item_id)
	queue_free()
