extends EnemyBase

@onready var attack_area: Area2D = $Attack_Bubble
@onready var attack_shape: CollisionShape2D = $Attack_Bubble/CollisionShape2D
@export var possible_equipment: Array[InventoryItem]

var equipment: InventoryItem
var attack_cooldown_active: bool = false

const close_range: float = 1.0
const ranged_range: float = 3.0

func _ready():
	_pick_equipment()
	_configure_attack_area()
	add_to_group("target")

func _physics_process(delta):	
	super._physics_process(delta)
		
func _attack():
	if attack_cooldown_active or equipment == null:
		return

	if equipment.item_name == "Sword":
		_perform_sword_attack()
	elif equipment.item_name == "Bow":
		_perform_ranged_attack()
	elif equipment.item_name == "Dagger":
		_perform_dagger_attack()
		
func _perform_sword_attack():
	# Enemy decides randomly which type of attack to do
	var do_heavy_attack: bool = randf() < 0.4  # 40% chance for heavy attack
	attack_cooldown_active = true
	$Attack_Cooldown_Timer.start()
	
	equipment.on_use(self, "START_ATTACK")

	if do_heavy_attack:
		# Hold for 1.0 second to trigger heavy
		await get_tree().create_timer(1.0).timeout
	else:
		# Quick tap for light attack
		await get_tree().create_timer(0.1).timeout

	# Then release the attack
	equipment.on_use(self, "RELEASE_ATTACK")
	

func _perform_ranged_attack():
	var attack_type: float = randf()
	
	if attack_type < 0.4:
		equipment.on_use(self, "RAPID_FIRE")
	else:
		equipment.on_use(self, "SINGLE_SHOT")
		
	attack_cooldown_active = true
	$Attack_Cooldown_Timer.start()

func _perform_dagger_attack():
	var attack_type: float = randf()
	
	if attack_type < 0.3:
		equipment.on_use(self, "DASH_ATTACK")
	else:
		equipment.on_use(self, "STAB")
		
func _pick_equipment():
	equipment = possible_equipment[randi_range(0, possible_equipment.size() - 1)]
	inventory.add_item(equipment)
	inventory.equip_item(equipment.item_name)
	print("Bandit equipped:", equipment.item_name)

	if equipment.item_name == "Sword":
		set_attack_style(EnemyAttackStyle.CLOSE)
	elif equipment.item_name == "Bow":
		set_attack_style(EnemyAttackStyle.RANGED)

func _configure_attack_area():
	if attack_style == EnemyAttackStyle.CLOSE:
		attack_shape.scale = Vector2(close_range, close_range)
	elif attack_style == EnemyAttackStyle.RANGED:
		attack_shape.scale = Vector2(ranged_range, ranged_range)

func _on_attack_bubble_body_entered(body: Node2D) -> void:
	if body == player:
		change_state(EnemyState.ATTACKING)

func _on_attack_bubble_body_exited(body: Node2D) -> void:
	if body == player:
		change_state(EnemyState.PURSUE)

func _on_attack_cooldown_timer_timeout() -> void:
	attack_cooldown_active = false
