extends Node2D

@onready var initial_map_path = "res://Scenes/mystwood.tscn"
@onready var player_path = "res://Scenes/Characters/player.tscn"

@export var player_spawn_vector: Vector2 = Vector2(37, 38)

func _ready():
	# Load in and add map to Main 
	# Loads in before Player to give the player something to spawn into 
	var map = load(initial_map_path).instantiate()
	map.name = "Map"
	add_child(map)
	Global.set_current_map(map, initial_map_path)
	
	# Load in and add player to Main
	var player = load(player_path).instantiate()
	add_child(player)
	print(player)
	
	$UI._connect_player(player)
	
	if player:
		var tilemap = map.get_node_or_null("TileMapLayer")
		var world_pos = tilemap.map_to_local(player_spawn_vector)
		player.position = world_pos
		print(player.global_position)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if !GameState.is_game_paused:	
			GameState.pause_game()
			
		else:
			GameState.unpause_game()
