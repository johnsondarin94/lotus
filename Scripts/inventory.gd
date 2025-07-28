extends Node
class_name Inventory

var inventory: Array[InventoryItem] = []
var equipped_item: InventoryItem

func get_inventory() -> Array[InventoryItem]:
	return inventory

func set_inventory(updated_inventory) -> void:
	inventory = updated_inventory

func add_item(item: InventoryItem) -> void:
	inventory.append(item)
	print("Added item to inventory!")
	print(inventory)
	
func remove_item(item_id: String) -> void:
	var new_inventory = []
	for i in inventory:
		if i.id != item_id:
			new_inventory.append(i)
	set_inventory(new_inventory)

func equip_item(item_name: String) -> InventoryItem:
	for i in inventory:
		if i.item_name == item_name:
			equipped_item = i
			
	return equipped_item

func item_in_inventory(item_name: String) -> bool:
	if inventory == null:
		return false
	for item in inventory:
		if item.item_name == item_name:
			return true
	return false
