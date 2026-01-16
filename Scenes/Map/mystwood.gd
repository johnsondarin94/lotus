extends Node2D

var cutscene_dialogue: DialogicTimeline
#var tilemap = 

const CUTSCENES: Dictionary = {
	"speak_with_child":[
		#{"type": "lock_movement", "path": "Player",  "set_anim": "idle"},
		{"type": "move_actor", "path": "Sister", "move_to": Vector2(60,22), "wait": true},
		{"type": "dialogue", "timeline": "res://Dialogue/Dialogue/Sister/s_d00.dtl", "wait": true}
		
	]
}
func _ready() -> void:
	await get_tree().process_frame
	
	if !WorldState.get_state_flag("i_speak_with_child"):
		CutsceneManager.start_cutscene("speak_with_child", CUTSCENES["speak_with_child"])
	
