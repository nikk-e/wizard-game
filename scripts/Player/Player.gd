extends CharacterBody2D

class_name Player

var abilities: Dictionary[String, Ability] = {}

const SPEED = 200.0
const JUMP_VELOCITY = -300.0
const COYOTE_TIME = 0.05
var coyoteTimer = 0.0

func _init() -> void:
	var dja = DoubleJumpAbility.new()
	abilities["double_jump"] = dja

func jump():
	velocity.y = JUMP_VELOCITY
	coyoteTimer = 0.0

func _physics_process(delta: float) -> void:
	var jumpable = false
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		coyoteTimer = COYOTE_TIME
		jumpable = true
		if abilities.has("double_jump"):
			abilities["double_jump"].restore()
		
	if (coyoteTimer > 0):
		coyoteTimer -= delta
		jumpable = true

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"):
		if jumpable:
			jump()
		elif abilities.has("double_jump"):
			abilities["double_jump"].use(self)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
