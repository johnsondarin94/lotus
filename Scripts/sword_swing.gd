extends Area2D

@export var damage: int = 1

var is_swinging: bool = false
var direction: Vector2
var attack_type: String
var orbit_angle: float = PI
var orbit_speed: int = 8
var light_att_wait_time: float = 0.1
var heavy_att_wait_time: float = 1.0

var heavy_att_charged: bool = false

func _ready() -> void:
	add_to_group("sword_swing_instance")
	if attack_type == "LIGHT_ATTACK": $Timer.wait_time = light_att_wait_time
	if attack_type == "HEAVY_ATTACK": $Timer.wait_time = heavy_att_wait_time
	print($Timer.wait_time)

func _process(delta: float) -> void:
	swing()
	if attack_type == "HEAVY_ATTACK" && heavy_att_charged:
		if heavy_att_charged:
			damage = 2
			orbit_angle += 16 * delta
			rotation += 10 * delta
			global_position = get_parent().position + Vector2(0.0, 0.0).rotated(orbit_angle)
			
	
func swing() -> void:
	if !is_swinging:
		if attack_type == "LIGHT_ATTACK":
			$Timer.start()
		if attack_type == "HEAVY_ATTACK":
			#release_charge(delta)
			$HeavyAttackChargeTimer.start()
	if is_swinging:
		return
	is_swinging = true
	
func _on_timer_timeout() -> void:
	damage = 1
	queue_free()
	is_swinging = false

func _on_body_entered(body) -> void:
	if body.is_in_group("target"):
		body.take_damage(damage, direction)
		

func _on_heavy_attack_timer_timeout() -> void:
	is_swinging = false
	heavy_att_charged = false
	queue_free()
	
func _on_heavy_attack_charge_timer_timeout() -> void:
	if !heavy_att_charged:
		$HeavyAttackTimer.start()
		heavy_att_charged = true
