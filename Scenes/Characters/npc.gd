extends CharacterBody2D

class_name NPCBase
@export var speed: int = 5

@onready var _animated_sprite2d = $AnimatedSprite2D

@export var dialogue: DialogicTimeline
@export var custom_frames: SpriteFrames


var player_in_area: bool = false
var is_moving: bool = false
var in_conversation: bool = false

@onready var player = Global.get_player_reference()

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
			
func _physics_process(_delta):
	if !is_moving:
		_animated_sprite2d.play("idle")
	
	if is_moving:
		_animated_sprite2d.play("walk")		
		
func run_dialogue(dialogue_string):
	Dialogic.start(dialogue_string)
	
func _on_dialogue_start():
	in_conversation = true
	
func _on_dialogue_end():
	in_conversation = false
		
func _on_player_detected_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		print("Player in area")
		player_in_area = true 

func _on_player_detected_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		print("Player NOT in area")
		player_in_area = false
