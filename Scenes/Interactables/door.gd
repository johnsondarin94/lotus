extends StaticBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var tile_map = $"../TileMapLayer"
@onready var ui_icon = $CanvasLayer/TextureRect

@export var spawn_vector: Vector2i# X Y Coords for where player will spawn 
@export var map_location: String 

var tileset: TileSet
var tile_data: TileData
var player_in_area: bool = false
		
func _input(event: InputEvent) -> void:
	if player_in_area && event.is_action_pressed("action"):
		Global.change_map(map_location, spawn_vector)
		

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = false
