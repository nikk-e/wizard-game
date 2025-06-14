extends CharacterBody2D
class_name Enemy

@export var speed: float
@export var direction: Vector2
@export var sprite: AnimatedSprite2D
#@onready var defaultSprite = $DefaultSprite

var last_physics_pos: Vector2
var current_physics_pos: Vector2

@export var health: int
@export var gravity: float = 600
@export var jump_force: float = -300
var player_detected := false

func _process(delta: float) -> void:
	var t = Engine.get_physics_interpolation_fraction()
	var interp_pos = last_physics_pos.lerp(current_physics_pos, t)
		
	if sprite:
		sprite.position = to_local(interp_pos)
		sprite.global_position = interp_pos
	#elif defaultSprite:
	#	defaultSprite.position = to_local(interp_pos)

func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		_die()

func _die() -> void:
	queue_free()


func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_detected = true
		print("Player nearby!")	



func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_detected = false
		print("Player left.")
