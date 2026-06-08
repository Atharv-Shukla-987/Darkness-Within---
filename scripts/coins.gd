extends Node2D

var value = 1

@onready var timer: Timer = $Timer

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is player :
		audio_stream_player_2d.play()
		
		Gamecontoll.coincollected(value)
		await audio_stream_player_2d.finished
		self.queue_free()
