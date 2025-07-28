extends Node

var opened_chests: Dictionary = {}
var chest_contents: Dictionary = {}
var collected_items: Dictionary = {}

var first_conversation: bool = false
var conversations_had: Dictionary = {"Character": [["conversation_id", "conversation_id1"], "requirements"]
}

func mark_item_as_collected(item_id):
	collected_items[item_id] = true
	
func is_item_collected(item_id):
	return collected_items.get(item_id, false)

func mark_chest_as_open(chest_id, contents):
	opened_chests[chest_id] = true
	chest_contents[chest_id] = contents 
	
func is_chest_open(chest_id):
	return opened_chests.get(chest_id, false)
	
func get_chest_contents(chest_id):
	return chest_contents.get(chest_id, [])
