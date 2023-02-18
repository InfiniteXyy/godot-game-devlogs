extends Button


func _on_pressed() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()

