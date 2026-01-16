extends Node2D

@export var dialogue: DialogicTimeline
@onready var fade_in = $ColorRect/AnimationPlayer

const CUTSCENES: Dictionary = {
	"speak_with_farryn":[
		#{"type": "animation", "path": "Map/ColorRect/AnimationPlayer", "anim": "fade_in", "reverse": false, "wait": true},
		{"type": "dialogue", "timeline": "res://Dialogue/Dialogue/Intro/Forest_Escape_MystwoodEntrance.dtl", "wait": false}
	]
}



func _ready() -> void:
	await get_tree().process_frame
	if !WorldState.get_state_flag("i_forest_escape"):
		CutsceneManager.start_cutscene("speak_with_farryn", CUTSCENES["speak_with_farryn"])
		WorldState.set_state_flags("i_forest_escape", true)
		$Friend.can_follow_player = true
	else:
		$ColorRect.hide()
		$Friend.queue_free()
