extends StaticBody2D

@export var contents: Array[InventoryItem]

@onready var sprite: Sprite2D = $Sprite2D
@export var chest_id: String

const OPEN_CHEST_SPRITE = preload("res://Assets/chest_open.png")

var player_in_area: bool = false
var is_open: bool = false

func _ready():
	if WorldState.is_chest_open(chest_id):
		sprite.texture = OPEN_CHEST_SPRITE
		is_open = true
		contents = WorldState.get_chest_contents(chest_id)
		open_chest()
		
func open_chest():
	var events : Array = []
	var timeline : DialogicTimeline = DialogicTimeline.new()
	
	if !is_open:
		var te_open_chest = DialogicTextEvent.new()
		te_open_chest.text = "Received item: " + contents[0].item_name
		events.append(te_open_chest)
		var player = Global.get_player_reference()
		var player_inventory = player.get_inventory()
	
		for item in contents:
			player_inventory.add_item(item)
		contents = []
		sprite.texture = OPEN_CHEST_SPRITE
		is_open = true 
		WorldState.mark_chest_as_open(chest_id, contents)
		
	else: 
		var te_empty_chest = DialogicTextEvent.new()
		te_empty_chest.text = "Empty..."
		events.append(te_empty_chest)
	
	timeline.events = events
	timeline.events_processed = true
	Dialogic.start(timeline)
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = true
	
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = false
		
func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if player_in_area and event.is_action_pressed("action"):
		open_chest()
