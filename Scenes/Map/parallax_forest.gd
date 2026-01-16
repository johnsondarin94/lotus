extends Node2D

@onready var fade_in = $ColorRect/AnimationPlayer

@export var scroll_speed := 60.0
@export var chunk_height := 80
@export var dialogue: DialogicTimeline
var chunks: Array[Node2D] = []

const CUTSCENES: Dictionary = {
	"forest_escape": [
		{"type": "lock_movement", "path": "Player",  "set_anim": "walk"},
		{"type": "lock_movement", "path": "Map/Friend",  "set_anim": "walk"},
		{"type": "dialogue", "timeline": "res://Dialogue/Dialogue/Intro/Run.dtl","wait": true},
		{"type": "animation", "path": "Map/ColorRect/AnimationPlayer", "anim": "fade_in", "reverse": false, "wait": false},
		{"type": "dialogue", "timeline": "res://Dialogue/Dialogue/Intro/Forest Escape.dtl", "wait": true},
		{"type": "animation", "path": "Map/ColorRect/AnimationPlayer", "anim": "fade_in", "reverse": true, "wait": true},
		{"type": "unlock_movement", "path": "Player",  "set_anim": "idle"},
	]
}

func _ready():
	#$Player.can_move = false
	#$Player.in_intro_cutscene = true
	#$Friend.is_moving = true
	
	for child in get_children():
		if child.name.begins_with("ParallaxForest_Chunk"):
			chunks.append(child)

	# Sort chunks by Y so ordering is correct
	chunks.sort_custom(func(a, b): return a.position.y < b.position.y)
	
	if !dialogue:
		dialogue = preload("res://Dialogue/Dialogue/test_dialogue.dtl")
	
func start_cutscene() -> void:
	#var fade_in = $ColorRect/AnimationPlayer
	await CutsceneManager.start_cutscene("forest_escape", CUTSCENES["forest_escape"])
	WorldState.set_state_flags("i_forest_escape_completed", true)
	Global.change_map("res://Scenes/Map/forest_entrance_b.tscn", Vector2(19, 18))
	#Dialogic.start(dialogue)
	#Dialogic.signal_event.connect(_on_dialogue_signal)
	#Dialogic.timeline_ended.connect(_on_dialogue_finished)

#func _on_dialogue_signal(argument: String):
	#if argument == "fade_in":
		#fade_in.play("fade_in")
		
#func _on_dialogue_finished():
	#fade_in.play_backwards("fade_in")
	#await fade_in.animation_finished
	
	
func _process(delta):
	#if !WorldState.get_state_flag("i_forest_escape_completed"):
		#start_cutscene()
	_scroll_chunks(delta)
	_recycle_chunks()

#func _physics_process(_delta: float) -> void:
	#$Player/AnimatedSprite2D.play("walk")
	
func _scroll_chunks(delta):
	for chunk in chunks:
		chunk.position.y += scroll_speed * delta

func _recycle_chunks():
	var camera = get_tree().current_scene.get_node("Player")
	if camera:
		var camera_y: float = camera.global_position.y
		for chunk in chunks:
		# If chunk is fully below the camera
			if chunk.global_position.y >= camera_y + chunk_height:
				_move_chunk_to_top(chunk)
	else:
		return
func get_player_spawn_vector():
	return Vector2(87.0, 120.0)
	
func _move_chunk_to_top(chunk: Node2D):
	# Find the highest chunk
	var highest_y := chunk.position.y
	for c in chunks:
		if c.position.y < highest_y:
			highest_y = c.position.y

	# Move recycled chunk above the highest one
	chunk.position.y = highest_y - chunk_height
