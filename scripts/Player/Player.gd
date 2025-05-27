extends CharacterBody2D

class_name Player

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var abilities: Dictionary[String, Ability] = {}

const SPEED = 200.0
const JUMP_VELOCITY = -300.0
const COYOTE_TIME = 0.05
var coyoteTimer = 0.0
var pointDirection: Vector2 = Vector2(0, 0)

func _init() -> void:
	var dja = DoubleJumpAbility.new()
	var da = DashAbility.new()
	abilities["double_jump"] = dja
	abilities["dash"] = da

func jump():
	velocity.y = JUMP_VELOCITY
	coyoteTimer = 0.0

func _physics_process(delta: float) -> void:
	var world_mouse_pos = get_global_mouse_position()
	pointDirection = (world_mouse_pos - global_position).normalized()
	
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
	var inputaxis = Input.get_axis("ui_left", "ui_right")
	if inputaxis:
		velocity.x = inputaxis * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Input.is_action_just_pressed("game_dash") and abilities.has("dash"):
		abilities["dash"].use(self)
	
	for key in abilities:
		abilities[key].update(self, delta)

	move_and_slide()
	
func _process(delta: float) -> void:
	if abilities.has("dash"):
		var dash: DashAbility = abilities["dash"]
		if dash.inProgress():
			sprite.animation = "dash"
			sprite.rotation = dash.dashVelocity.angle()
		else:
			sprite.animation = "default"
			sprite.rotation = 0
