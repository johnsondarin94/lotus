extends EnemyBase



@onready var attack_area: Area2D = $Attack_Bubble
@onready var attack_shape: CollisionShape2D = $Attack_Bubble/CollisionShape2D
@export var possible_equipment: Array[InventoryItem]

var equipment: InventoryItem
var target_in_attack_bubble
var attack_cooldown_active: bool
 
const attack_choices: Array[String] = ["LIGHT_ATTACK", "HEAVY_ATTACK"]
const close_range: float = 1.0
const ranged_range: float = 2.0

func _ready():
	_pick_equipment()
	_configure_attack_area()
	
func _physics_process(_delta):
	super._physics_process(_delta)

func _attack():
	var attack_method = attack_choices.pick_random()
	if !attack_cooldown_active:
		print(attack_method)
		equipment.on_use(self, attack_method)
		attack_cooldown_active = true
		$Attack_Cooldown_Timer.start()
		
func _pick_equipment():
	equipment = possible_equipment[randi_range(0, possible_equipment.size() -1)]
	inventory.add_item(equipment)
	inventory.equip_item(equipment.item_name)
	print(equipment.item_name)
	if equipment.item_name == "Sword":
		set_attack_style(EnemyAttackStyle.CLOSE)
	if equipment.item_name == "Bow":
		set_attack_style(EnemyAttackStyle.RANGED)
		
func _configure_attack_area():
	print("Attack Style: ", attack_style)
	if attack_style == EnemyAttackStyle.CLOSE:
		attack_shape.scale = Vector2(close_range, close_range)
	
	if attack_style == EnemyAttackStyle.RANGED:
		attack_shape.scale = Vector2(ranged_range, ranged_range)

func _on_attack_bubble_body_entered(body: Node2D) -> void:
	if body == player:
		change_state(EnemyState.ATTACKING)

func _on_attack_bubble_body_exited(body: Node2D) -> void:
	if body == player:
		change_state(EnemyState.PURSUE)

func _on_attack_cooldown_timer_timeout() -> void:
	attack_cooldown_active = false
