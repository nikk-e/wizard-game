extends Area2D
class_name Projectile

@export var speed: float = 400.0
@export var direction: Vector2 = Vector2.RIGHT
@export var lifetime: float = 1.0
@export var sprite: AnimatedSprite2D
@onready var defaultSprite = $DefaultSprite


var last_physics_pos: Vector2
var current_physics_pos: Vector2

func initPosition(pos: Vector2):
	global_position = pos
	last_physics_pos = pos
	current_physics_pos = pos

func _ready():
	$Timer.wait_time = lifetime
	$Timer.start()
	connect("body_entered", Callable(self, "_on_body_entered"))
	$Timer.connect("timeout", Callable(self, "queue_free"))

func _physics_process(delta):
	last_physics_pos = current_physics_pos
	position += direction.normalized() * speed * delta
	current_physics_pos = global_position

func _process(delta: float) -> void:
	var t = Engine.get_physics_interpolation_fraction()
	var interp_pos = last_physics_pos.lerp(current_physics_pos, t)
		
	if sprite:
		#sprite.position = to_local(interp_pos)
		sprite.global_position = interp_pos
		sprite.rotation = direction.angle()
	elif defaultSprite:
		defaultSprite.position = to_local(interp_pos)
		defaultSprite.rotation = direction.angle()

func _on_body_entered(body):
	print("Projectile Template Entered")
	queue_free()
