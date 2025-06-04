extends Camera2D

@export var player: Node2D
var topleft: Vector2 = Vector2(0, 0)
var bottomright: Vector2 = Vector2(0, 0)
@export var ceilingWorldBorder: Node2D
@export var floorWorldBorder: Node2D
@export var rightWorldBorder: Node2D
@export var leftWorldBorder: Node2D

var limit: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	var viewport_size = get_viewport_rect().size / zoom
	if ceilingWorldBorder:
		limit = true	
		topleft.y = int(ceilingWorldBorder.global_position.y + viewport_size.y / 2)
	if floorWorldBorder:
		limit = true
		bottomright.y = int(floorWorldBorder.global_position.y - viewport_size.y / 2)
	if rightWorldBorder:
		limit = true
		bottomright.x = int(rightWorldBorder.global_position.x - viewport_size.x / 2)
	if leftWorldBorder:
		limit = true
		topleft.x = int(leftWorldBorder.global_position.x + viewport_size.x / 2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player:
		if limit:
			global_position = player.global_position.clamp(topleft, bottomright)
		else:
			global_position = player.global_position
