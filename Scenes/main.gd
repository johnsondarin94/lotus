extends Node2D

@onready var initial_map_path = "res://Scenes/Map/parallax_forest.tscn"
@onready var ui_path = "res://Scenes/UI/ui.tscn"
@onready var player_path = "res://Scenes/Characters/player.tscn"

@export var player_spawn_vector: Vector2

func _ready():
	
	# Load in and add map to Main 
	# Loads in before Player to give the player something to spawn into 
	print(initial_map_path)
	var map = load(initial_map_path).instantiate()
	map.name = "Map"
	add_child(map)
	Global.set_current_map(map, initial_map_path)
	
	# Load in and add player to Main
	var player = load(player_path).instantiate()
	add_child(player)
	
	var ui = load(ui_path).instantiate()
	add_child(ui)
	
	#await get_tree().process_frame
	
	if !WorldState.get_state_flag("i_forest_escape_completed"):
		map.start_cutscene()
	
	#if OS.get_name() == "Android" || OS.get_name() == "iOS":
		#add_child(ui_mobile)
		#print("hello")
	
	if player:
		var tilemap = map.get_node_or_null("TileMapLayer")
		if !tilemap:
			if map.has_method("get_player_spawn_vector"):
				player_spawn_vector = map.get_player_spawn_vector()
				player.position = player_spawn_vector
			#ui.hide()
			return
		var world_pos = tilemap.map_to_local(player_spawn_vector)
		player.position = world_pos
		print(player.global_position)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if !GameState.is_game_paused:	
			GameState.pause_game()
			
		else:
			GameState.unpause_game()
