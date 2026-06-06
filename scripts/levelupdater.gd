extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var currentscne  = get_tree().current_scene.scene_file_path
		var nextlvl  =currentscne.to_int() + 1
		var nextlvl2 = "res://SCENE/level_" + str(nextlvl)  + ".tscn"
		get_tree().change_scene_to_file(nextlvl2)
