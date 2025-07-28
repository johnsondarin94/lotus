extends Node2D

@export var SPEED: float = 0.1
@export var DEFAULT_TEXTURE_SCALE: float = 2.0
@export var DEFAULT_ENERGY: float = 1.0
@export var MAX_TEXTURE_SCALE: float = 4.0
@export var MAX_ENERGY: float = 2.5

enum FireflyState {IDLE, FOLLOWING, CHARGING, DIE}

var player_detected: bool = false
var current_state: FireflyState = FireflyState.IDLE
var target_position: Vector2
var glow_tween: Tween
var is_glowing: bool = false
var health_points: int = 3


func _ready():
	add_to_group("fireflies")
	$Timer.set_wait_time(randf_range(2.0, 5.0))
	$Timer.start()
	current_state = FireflyState.IDLE
	
func _process(_delta: float) -> void:
	match current_state:
		FireflyState.IDLE:
			idle()
		FireflyState.FOLLOWING:
			if player_detected:
				chase_player()
		FireflyState.DIE:
			die()
		
func get_state():
	return FireflyState.keys()[current_state]
	
func chase_player():
	if not player_detected:
		return
		
	global_position = global_position.move_toward(Global.get_player_reference().global_position, SPEED)

func idle():
	pass
	
func die():
	var audio = get_parent().get_node("AudioStreamPlayer2D")
	if audio:
		audio.playing = false
	queue_free()
	
func change_state(new_state: FireflyState):
	current_state = new_state
	
func glow() -> void:
	if is_glowing:
		return
	is_glowing = true
	glow_up()
	
func glow_up():
	$LightBurstTimer.start()
	glow_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	glow_tween.parallel().tween_property($PointLight2D, "energy", MAX_ENERGY, 0.2)
	glow_tween.parallel().tween_property($PointLight2D, "texture_scale", MAX_TEXTURE_SCALE, 0.2)
	
func glow_down():
	glow_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	glow_tween.parallel().tween_property($PointLight2D, "energy", DEFAULT_ENERGY, 1.0)
	glow_tween.parallel().tween_property($PointLight2D, "texture_scale", DEFAULT_TEXTURE_SCALE, 1.0)
	glow_tween.connect("finished", _on_glow_tween_finished)
	

func _on_glow_tween_finished():
	health_points = health_points - 1
	is_glowing = false
	$LightBurstTimer.stop()
	
func _on_light_burst_timer_timeout() -> void:
	if health_points <= 0:
		change_state(FireflyState.DIE)
	else:
		glow_down()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_detected = true
		print("Player Detected")
		change_state(FireflyState.FOLLOWING)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_detected = false
		change_state(FireflyState.IDLE)
