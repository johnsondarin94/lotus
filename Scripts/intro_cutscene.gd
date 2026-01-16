extends Node2D
@onready var fade_in = $ColorRect/AnimationPlayer
@onready var player = $Player

# Cutscenes are map specific, data for cutscenes is defined below


func _ready() -> void:
	if !WorldState.get_state_flag("i_cutscene_completed"):
		player.can_move = false
		Dialogic.signal_event.connect(_on_dialogic_signal)
		run_dialogue("intro_cutscene")
	else: 
		$VillageElder.queue_free()
		$Gravekeeper.queue_free()
		$Friend.queue_free()
		
func run_dialogue(dialogue: String):
	Dialogic.start(dialogue)

func _on_dialogic_signal(argument:String):
	if argument == "fade_in":
		fade_in.play("fade_in")
		
	if argument == "dialogue_ended":
		player.can_move = true
