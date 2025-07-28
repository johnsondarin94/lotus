extends CanvasLayer

@onready var equipped_item = $UIHotbar/EquippedItem/Slot/Item
@onready var item = $UIHotbar/Item/Slot/Item

func _connect_player(player):
	player.equipped_item_changed.connect(_on_player_equipment_changed)

func _on_player_equipment_changed(item):
	print("triggered")
	equipped_item.texture = item.item_icon
	print(item.item_icon)
