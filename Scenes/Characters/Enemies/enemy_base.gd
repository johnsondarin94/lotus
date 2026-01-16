extends NPCBase

class_name EnemyBase

enum EnemyState {IDLE, WANDERING, PURSUE, ATTACKING, KNOCKED_BACK, DIE}
enum EnemyAttackStyle {CLOSE, RANGED}


@export var health_points: int
@export var knockback_velocity: Vector2
@export var knockback_direction: Vector2
@export var knockback_strength: float = 100.00
@export var knockback_distance: float
@export var can_wander: bool = true
@export var wandering_range: float

var attack_style: EnemyAttackStyle
var current_state: EnemyState = EnemyState.WANDERING
var inventory: Inventory = Inventory.new()
var target_pos: Vector2
var player_detected: bool = false
var is_knocked_back: bool = false
var active_animation: String

var sword_swing_direction: Vector2


const ONE_TILE: float = 8.0

func _ready():
	super._ready()

func _physics_process(delta):
	super._physics_process(delta)
	
	if is_knocked_back:
		$AnimatedSprite2D.play("knockback")
		velocity = knockback_velocity
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, 100 * delta)
		if knockback_velocity.length() < 1.0:
			is_knocked_back = false
		move_and_slide()
		return
		
	match current_state:
			EnemyState.IDLE:
				_idle()
			EnemyState.WANDERING:
				_wandering()
			EnemyState.PURSUE:
				_pursue()
			EnemyState.ATTACKING:
				_attack()
			#EnemyState.KNOCKED_BACK:
				#_knockback(sword_swing_direction)
			EnemyState.DIE:
				_die()
	#print(current_state)
func change_state(new_state: EnemyState) -> void:
	current_state = new_state
	print("State Changed: ", current_state)

func set_attack_style(style: EnemyAttackStyle):
	attack_style = style

func set_active_animation(animation_name: String):
	if active_animation == animation_name:
		return
	active_animation = animation_name
	$AnimatedSprite2D.play(animation_name)		
	
func _idle():
	pass

func take_damage(hit_points: int, new_sword_swing_direction: Vector2):
	health_points -= hit_points
	sword_swing_direction = new_sword_swing_direction
	change_state(EnemyState.KNOCKED_BACK)
	_knockback(sword_swing_direction)
	if health_points <= 0:
		change_state(EnemyState.DIE)
		
func _wandering():
	#$AnimatedSprite2D.play("walk")
	if target_pos == Vector2.ZERO:	
		pick_new_path()
		
	if target_pos != Vector2.ZERO:
		if global_position.distance_to(target_pos) >= 1.0:
			var dir: Vector2 = (target_pos - global_position).normalized() * ONE_TILE
			velocity = dir * speed
			is_moving = true
			move_and_slide()
		else:
			target_pos = Vector2.ZERO
			#print("Target_Pos is 0!")
			
func _pursue():
	is_moving = true
	#$AnimatedSprite2D.play("walk")
	var dir: Vector2 = (player.global_position - global_position).normalized()
	velocity = dir * speed * ONE_TILE
	move_and_slide()
	
func _attack():
	pass
	
func _die():
	print("Enemy is DYING")
	self.queue_free()

func pick_new_path():
	if current_state == EnemyState.WANDERING:
		var x: float = randf_range(-wandering_range, wandering_range)
		var y: float = randf_range(-wandering_range, wandering_range)
		
		var new_target_pos: Vector2 = Vector2(x,y)
		
		target_pos = global_position + new_target_pos

func _on_knockback_cooldown_timer_timeout() -> void:
	is_knocked_back = false

func _knockback(sword_swing_direction: Vector2) -> void:
	is_knocked_back = true
	knockback_velocity = sword_swing_direction.normalized() * knockback_strength
	
func _on_wander_cooldown_timer_timeout() -> void:
	pick_new_path()
	_wandering()
	
func _on_detect_player_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_detected = true
		change_state(EnemyState.PURSUE)

func _on_detect_player_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_detected = false
		is_moving = false
		change_state(EnemyState.WANDERING)
		
func enemy():
	pass
