extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	queue_redraw()
	

func _draw():
	var collision_shape = $StaticBody2D/CollisionShape2D
	var shape = collision_shape.shape

	if shape is RectangleShape2D:
		var size = shape.extents * 2
		draw_rect(Rect2(-shape.extents, size), Color(0, 1, 0, 0.3), true)
		draw_rect(Rect2(-shape.extents, size), Color(0, 1, 0), false)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
