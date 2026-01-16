extends CharacterBody2D

@onready var _animated_sprite2d = $AnimatedSprite2D
@onready var player_inventory = Inventory.new()

@export var SPEED: float = 40.0
@export var FRICTION: float = 6.0
@export var ACCELERATION: float = 10.0


var can_move: bool = true
var in_cutscene: bool = false
var mouse_held: bool = false
var equipped_item: InventoryItem
var is_moving: bool = false
var target_position: Vector2
var item_in_use: bool = false

var max_hp: int = 5
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
	Dialogic.signal_event.connect(_on_dialogic_signal)
	
	

func _input(event):
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
		
	if event.is_action_pressed("equip_dagger"):
		if player_inventory.item_in_inventory("Dagger"):
			equipped_item = player_inventory.equip_item("Dagger")
			emit_signal("equipped_item_changed", equipped_item)

func _process(delta: float) -> void:
	if equipped_item != null and player_inventory.item_in_inventory(equipped_item.item_name) and equipped_item.on_use.is_valid() and can_move:
		if item_in_use:
			return
			
		if equipped_item.item_name == "Flute":
			if Input.is_action_just_pressed("left_click"):
				#print("Hey you used the ")
				equipped_item.on_use(self, equipped_item.behavior_method)
		
		if equipped_item.item_name == "Sword":
			if Input.is_action_just_pressed("left_click"):
				click_hold_time = 0.0
				is_click_and_holding = true
				equipped_item.on_use(self, "START_ATTACK")

			if is_click_and_holding and Input.is_action_pressed("left_click"):
				click_hold_time += delta

			if Input.is_action_just_released("left_click"):
				is_click_and_holding = false
				equipped_item.on_use(self, "RELEASE_ATTACK")
				click_hold_time = 0.0
				item_in_use = true
				$ItemInUse.start()
		
		if equipped_item.item_name == "Bow":
			if Input.is_action_just_pressed("left_click"):
				equipped_item.on_use(self, "SINGLE_SHOT")
				item_in_use = true
				$ItemInUse.start()
			if Input.is_action_just_pressed("right_click"):
				equipped_item.on_use(self, "RAPID_FIRE")
				item_in_use = true
				$ItemInUse.start()
		
		if equipped_item.item_name == "Dagger":
			if Input.is_action_just_pressed("left_click"):
				equipped_item.on_use(self, "STAB")
				item_in_use = true
				$ItemInUse.start()
			if Input.is_action_just_pressed("right_click"):
				equipped_item.on_use(self, "DASH_ATTACK")
				item_in_use = true
				$ItemInUse.start()
								
func _physics_process(delta):
	if in_cutscene:
		_animated_sprite2d.play("walk")
		return
		
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
		move_and_slide()
		return

	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		accelerate(input_vector)
		_animated_sprite2d.play("walk")
		_animated_sprite2d.flip_h = input_vector.x < 0
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

func lock_movement():
	can_move = false
	in_cutscene = true
	
func unlock_movement():
	can_move = true
	in_cutscene = false
	
func _on_dialogic_signal(item_name: String):
	# TEMP 
	if !item_name == "res://Resources/%s.tres" % item_name:
		return
	# TODO current method is hacky, instead create a dictionary of all resource items and preload them at startup 
	var item_path: String = "res://Resources/%s.tres" % item_name
	var item := load(item_path) as InventoryItem
	player_inventory.add_item(item)
	print(item_name)
	if item_name == "scarf":
		$AnimatedSprite2D.sprite_frames = preload("res://Scenes/Characters/player-scarf.tres")
	
func player():
	pass

func _on_item_in_use_timeout() -> void:
	item_in_use = false
