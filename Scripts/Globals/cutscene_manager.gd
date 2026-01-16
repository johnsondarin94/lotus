extends Node

var is_playing: bool = false

signal cutscene_started(id)
signal cutscene_finished(id)

func start_cutscene(id: String, steps: Array) -> void:
	if is_playing:
		return
		
	is_playing = true
	emit_signal("cutscene_started", id)
	for step in steps:
		await _run_steps(step)
		
	is_playing = false
	emit_signal("cutscene_finished", id)
	
func _run_steps(step: Dictionary) -> void:
	match step.type:
		"lock_movement":
			var actor: CharacterBody2D = get_tree().current_scene.get_node_or_null(step.path)
			actor.lock_movement()
			actor.in_cutscene = true
		"unlock_movement":
			var actor: CharacterBody2D = get_tree().current_scene.get_node_or_null(step.path)
			actor.unlock_movement()
		"move_actor":
			var actor: CharacterBody2D = get_tree().current_scene.get_child(1).get_node_or_null(step.path)
			if step.wait:
				actor.move_actor(step.move_to)
				await actor.reached_target_vector
				return
			actor.move_actor(step.move_to)
		"animation":
			var node: AnimationPlayer = get_tree().current_scene.get_node_or_null(step.path)
			if step.wait:
				if step.reverse:
					node.play_backwards(step.anim)
					await node.animation_finished
					return
				node.play(step.anim)
				await node.animation_finished
				
			if !step.wait:
				if step.reverse:
					node.play_backwards(step.anim)
				node.play(step.anim)
			
		"dialogue":
			var timeline: DialogicTimeline = load(step.timeline)
			if step.wait:
				Dialogic.start(timeline)
				await Dialogic.timeline_ended
			if !step.wait:
				Dialogic.start(timeline)
