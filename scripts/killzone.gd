extends Area2D


func _ready() -> void:
	body_entered.connect(_onbody_entered)



func _onbody_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		(body as player).takedamage(25)
		eventcontrollr.emit_signal("damagetaken")
