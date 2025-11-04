extends NPCBase

class_name EnemyBase

enum EnemyState {IDLE, WANDERING, PURSUE, ATTACKING, KNOCKED_BACK, DIE}
enum EnemyAttackStyle {CLOSE, RANGED}


@export var health_points: int
@export var knockback_velocity: Vector2
@export var knockback_direction: Vector2
@export var knockback_strength: float
@export var knockback_distance: float
@export var can_wander: bool = true
@export var wandering_range: float

var attack_style: EnemyAttackStyle
var current_state: EnemyState = EnemyState.WANDERING
var inventory: Inventory = Inventory.new()
var target_pos: Vector2
var player_detected: bool = false



const ONE_TILE: float = 8.0

func _ready():
	super._ready()

func _physics_process(_delta):
	super._physics_process(_delta)

	match current_state:
			EnemyState.IDLE:
				_idle()
			EnemyState.WANDERING:
				_wandering()
			EnemyState.PURSUE:
				_pursue()
			EnemyState.ATTACKING:
				_attack()
			EnemyState.KNOCKED_BACK:
				_knockback()
			EnemyState.DIE:
				_die()
	#print(current_state)
func change_state(new_state: EnemyState) -> void:
	current_state = new_state
	print("State Changed: ", current_state)

func set_attack_style(style: EnemyAttackStyle):
	attack_style = style

		
func _idle():
	pass
	
func _wandering():
	if target_pos != Vector2.ZERO:
		if global_position.distance_to(target_pos) > 1:
			var dir: Vector2 = (target_pos - global_position).normalized() * ONE_TILE
			velocity = dir * speed
			#is_moving = true
			move_and_slide()
		else:
			target_pos = Vector2.ZERO
			print("Target_Pos is 0!")
			
func _pursue():
	var dir: Vector2 = (player.global_position - global_position).normalized()
	velocity = dir * speed * ONE_TILE
	move_and_slide()
	
func _attack():
	pass

func _knockback():
	pass
	
func _die():
	print("Enemy is DYING")
	self.queue_free()
	
func take_damage(hit_points: int):
	health_points -= hit_points
	
	if health_points <= 0:
		change_state(EnemyState.DIE)

func pick_new_path():
	if current_state == EnemyState.WANDERING:
		var x: float = randf_range(-wandering_range, wandering_range)
		var y: float = randf_range(-wandering_range, wandering_range)
		
		var new_target_pos: Vector2 = Vector2(x,y)
		
		target_pos = global_position + new_target_pos
		print("NEW TARGET POS: ", target_pos)

func _on_knockback_cooldown_timer_timeout() -> void:
	pass # Replace with function body.


func _on_wander_cooldown_timer_timeout() -> void:
	pick_new_path()
	print("cooldown", target_pos)
	_wandering()
	
func _on_detect_player_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_detected = true
		change_state(EnemyState.PURSUE)

func _on_detect_player_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_detected = false
		print("Player Not Detected")
		change_state(EnemyState.WANDERING)
		
func enemy():
	pass
