extends Node2D


func _ready() -> void: 
	await get_tree().process_frame
	$Friend.can_follow_player = true
	$Friend.follow_actor(Global.get_player_reference())
