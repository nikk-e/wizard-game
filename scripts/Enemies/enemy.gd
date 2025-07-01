extends CharacterBody2D
class_name Enemy

@export var speed: float
@export var direction: Vector2
@export var sprite: AnimatedSprite2D
#@onready var defaultSprite = $DefaultSprite

var last_physics_pos: Vector2
var current_physics_pos: Vector2

var health: int
@export var MAX_HEALTH: int
@export var contact_damage := 0
@export var knockback_force := Vector2(150, -150)
@export var gravity: float = 600
@export var jump_force: float = -300
var player_detected := false
var player: Player

const knockback_duration := 0.3
var is_knockedback := false
var knockback_timer := 0.0

func _init() -> void:
	pass

func move(delta: float) -> void:
	print("No movement function implemented in enemy!")
	pass

#  Will probably change this later to give enemies a different kind of knockback from the player to feel more natural.
func apply_knockback(from_position: Vector2, knockback_force: Vector2) -> void:
	is_knockedback = true
	knockback_timer = knockback_duration

	var direction = sign(global_position.x - from_position.x) # 1 = hit from left, -1 = hit from right
	print(direction)
	velocity.x = direction * knockback_force.x
	velocity.y = knockback_force.y # always up
	
func take_damage(damage: int) -> void:
	health -= damage
	if health <= 0:
		_die()

func get_hit(damage: int, knockback_force: Vector2, from_position: Vector2) -> void:
	take_damage(damage)
	apply_knockback(from_position, knockback_force)
	
func _die() -> void:
	queue_free()

func _physics_process(delta: float) -> void:
	last_physics_pos = global_position
	if is_knockedback:
		if sprite:
			sprite.modulate = Color(1, 0, 0)
		knockback_timer -= delta
		if knockback_timer <= 0:
			is_knockedback = false
			if sprite:
				sprite.modulate = Color(1, 1, 1)
		move_and_slide()
	else:
		move(delta)
	if player_detected:
		player.get_hit(contact_damage, knockback_force, global_position)
	current_physics_pos = global_position

func _process(delta: float) -> void:
	var t = Engine.get_physics_interpolation_fraction()
	var interp_pos = last_physics_pos.lerp(current_physics_pos, t)
		
	if sprite:
		#sprite.position = to_local(interp_pos)
		sprite.global_position = interp_pos
	#elif defaultSprite:
	#	defaultSprite.position = to_local(interp_pos)

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		player_detected = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_detected = false
