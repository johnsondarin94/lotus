extends StaticBody2D

@export var grave_dialogue: DialogicTimeline

var player_in_area: bool = false

func run_dialogue(dialogue_string):
	Dialogic.start(dialogue_string)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = false

func _input(event: InputEvent) -> void:
	if player_in_area && event.is_action_pressed("action"):
		run_dialogue(grave_dialogue)
