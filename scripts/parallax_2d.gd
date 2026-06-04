extends ParallaxBackground


# Called when the node enters the scene tree for the first time.

var scroll_speed = 100
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	scroll_offset.x += delta  *  scroll_speed
