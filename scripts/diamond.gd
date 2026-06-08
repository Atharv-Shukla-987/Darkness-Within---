extends Node2D

var value = 1

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is player :
		audio_stream_player.play()
		
		Gamecontoll.diamondcollected(value)
		await audio_stream_player.finished
		self.queue_free()
