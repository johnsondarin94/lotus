extends Node2D
@onready var fade_in = $ColorRect/AnimationPlayer
@onready var player = $Player

func _ready() -> void:
	
	player.can_move = false
	Dialogic.signal_event.connect(_on_dialogic_signal)
	run_dialogue()

func run_dialogue():
	Dialogic.start("intro_cutscene")

func _on_dialogic_signal(argument:String):
	if argument == "fade_in":
		fade_in.play("fade_in")
		
	if argument == "dialogue_ended":
		player.can_move = true
