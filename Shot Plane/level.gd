extends Node2D

var is_dead = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	while not is_dead:
		generate_enemy()
		var timer = get_tree().create_timer(2)
		await timer.timeout


func generate_enemy() -> void:
	print("generate")
	var enemy = preload("res://enemy.tscn").instantiate()
	enemy.position = Vector2(randi_range(60, get_viewport_rect().size.x - 60), 40)
	add_child(enemy)


func _on_area_2d_area_entered(area: Area2D) -> void:
	$Label.text = "Dead"
	$CanvasModulate.visible = true
	$CanvasLayer.visible = true
	is_dead = true
	get_tree().paused = true
	

func _on_button_pressed() -> void:
	print("123")
	$CanvasModulate.visible = false
	$CanvasLayer.visible = false
	get_tree().paused = false
	get_tree().reload_current_scene()
