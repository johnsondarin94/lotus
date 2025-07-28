extends StaticBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var tile_map = $"../TileMapLayer"
@onready var ui_icon = $CanvasLayer/TextureRect

@export var spawn_vector: Vector2i# X Y Coords for where player will spawn 
@export var map_location: String 

var tileset: TileSet
var tile_data: TileData
var player_in_area: bool = false

func _ready():
	ui_icon.hide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = true
		ui_icon.show()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = false
		ui_icon.hide()


func _on_detector_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if player_in_area && event.is_action_pressed("action"):
		print("Changing Map to:", map_location)
		
		Global.change_map(map_location, spawn_vector)
		

func interactable():
	pass
