extends Object
class_name ItemBehaviors

static var active_sword: Node = null

static func use_flute(player: Node, _optional_param):
	var flute_scene = preload("res://Scenes/Attacks/flute_play.tscn")
	var flute_instance = flute_scene.instantiate()
	var sprite_adjustment: float = 45.0
	
	var fireflies = player.get_tree().get_nodes_in_group("fireflies")
	var flute_spawn_direction = get_user_direction(player, flute_instance, sprite_adjustment)
	
	for f in fireflies:
		if f.get_state() == "FOLLOWING":
			f.glow()
	
	flute_instance.global_position = flute_spawn_direction
	player.get_tree().current_scene.add_child(flute_instance)

static func use_sword(user: CharacterBody2D, attack_type):
	var sprite_adjustment: float = 45.0

	if attack_type == "START_ATTACK":
		var sword_scene = preload("res://Scenes/Attacks/sword_swing.tscn")
		var sword_swing = sword_scene.instantiate()
		var sword_swing_pos = get_user_direction(user, sword_swing, sprite_adjustment)
		user.add_child(sword_swing)
		sword_swing.position = user.to_local(sword_swing_pos)
		sword_swing.start_charge()
		active_sword = sword_swing

	elif attack_type == "RELEASE_ATTACK" and active_sword and active_sword.is_inside_tree():
		active_sword.release_attack()
		active_sword = null
	
static func use_bow(user: CharacterBody2D, attack_type):
	var sprite_adjustment: float = -45.0
	var bow_fire_scene = preload("res://Scenes/Attacks/bow_fire.tscn")
	var bow_fire = bow_fire_scene.instantiate()
	
	var bow_spawn_pos = get_user_direction(user, bow_fire, sprite_adjustment)
	bow_fire.attack_type = attack_type
	bow_fire.global_position = bow_spawn_pos
	
	user.get_tree().current_scene.add_child(bow_fire)
	
static func use_dagger(user: CharacterBody2D, attack_type):
	var sprite_adjustment: float = 45.0
	var dagger_scene = preload("res://Scenes/Attacks/dagger_stab.tscn")
	if attack_type == "STAB":
		var dagger_stab = dagger_scene.instantiate()
		var dagger_stab_pos = get_user_direction(user, dagger_stab, sprite_adjustment)
		user.add_child(dagger_stab)
		dagger_stab.position = user.to_local(dagger_stab_pos)
	if attack_type == "DASH_ATTACK":
		for i in range(3):
			var dagger_stab_rapid = dagger_scene.instantiate()
			var dagger_stab_pos = get_user_direction(user, dagger_stab_rapid, sprite_adjustment)
			user.add_child(dagger_stab_rapid)
			dagger_stab_rapid.position = user.to_local(dagger_stab_pos)
			
	
static func use_potion(user: CharacterBody2D):
	var current_hp: int = user.get_player_hp()
	var max_hp: int = user.get_player_max_hp()
	var amount: int = 1
	if current_hp >= max_hp:
		print("HP ALREADY FULL")
		return
	user.gain_hp(amount)
	print(current_hp)
	
static func get_user_direction(user: CharacterBody2D, weapon: Area2D, adjustment: float) -> Vector2:
	var direction_vector: Vector2
	#var spawn_pos: Vector2

	if user.has_method("player"):
		var mouse_world_pos: Vector2 = user.get_global_mouse_position()
		direction_vector = (mouse_world_pos - user.global_position).normalized()
		
	elif user.has_method("enemy"):
		var player = Global.get_player_reference()
		direction_vector = (player.global_position - user.global_position).normalized()
	
	# Get angle in radians
	var angle = direction_vector.angle()
	var sector = int(round(rad_to_deg(angle) / 45.0)) % 8

	# Match sector to direction vectors
	var directions = [
		Vector2.RIGHT,                           # 0° (East)
		Vector2(1, 1).normalized(),              # 45° (Southeast)
		Vector2.DOWN,                            # 90° (South)
		Vector2(-1, 1).normalized(),             # 135° (Southwest)
		Vector2.LEFT,                            # 180° (West)
		Vector2(-1, -1).normalized(),            # 225° (Northwest)
		Vector2.UP,                              # 270° (North)
		Vector2(1, -1).normalized()              # 315° (Northeast)
	]

	var direction = directions[sector]
	weapon.rotation = angle + adjustment
	weapon.direction = direction_vector

	# Offset weapon position based on chosen direction
	var tile_size: int = 8
	var weapon_spawn_pos: Vector2 = user.global_position + direction * tile_size
	
	return weapon_spawn_pos
