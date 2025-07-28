extends Node

var player: Node
var current_map_node: Node = null
var current_map_path: String = ""

signal player_loaded(player)

func set_player_reference(p: Node):
	player = p

func get_player_reference():
	return player
	
func set_current_map(map_node: Node, path: String):
	current_map_node = map_node
	current_map_path = path
	
func get_current_map() -> Node:
	return current_map_node

func get_current_map_path() -> String:
	return current_map_path
	
func change_map(map_path: String, spawn_vector: Vector2):
	var main = get_tree().get_root().get_node("Main")
	
	if current_map_node and is_instance_valid(current_map_node):
		current_map_node.queue_free()
	
	var new_map = load(map_path).instantiate()
	new_map.name = "Map"
	main.add_child(new_map)
	set_current_map(new_map, map_path)
	
	if player:
		if player.get_parent():
			player.get_parent().remove_child(player)
			
		new_map.add_child(player)
		
		var tilemap = new_map.get_node_or_null("TileMapLayer")
		if tilemap:
			var world_pos = tilemap.map_to_local(spawn_vector)
			player.global_position = world_pos
			
		emit_signal("player_loaded", player)
		
		print(player.global_position)
		
