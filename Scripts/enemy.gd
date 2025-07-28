extends CharacterBody2D

@export var health: int = 5
@export var SPEED: float = 25.0
@export var wander_tile_range: int = 2
@export var equipment: InventoryItem
@export var target: Node2D = null

@onready var player = Global.get_player_reference()
@onready var inventory = Inventory.new()


enum EnemyState {IDLE, WANDERING, CHASING, ATTACKING, DYING}
const ONE_TILE = 10 # Represents 1 tile 

var player_detected: bool = false
var current_state: EnemyState = EnemyState.WANDERING
var target_id_path: Array[Vector2i] = []
var target_position: Vector2
var is_moving: bool = false
var attack_cooldown_active: bool = false
var is_knocked_back: bool = false
var knockback_velocity: Vector2
var knockback_strength: float = 100.0
var knockback_direction: Vector2
var knockback_distance: float = 300.0

var active_animation: String

func _ready():
	add_to_group("target")
	inventory.add_item(equipment)
	current_state = EnemyState.WANDERING
	$Timer.set_wait_time(randf_range(2.0, 5.0))
	$Timer.start()
	
func get_equipment() -> InventoryItem:
	return equipment	
	
	
func set_active_animation(animation_name: String):
	if active_animation == animation_name:
		return
	active_animation = animation_name
	$AnimatedSprite2D.play(animation_name)

	
	
func _physics_process(delta: float) -> void:
	#velocity = Vector2.ZERO
	
	if is_knocked_back:
		set_active_animation("knockback")
		velocity = knockback_velocity
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, knockback_distance * delta)
		if knockback_velocity.length() < 1.0:
			is_knocked_back = false
		set_active_animation("walk")
			
	else: 
		match current_state:
			EnemyState.WANDERING:
				wander()
				set_active_animation("walk")
			EnemyState.CHASING:
				chase_player()
				set_active_animation("walk")
			EnemyState.ATTACKING:
				attack()
				set_active_animation("walk")
			EnemyState.DYING:
				die()
	
	if velocity.length() < 0.1 && EnemyState.WANDERING:
		change_state(EnemyState.IDLE)
		set_active_animation("idle")
		
	move_and_slide()
	
func chase_player():
	if !player_detected:
		change_state(EnemyState.WANDERING)
		return
	
	var dir = (player.global_position - global_position).normalized()
	velocity = dir * SPEED
	if get_equipment().item_name == "Bow":
		change_state(EnemyState.ATTACKING)
		
	if global_position.distance_to(player.global_position) <= ONE_TILE && get_equipment().item_name == "Sword":
		#velocity = Vector2.ZERO
		change_state(EnemyState.ATTACKING)
		
func wander():
	if target_position != Vector2.ZERO:
		if global_position.distance_to(target_position) > 1:
			var dir = (target_position - global_position).normalized()
			velocity = dir * SPEED
		else:
			velocity - Vector2.ZERO

func pick_new_path():
	var offset = Vector2(
		randi_range(-wander_tile_range, wander_tile_range) * ONE_TILE,
		randi_range(-wander_tile_range, wander_tile_range) * ONE_TILE
	)
	target_position = global_position + offset
	
func attack():	
	if !attack_cooldown_active:
		equipment.on_use(self)
		attack_cooldown_active = true
		$AttackCooldown.start()
	else:
		change_state(EnemyState.CHASING)
		
func take_damage(damge_amount: int, sword_swing_direction: Vector2):
	health = health - damge_amount
	knockback(sword_swing_direction)
	if health <= 0:
		change_state(EnemyState.DYING)
	
		
func knockback(sword_swing_direction: Vector2) -> void:
	is_knocked_back = true
	knockback_velocity = sword_swing_direction.normalized() * knockback_strength
	
func die():
	queue_free()
	
func change_state(new_state: EnemyState) -> void:
	current_state = new_state
	
func _on_timer_timeout() -> void:
	if current_state == EnemyState.WANDERING:
		pick_new_path()
		
func _on_player_detection_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_detected = true
		change_state(EnemyState.CHASING)

func _on_player_detection_body_exited(body: Node2D) -> void:
	if body == player:
		player_detected = false
		change_state(EnemyState.WANDERING)

func _on_knockback_timer_timeout() -> void:
	is_knocked_back = false


func _on_attack_cooldown_timeout() -> void:
	attack_cooldown_active = false
	
func enemy() -> void:
	pass
