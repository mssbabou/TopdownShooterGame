extends Area2D

@export var speed: float = 0
@export var direction: Vector2 = Vector2.UP

func _process(delta):
	position += direction * speed * delta
