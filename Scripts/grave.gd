extends StaticBody2D

@export var grave_id: String 

var player_in_area: bool = false

func run_dialogue(dialogue_string):
	Dialogic.start(dialogue_string)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = false

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("action") and player_in_area:
		print("Test")
		run_dialogue(grave_id + "_dialogue")
