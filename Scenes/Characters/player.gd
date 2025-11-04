extends CharacterBody2D

@onready var _animated_sprite2d = $AnimatedSprite2D
@onready var player_inventory = Inventory.new()

@export var SPEED: float = 40.0
@export var FRICTION: float = 6.0
@export var ACCELERATION: float = 10.0

var can_move: bool = true

var mouse_held: bool = false
var equipped_item: InventoryItem
var is_moving: bool = false
var target_position: Vector2
var item_in_use: bool = false

var max_hp: int = 15
var health_points: int = max_hp

var is_knocked_back: bool = false
var knockback_velocity: Vector2
var knockback_strength: float = 100.0
var knockback_direction: Vector2

var is_click_and_holding: bool
var click_hold_time: float = 0.0
var click_hold_time_threshold: float = 1.0

signal equipped_item_changed(item: InventoryItem)
signal hp_changed(health_points)

func get_inventory():
	return player_inventory
	
func get_player_hp():
	return health_points
	
func get_player_max_hp():
	return max_hp
	
func _ready():
	Global.set_player_reference(self)
	if !can_move: 
		return
	add_to_group("target")
	add_to_group("player")
	
	Dialogic.timeline_started.connect(_on_dialogue_start)
	Dialogic.timeline_ended.connect(_on_dialogue_end)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			is_moving = event.pressed
			
	if event.is_action_pressed("action"):
		pass
				
			#if click_hold_time >= click_hold_time_threshold:
				#equipped_item.on_use(self, "HEAVY_ATTACK")
				
			#if click_hold_time < click_hold_time_threshold:
				#equipped_item.on_use(self, "LIGHT_ATTACK")
				
			#is_click_and_holding = false	
			#$ItemInUse.start()
			#item_in_use = true
			

	if event.is_action_pressed("equip_sword"):
		if player_inventory.item_in_inventory("Sword"):
			equipped_item = player_inventory.equip_item("Sword")
			emit_signal("equipped_item_changed", equipped_item)
		
	if event.is_action_pressed("equip_flute"):
		if player_inventory.item_in_inventory("Flute"):
			equipped_item = player_inventory.equip_item("Flute")
			emit_signal("equipped_item_changed", equipped_item)
	
	if event.is_action_pressed("equip_bow"):
		if player_inventory.item_in_inventory("Bow"):
			equipped_item = player_inventory.equip_item("Bow")
			emit_signal("equipped_item_changed", equipped_item)

func _process(delta: float) -> void:
	if is_moving:
		target_position = get_global_mouse_position()
	if equipped_item != null && player_inventory.item_in_inventory(equipped_item.item_name) && equipped_item.on_use.is_valid():
		if item_in_use:
			return
		if Input.is_action_pressed("action"):
			click_hold_time += delta
			
			print(click_hold_time)
	
		if Input.is_action_just_released("action"):
			click_hold_time = 0.0
			equipped_item.on_use(self, "LIGHT_ATTACK")
			print("Released key")
	
func _physics_process(delta):
	if !can_move:
		apply_friction()
		move_and_slide()
		_animated_sprite2d.play("idle")
		return
	
	if velocity.length() > 0.1:
		for i in self.get_slide_collision_count():
			var col = self.get_slide_collision(i)
			if col.get_collider() is RigidBody2D && self.get_slide_collision_count() > 0:
				col.get_collider().apply_force(col.get_normal() * -8)
	
	if is_knocked_back:
		$AnimatedSprite2D.play("knockback")
		velocity = knockback_velocity
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, 300 * delta)
		if knockback_velocity.length() < 1.0:
			is_knocked_back = false
			
	if is_moving:
		var direction = (target_position - global_position).normalized()
		
		if direction.x < 0: 
			_animated_sprite2d.flip_h = true
		else:
			_animated_sprite2d.flip_h = false
			
		if (global_position != target_position):
			accelerate(direction)
			_animated_sprite2d.play("walk")
		
		
	else:
		apply_friction()
		_animated_sprite2d.play("idle")
		
	move_and_slide()
	
	
func accelerate(direction: Vector2):
	velocity = velocity.move_toward(SPEED * direction, ACCELERATION)

func take_damage(amount: int, sword_swing_direction: Vector2):
	knockback(sword_swing_direction)
	health_points -= amount
	emit_signal("hp_changed", health_points)
	if health_points <= 0:
		die()
	print(health_points)
	
func gain_hp(amount: int):
	health_points += amount
	emit_signal("hp_changed", health_points)
	
func knockback(sword_swing_direction: Vector2) -> void:
	is_knocked_back = true
	knockback_velocity = sword_swing_direction.normalized() * knockback_strength

func die():
	queue_free()
	print("YOU HAVE DIED")
	
func apply_friction():
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
	
func _on_dialogue_start():
	can_move = false
	
func _on_dialogue_end():
	can_move = true
	
func player():
	pass

func _on_item_in_use_timeout() -> void:
	item_in_use = false
