extends Node


@export var start_pos_y: float = 20
@export var spawn_interval_secs: float = 0
@onready var start_pos_x: float = get_viewport().get_visible_rect().size.x / 2
@onready var score_label: Label = $CanvasLayer/Label

var score = 0

var fruit_instance: RigidBody2D


func _ready() -> void:
	var refresh_rate = DisplayServer.screen_get_refresh_rate()
	Engine.max_fps = refresh_rate
	instantiate_fruit()
	
func add_score(by = 1) -> void:
	var target = score + by
	while score < target:
		score += 1
		score_label.text = str(score)
		await get_tree().create_timer(0.05).timeout
	
func win() -> void:
	Engine.time_scale = 0
	var WinScene = load('res://win.tscn')
	add_child(WinScene.instantiate())

func lose() -> void:
	Engine.time_scale = 0
	var WinScene = load('res://lose.tscn')
	add_child(WinScene.instantiate())

func _input(event: InputEvent) -> void:
	if event is InputEventMouse or event is InputEventScreenTouch:
		start_pos_x = event.position.x
		if fruit_instance != null:
			fruit_instance.position = Vector2(event.position.x, start_pos_y)
	if event is InputEventMouseButton and Input.is_action_just_released('spawn'):
		if fruit_instance != null:
			fruit_instance.freeze = false
			fruit_instance = null
			$Timer.start(spawn_interval_secs)

func instantiate_fruit() -> void:
	var FruitScene = load('res://fruit.tscn')
	fruit_instance = FruitScene.instantiate()
	fruit_instance.position = Vector2(start_pos_x, start_pos_y)
	fruit_instance.freeze = true
	add_child(fruit_instance)
	fruit_instance.increase_level(randi_range(1, 4))

func _on_timer_timeout() -> void:
	if check_is_lose($Deadline.get_overlapping_bodies()):
		lose()
	else:
		instantiate_fruit()
	$Timer.stop()


func check_is_lose(bodies: Array[Node2D]):
	var overlap_fruits = bodies.filter(func(body): return body.name.contains("Fruit") and body.neighbour_fruits_count > 0)
	if overlap_fruits.size() > 0:
		return true
	return false

