extends Enemy

@export var patrol_distance: float = 100
@export var jump_interval: float = 1.5  # Seconds between jumps

var start_position: Vector2
var jump_timer := 0.0

func _init():
	health = 500
	
func _ready():
	start_position = global_position
	speed = 100
	direction = Vector2.RIGHT
	knockback_strength = 400
	contact_damage = 10
	
func _physics_process(delta):
	#last_physics_pos = current_physics_pos
	
	# Apply horizontal movement
	velocity.x = direction.x * speed

	# Apply gravity
	velocity.y += gravity * delta

	# Handle jumping
	jump_timer += delta
	if jump_timer >= jump_interval and is_on_floor():
		velocity.y = jump_force
		jump_timer = 0.0

	# Move the enemy
	move_and_slide()

	#current_physics_pos = global_position
	# Patrol logic
	if global_position.distance_to(start_position) > patrol_distance:
		direction = -direction
