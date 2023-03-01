extends Node2D

var position_y: int = 0

func _ready() -> void:
	var tween = create_tween()
	position_y = transform.origin.y
	tween.tween_property(self, "position_y", position.y - 1000, 1)



func _physics_process(delta: float) -> void:
	transform.origin = Vector2(transform.origin.x, position_y)
