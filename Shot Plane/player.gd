extends CharacterBody2D



func _physics_process(delta: float) -> void:
	var input_position = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up"),
	)
	
	velocity = input_position * 400
	
	if Input.is_action_just_pressed("shot"):
		print("shot")
		generate_bullet()
	
	move_and_slide()
	

func generate_bullet() -> void:
	var bullet: Node2D = preload("res://bullet.tscn").instantiate()
	bullet.transform.origin = Vector2(
		transform.origin.x + randi_range(-40, 40),
		transform.origin.y - 100
	)
	bullet.set_meta("damage", true)
	get_tree().root.add_child(bullet)
	
	
	
