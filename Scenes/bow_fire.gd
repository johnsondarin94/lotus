extends Node2D

var direction: Vector2



func _ready() -> void:
	var arrow_scene = preload("res://Scenes/Tools/arrow.tscn")
	var arrow_instance = arrow_scene.instantiate()

	# Get the raw fire direction (usually normalized)
	var dir: Vector2 = get_bow_fire_direction().normalized()

	# Quantize the direction to 8 sectors (every 45°)
	var angle_deg: float = rad_to_deg(dir.angle())
	var sector: int = int(round(angle_deg / 45.0)) % 8

	# Define the 8 possible direction vectors
	var directions = [
		Vector2.RIGHT,                           # 0°  (East)
		Vector2(1, 1).normalized(),              # 45° (Southeast)
		Vector2.DOWN,                            # 90° (South)
		Vector2(-1, 1).normalized(),             # 135° (Southwest)
		Vector2.LEFT,                            # 180° (West)
		Vector2(-1, -1).normalized(),            # 225° (Northwest)
		Vector2.UP,                              # 270° (North)
		Vector2(1, -1).normalized()              # 315° (Northeast)
	]

	# Define corresponding rotations (in degrees)
	# Adjust if your arrow sprite faces a different default direction
	var possible_rotations = [0, 45, 90, 135, 180, 225, 270, 315]

	# Assign direction and rotation based on sector
	arrow_instance.direction = directions[sector]
	arrow_instance.rotation = deg_to_rad(possible_rotations[sector] + 45)

	# Spawn the arrow in the world
	arrow_instance.global_position = global_position

	# Add it to the current scene
	var player = Global.get_player_reference()
	player.get_tree().current_scene.add_child(arrow_instance)


func _on_lifetime_timeout() -> void:
	queue_free()
	

func get_bow_fire_direction() -> Vector2:
	return direction
