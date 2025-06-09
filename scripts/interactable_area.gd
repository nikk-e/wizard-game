extends Area2D
class_name InteractableArea

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

func _on_body_entered(body: Node) -> void:
	if body is Player:
		(body as Player)._push_area(self)

func _on_body_exited(body: Node) -> void:
	if body is Player:
		(body as Player)._pop_area(self)
		
func interact(player: Player):
	print("No interaction defined")
	pass
