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
@export var contact_attack_level := AttackLevel.LEVEL_2
@export var gravity: float = 600
@export var jump_force: float = -300
var player_detected := false
var player: Player

var is_knockedback := false
var knockback_timer := 0.0

func _init() -> void:
	pass

func move(delta: float) -> void:
	print("No movement function implemented in enemy!")
	pass

#  Will probably change this later to give enemies a different kind of knockback from the player to feel more natural.
func apply_knockback(from_position: Vector2, attack_level: AttackLevel) -> void:
	is_knockedback = true
	knockback_timer = attack_level.hitstun

	var direction = sign(global_position.x - from_position.x) # 1 = hit from left, -1 = hit from right
	velocity.x = direction * attack_level.knockback.x
	velocity.y = attack_level.knockback.y # always up
	
func take_damage(damage: int) -> void:
	health -= damage
	if health <= 0:
		_die()

func get_hit(damage: int, attack_level: AttackLevel, from_position: Vector2) -> void:
	take_damage(damage)
	apply_knockback(from_position, attack_level)
	
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
		player.get_hit(contact_damage, contact_attack_level, global_position)
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
