extends StaticBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var tile_map = $"../TileMapLayer"

@export var note_id: String

var tileset: TileSet
var tile_data: TileData
var player_in_area: bool
var can_move: bool = true

func _ready():
	tileset = tile_map.tile_set 


	var source_id = 0 
	var atlas_coords = Vector2i(0, 3)  

	var tile_source = tileset.get_source(source_id)

	if tile_source is TileSetAtlasSource:
		var atlas_texture = tile_source.texture
		var region = tile_source.get_tile_texture_region(atlas_coords)
		var sprite_texture = AtlasTexture.new()
		sprite_texture.atlas = atlas_texture
		sprite_texture.region = region

		sprite.texture = sprite_texture

func run_dialogue(dialogue_string):
	Dialogic.start(dialogue_string)
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = false

func _on_detector_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("action") and player_in_area:
		run_dialogue(note_id + "_dialogue")
