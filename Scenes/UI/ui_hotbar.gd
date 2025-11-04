extends Control

@onready var equipped_item = $EquippedItem/Slot/Item

var player = Global.get_player_reference()

func _ready() -> void:
	player.equipped_item_changed.connect(_on_player_equipment_changed)

func _on_player_equipment_changed(new_item):
	equipped_item.texture = new_item.item_icon
	print(new_item.item_icon)
