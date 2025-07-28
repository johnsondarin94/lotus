extends Node

	
var is_game_paused: bool = false

func pause_game():
	is_game_paused = true
	get_tree().paused = true
	
func unpause_game():
	is_game_paused = false
	get_tree().paused = false
	
