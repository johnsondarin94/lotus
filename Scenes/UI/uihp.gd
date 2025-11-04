extends Control

@export var heart_scene1: PackedScene

@onready var heart_full_texture = $HeartFull/Slot/Texture
@onready var heart_empty_texture = $HeartEmpty/Slot/Texture

var player = Global.get_player_reference()
var max_hp = player.get_player_max_hp()

var heart_spacing: int = 55
var heart_array: Array = []

#func _connect_player(player_instance):
	#player_instance.hp_changed.connect(_on_player_hp_changed)
	
	
func _ready() -> void:
	generate_hearts(max_hp)
	player.hp_changed.connect(_on_player_hp_changed)
	
func generate_hearts(amount: int) -> void:
	print(amount)
	var heart_spawn_vector: Vector2 = Vector2(0,0)
	for i in range(amount):
		var heart = heart_scene1.instantiate()
		heart_spawn_vector.x = heart_spawn_vector.x + heart_spacing
		heart.position = heart_spawn_vector
		add_child(heart)
		
		var tex_rect = heart.get_node("Slot/Texture")
		heart_array.append(tex_rect)

func _on_player_hp_changed(hp):
	#var current_hp = player.get_player_hp()
	
	for i in range(max_hp):
		if i < hp:
			heart_array[i].texture = heart_full_texture.texture
		else:
			heart_array[i].texture = heart_empty_texture.texture
