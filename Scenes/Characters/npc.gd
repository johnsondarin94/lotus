extends CharacterBody2D

class_name NPCBase
@export var speed: int = 28
@onready var player = Global.get_player_reference()
@onready var _animated_sprite2d = $AnimatedSprite2D
@export var dialogue: DialogicTimeline
@export var custom_frames: SpriteFrames

var tilemap: TileMapLayer
var in_cutscene: bool = false
var player_in_area: bool = false
var is_moving: bool = false
var in_conversation: bool = false
var can_follow_player: bool = false
var actor_dist_threshold: float = 12.0
var can_move: bool = true
var move_self: bool = false

var cutscene_move_vector: Vector2

signal reached_target_vector
func _ready():
	if !dialogue:
		dialogue = preload("res://Dialogue/Dialogue/test_dialogue.dtl")
		
	if custom_frames:
		print("there are custom frames")
		_animated_sprite2d.frames = custom_frames
	add_to_group("target")
	
	Dialogic.timeline_started.connect(_on_dialogue_start)
	Dialogic.timeline_ended.connect(_on_dialogue_end)
	
func _input(event: InputEvent) -> void:
	if player_in_area && event.is_action_pressed("action"):
		if in_conversation:
			return	
			
		run_dialogue(dialogue)
		
func move_actor(move_vector: Vector2):
	in_cutscene = true
	move_self = true
	tilemap = get_tree().current_scene.get_child(1).get_node_or_null("TileMapLayer")
	cutscene_move_vector = tilemap.map_to_local(move_vector)
	print("Tilemap", tilemap)
	print(move_vector)
	#move_and_slide()
				
func _physics_process(_delta): 
	if in_cutscene:
		if move_self:
			var dir := cutscene_move_vector - global_position
			if dir.length() <= 1.0:
				global_position = cutscene_move_vector
				velocity = Vector2.ZERO
				move_self = false
				_animated_sprite2d.play("idle")
				emit_signal("reached_target_vector")
				return
			
			velocity = dir.normalized() * speed
			move_and_slide()
		_animated_sprite2d.play("walk")
		return
		
	if can_follow_player && !in_conversation:
		follow_actor(player)
		
	if !is_moving && !in_cutscene && velocity == Vector2.ZERO:
		_animated_sprite2d.play("idle")
	
	if is_moving:
		_animated_sprite2d.play("walk")
			
	if is_moving && !in_conversation && velocity == Vector2.ZERO:
		_animated_sprite2d.play("idle")		
		
func run_dialogue(dialogue_string):
	Dialogic.start(dialogue_string)
	
func follow_actor(actor: CharacterBody2D):
	is_moving = true 
	var dir: Vector2 = (actor.global_position - global_position)
	var distance = dir.length()
	if distance > actor_dist_threshold:
		_animated_sprite2d.flip_h = dir.x > 0
		velocity = dir.normalized() * speed
		move_and_slide()
	else: velocity = Vector2.ZERO
	
func _on_dialogue_start():
	in_conversation = true
	
func _on_dialogue_end():
	in_conversation = false
	
func lock_movement():
	can_move = false
	
func _on_player_detected_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		print("Player in area")
		player_in_area = true 

func _on_player_detected_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		print("Player NOT in area")
		player_in_area = false
