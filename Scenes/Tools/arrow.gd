extends Area2D

@export var damage: int = 1
@export var speed: int = 100

var direction: Vector2
var velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	add_to_group("projectile")
	velocity = direction.normalized() * speed
	
func _on_lifetime_timeout() -> void:
	print("DELETED")
	queue_free()

func _process(delta: float) -> void:
	position += velocity * delta
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("target"):
		body.take_damage(damage, direction)
		queue_free()
		
	if body.is_in_group("sword_swing_instance"):
		print("Hit Arrow")
		queue_free()
		
func _on_body_shape_entered(_body_rid: RID, _body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	queue_free()
	
