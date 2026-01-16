extends Area2D

@export var light_damage: int = 1
@export var heavy_damage: int = 3
@export var charge_threshold: float = 1.0  # seconds
@export var light_duration: float = 0.15
@export var heavy_duration: float = 0.8
@export var orbit_speed: float = 10.0

var is_charging: bool = false
var is_released: bool = false
var is_heavy: bool = false
var charge_time: float = 0.0
var orbit_angle: float = 0.0
var direction: Vector2

func _ready():
	add_to_group("sword_swing_instance")

func start_charge():
	is_charging = true
	set_process(true)

func release_attack():
	is_released = true
	is_charging = false

	if charge_time >= charge_threshold:
		is_heavy = true
		$Timer.wait_time = heavy_duration
	else:
		is_heavy = false
		$Timer.wait_time = light_duration

	$Timer.start()

func _process(delta):
	if is_charging:
		charge_time += delta
		modulate = Color(1, 1 - (charge_time / charge_threshold) * 0.3, 1)  # visual feedback
		#rotation += delta * 3  # slight idle rotation
	elif is_released:
		if is_heavy:
			orbit_angle += orbit_speed * delta
			rotation += 6 * delta
			global_position = get_parent().position + Vector2(12, 0).rotated(orbit_angle)

func _on_body_entered(body):
	if body.is_in_group("target"):
		
		var dmg = heavy_damage if is_heavy else light_damage
		body.take_damage(dmg, direction)

func _on_timer_timeout():
	queue_free()
