extends Node
# The i that prepends the state string stands for intro
var opened_chests: Dictionary = {}
var chest_contents: Dictionary = {}
var collected_items: Dictionary = {}

var state_flags: Dictionary[String, bool] = {
	"i_forest_escape_completed": false, 
	"i_cutscene_completed": false,
	"i_speak_with_child": false, 
}

func set_state_flags(flag: String, result: bool):
	state_flags[flag] = result

func get_state_flag(key: String) -> bool:
	return state_flags.get(key, false)
	
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
