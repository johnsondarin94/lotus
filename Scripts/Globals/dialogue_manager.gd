extends Node

signal dialogue_started
signal dialogue_ended

func _ready():
	Dialogic.timeline_started.connect(emit_start)
	Dialogic.timeline_ended.connect(emit_end)

func start_dialogue(timeline: String):
	if Dialogic.current_timeline:
		return # Or cancel current and replace it, if desired
	Dialogic.start(timeline)

func emit_start():
	emit_signal("dialogue_started")

func emit_end():
	emit_signal("dialogue_ended")
