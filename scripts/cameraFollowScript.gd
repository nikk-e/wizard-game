extends Camera2D

@export var player: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if player:
		global_position = global_position.lerp(player.global_position, 0.1)
