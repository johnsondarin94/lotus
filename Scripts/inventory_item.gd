extends Resource
class_name InventoryItem

@export var item_id: String = ""
@export var item_name: String = ""
@export var item_description: String = ""
@export var item_icon: Texture2D = null
@export var item_stackable: bool = false
@export var item_consumable: bool = false
@export var item_equipable: bool = false
@export var behavior_method: String = ""

var behavior_script: Script = preload("res://Scripts/item_behaviors/item_behaviors.gd")

func on_use(user_node: Node, optional_param = null) -> void:
	if behavior_script.has_method(behavior_method):
		behavior_script.call(behavior_method, user_node, optional_param)
	else:
		print("METHOD NOT FOUND:", behavior_method)
