extends Area2D


@onready var timer: Timer = $Timer


func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	
	
func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	print("you died")
	eventcontrollr.emit_signal("playerdied")
	Engine.time_scale = 0.5
	timer.start()
	

func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()
