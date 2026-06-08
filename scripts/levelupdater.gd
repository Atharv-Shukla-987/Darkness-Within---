extends Area2D

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var currentscne  = get_tree().current_scene.scene_file_path
		var nextlvl  =currentscne.to_int() + 1
		var nextlvl2 = "res://SCENE/levels/level_" + str(nextlvl)  + ".tscn"
		audio_stream_player.play()
		await audio_stream_player.finished
		
		get_tree().change_scene_to_file(nextlvl2)
		
