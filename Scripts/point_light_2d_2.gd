extends PointLight2D

var bisTorch: bool = false

func _ready() -> void:
	bisTorch = true
	flicker()
	
func flicker() -> void:
	var f = create_tween()
	f.connect("finished", Callable(self, "tweenFinished"))
	f.tween_property(self, "scale", Vector2(0.5, 0.5), 2.0)
	f.chain().tween_property(self, "scale", Vector2(1,1), 2.0)

func tweenFinished() -> void:
	if bisTorch:
		flicker()
