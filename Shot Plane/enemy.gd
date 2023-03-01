extends Node2D

var tween_offset_y: int = 0
var is_hurting: bool = false
var life: float = 4

@onready var lifebar = $Lifebar 


func _process(delta: float) -> void:
	if is_hurting:
		position.y = tween_offset_y
	else:
		position.y += 1

func get_hurt() -> void:
	if is_hurting:
		return
	life -= 1;
	lifebar.scale.x = life / 4
	if life == 0:
		queue_free()
		var score = get_node("/root/Level/Label")
		score.text = str(int(score.text) + 1)
	var tween = get_tree().create_tween()
	is_hurting = true
	tween_offset_y = transform.origin.y
	await tween.tween_property(self, "tween_offset_y", transform.origin.y - 20, 0.3).set_trans(Tween.TRANS_QUAD).finished
	is_hurting = false

func _on_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area.get_meta("damage"):
		get_hurt()
		area.queue_free()
