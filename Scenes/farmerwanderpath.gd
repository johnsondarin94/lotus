extends PathFollow2D

@export var speed: float = 0.1
var stop_points: Array[float] = [0.0, 0.2871, 0.5311, 0.8602, 0.999]
var stop_point_index = 0 
var is_idle: bool = false

func _process(delta: float) -> void:
	if is_idle:
		return
	
	self.progress_ratio += speed * delta
	
	if stop_point_index <= stop_points.size() && progress_ratio >= stop_points[stop_point_index]:
		is_idle = true
		$Farmer.is_moving = false
		$IdleTimer.start()
		stop_point_index += 1
		
		if stop_point_index >= stop_points.size():
			stop_point_index = 0
		


func _on_idle_timer_timeout() -> void:
	is_idle = false
	$Farmer.is_moving = true 
