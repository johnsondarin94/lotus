extends Area2D

@export var damage: int = 1

var is_swinging: bool = false
var direction: Vector2

func _ready() -> void:
	add_to_group("sword_swing_instance")
	swing()
	#animate_sword()
	
func swing() -> void:
	if is_swinging:
		return
	is_swinging = true
	
func _on_timer_timeout() -> void:
	queue_free()

func _on_body_entered(body) -> void:
	if body.is_in_group("target"):
		body.take_damage(damage, direction)
		
	
func animate_sword():
	#var tween = get_tree().create_tween()
	#tween.tween_property($Sprite2D, "position", Vector2(5.0, 0), 0.5)
	pass
	

	
