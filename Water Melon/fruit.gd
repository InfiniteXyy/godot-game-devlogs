extends RigidBody2D

var level = 1

var neighbour_fruits_count = 0

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var player = get_node("/root/Node2D")

func _process(_delta: float) -> void:
	var bodies = get_colliding_bodies()
	var fruits = bodies.filter(is_fruits)
	var mergeable_fruits = fruits.filter(is_mergeable)
	
	if fruits.size() == 0:
		return
	if mergeable_fruits.size() > 0:
		# 优先 merge，之后再判断失败
		mergeable_fruits[0].increase_level()
		freeze = true
		collision.disabled = true
		player.add_score(level)
		audio_player.play()
		animation_player.play('destroy')
	else:
		neighbour_fruits_count = fruits.size()



func is_fruits(node: Node2D) -> bool:
	return node.name.contains('Fruit')

func is_mergeable(node: Node2D) -> bool:
	return node.level == level

func increase_level(to = level + 1) -> void:
	level = to
	if level > 11:
		player.win()
	else:
		sprite.texture = load("res://assets/fruit_%d.png" % level)
		collision.shape = CircleShape2D.new()
		collision.shape.radius = sprite.texture.get_width() / 2.0


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == 'destroy':
		queue_free()
