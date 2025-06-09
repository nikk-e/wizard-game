extends Area2D
class_name InteractableArea

@export var show_tooltip: bool = true
@export var tooltip: String = "Interact"
@onready var label: Label = $Label
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
var areaEnabled = false
var player: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)
	label.text = tooltip

func _on_body_entered(body: Node) -> void:
	if body is Player:
		player = body as Player
		enableArea()
		playerEntered()

func enableArea():
	areaEnabled = true
	player._push_area(self)
	if show_tooltip:
		animationPlayer.play("tooltip_appear")

func disableArea():
	areaEnabled = false
	player._pop_area(self)
	if show_tooltip:
		animationPlayer.play("tooltip_disappear")

func _on_body_exited(body: Node) -> void:
	if body is Player:
		player = body as Player
		disableArea()
		playerExited()
		
func playerEntered():
	pass
	
func playerExited():
	pass
	

func interact():
	print("No interaction defined")
	pass
