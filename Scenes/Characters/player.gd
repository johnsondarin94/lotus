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
var health_points: int = 10

var is_knocked_back: bool = false
var knockback_velocity: Vector2
var knockback_strength: float = 100.0
var knockback_direction: Vector2

signal equipped_item_changed(item: InventoryItem)

func get_inventory():
	return player_inventory
	
	
func _ready():
	if !can_move: 
		return
	add_to_group("target")
	Global.set_player_reference(self)
	Dialogic.timeline_started.connect(_on_dialogue_start)
	Dialogic.timeline_ended.connect(_on_dialogue_end)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			is_moving = event.pressed
			
	if event.is_action_pressed("action"):
		if equipped_item != null && player_inventory.item_in_inventory(equipped_item.item_name) && equipped_item.on_use.is_valid():
			if item_in_use:
				return
			print("Item in inventory", equipped_item.item_id)
			equipped_item.on_use(self)
			$ItemInUse.start()
			item_in_use = true
			

	if event.is_action_pressed("equip_sword"):
		if player_inventory.item_in_inventory("Sword"):
			equipped_item = player_inventory.equip_item("Sword")
			print(equipped_item)
			emit_signal("equipped_item_changed", equipped_item)
		
	if event.is_action_pressed("equip_flute"):
		if player_inventory.item_in_inventory("Flute"):
			equipped_item = player_inventory.equip_item("Flute")
			emit_signal("equipped_item_changed", equipped_item)
	
	if event.is_action_pressed("equip_bow"):
		if player_inventory.item_in_inventory("Bow"):
			equipped_item = player_inventory.equip_item("Bow")
			emit_signal("equipped_item_changed", equipped_item)

func _process(_delta: float) -> void:
	if is_moving:
		target_position = get_global_mouse_position()
	
func _physics_process(delta):
	if !can_move:
		apply_friction()
		move_and_slide()
		_animated_sprite2d.play("idle")
		return
		
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
	if health_points <= 0:
		die()
	knockback(sword_swing_direction)
	health_points -= 1
	print(health_points)
	
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
