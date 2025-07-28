extends Object
class_name ItemBehaviors

static func use_flute(player: Node):
	var flute_scene = preload("res://Scenes/flute_play.tscn")
	var flute_instance = flute_scene.instantiate()
	var rotatable_degrees = [45.0, 135.0, 45.0, 135.0]
	
	var fireflies = player.get_tree().get_nodes_in_group("fireflies")
	var flute_spawn_direction = get_user_direction(player, flute_instance, rotatable_degrees)
	
	for f in fireflies:
		if f.get_state() == "FOLLOWING":
			f.glow()
	
	flute_instance.global_position = flute_spawn_direction
	player.get_tree().current_scene.add_child(flute_instance)

static func use_sword(user: CharacterBody2D):
	var rotatable_degrees = [45.0, 135.0, 45.0, 135.0]
	var sword_scene = preload("res://Scenes/Tools/sword_swing.tscn")
	var sword_swing = sword_scene.instantiate()
	
	var sword_swing_pos = get_user_direction(user, sword_swing, rotatable_degrees)
	sword_swing.global_position = sword_swing_pos
	
	user.get_tree().current_scene.add_child(sword_swing)
	
static func use_bow(user: CharacterBody2D):
	var rotatable_degrees = [-45.0, 225.0, -225.0, 45.0]
	var bow_fire_scene = preload("res://Scenes/bow_fire.tscn")
	var bow_fire = bow_fire_scene.instantiate()
	
	var bow_spawn_pos = get_user_direction(user, bow_fire, rotatable_degrees)
	bow_fire.global_position = bow_spawn_pos
	
	user.get_tree().current_scene.add_child(bow_fire)
	
static func get_user_direction(user: CharacterBody2D, weapon: Area2D, possible_rotations: Array) -> Vector2:
	var direction_vector: Vector2
	var spawn_pos: Vector2
	var direction: Vector2
	
	if user.has_method("player"):
		var mouse_world_pos: Vector2 = user.get_global_mouse_position()
		direction_vector = (mouse_world_pos - user.global_position).normalized()
		
	elif user.has_method("enemy"):
		var player = Global.get_player_reference()
		direction_vector = (player.global_position - user.global_position).normalized()
	
	if abs(direction_vector.x) > abs(direction_vector.y):
		direction = Vector2.RIGHT if direction_vector.x > 0 else Vector2.LEFT
		if direction == Vector2.RIGHT:
			weapon.rotation = deg_to_rad(possible_rotations[0]) * direction.x
		else: weapon.rotation = deg_to_rad(possible_rotations[1]) * direction.x
	else:
		direction = Vector2.DOWN if direction_vector.y > 0 else Vector2.UP
		if direction == Vector2.UP:
			weapon.rotation = deg_to_rad(possible_rotations[2]) * direction.y
		else: weapon.rotation = deg_to_rad(possible_rotations[3]) * direction.y
		
	weapon.direction = direction_vector
	
	var tile_size: int = 8
	var weapon_spawn_pos: Vector2 = user.global_position + direction  * tile_size 
	
	return weapon_spawn_pos
