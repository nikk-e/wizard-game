extends CharacterBody2D

class_name Player

@export var sprite: AnimatedSprite2D

var abilities: Dictionary[String, Ability] = {}

const SPEED = 200.0
const JUMP_VELOCITY = -300.0
const COYOTE_TIME = 0.1
var coyoteTimer = 0.0
var pointDirection: Vector2 = Vector2(0, 0)

var onGround = false

var last_physics_pos: Vector2
var current_physics_pos: Vector2

func _ready():
	last_physics_pos = global_position
	current_physics_pos = global_position

func _init() -> void:
	var dja = DoubleJumpAbility.new(self)
	var da = DashAbility.new(self)
	var ga = GrappleAbility.new(self)
	abilities["double_jump"] = dja
	abilities["dash"] = da
	abilities["grapple"] = ga

func jump():
	velocity.y = JUMP_VELOCITY
	coyoteTimer = 0.0

func _physics_process(delta: float) -> void:
	last_physics_pos = current_physics_pos
	
	var world_mouse_pos = get_global_mouse_position()
	pointDirection = (world_mouse_pos - global_position).normalized()
	
	var jumpable = false
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		onGround = false
	else:
		onGround = true
		coyoteTimer = COYOTE_TIME
		jumpable = true
		if abilities.has("double_jump"):
			abilities["double_jump"].restore()
		
	if (coyoteTimer > 0):
		coyoteTimer -= delta
		jumpable = true

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"):
		if abilities.has("grapple") and abilities["grapple"].inProgress():
			abilities["grapple"].abort()
			jump()
		elif jumpable:
			jump()
		elif abilities.has("double_jump"):
			abilities["double_jump"].use()
			

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if abilities.has("grapple"):
		var grapple: GrappleAbility = abilities["grapple"]
		var inputaxis = Input.get_axis("ui_left", "ui_right")
		if inputaxis:
			velocity.x = inputaxis * SPEED
		elif !grapple.inProgress():
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		if Input.is_action_just_pressed("game_grapple"):
			if grapple.inProgress():
				grapple.abort()
			else:
				grapple.use()
				grapple.setHeld(true)
		if Input.is_action_just_released("game_grapple"):
			grapple.setHeld(false)
		
	
	if Input.is_action_just_pressed("game_dash") and abilities.has("dash"):
		abilities["dash"].use()
		if abilities.has("grapple"):
			abilities["grapple"].abort()
	
	for key in abilities:
		abilities[key].update(delta)

	move_and_slide()
	current_physics_pos = global_position
	

var grappleDebugLine = false
var gDLp0: Vector2 = Vector2.INF
func _draw():
	if grappleDebugLine:
		draw_line(gDLp0, Vector2(0,0), Color.RED, 1.0)
	
func _process(delta: float) -> void:
	sprite.position = Vector2.ZERO 
	var t = Engine.get_physics_interpolation_fraction()
	var interp_pos = last_physics_pos.lerp(current_physics_pos, t)
	sprite.global_position = interp_pos

	
	var inDash = abilities.has("dash") and abilities["dash"].inProgress()
	var inGrapple = abilities.has("grapple") and abilities["grapple"].inProgress()
	var animationName = "default"
	
	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true
		
	if onGround and velocity.x > 0:
		animationName = "run"
	elif onGround and velocity.x < 0:
		animationName = "run"
		sprite.flip_h = true
	
	if velocity.y > 0:
		animationName = "fall"
	elif velocity.y < 0:
		animationName = "jump"
	
	sprite.rotation = 0
	if inDash:
		sprite.animation = "dash"
		sprite.flip_h = false
		sprite.rotation = abilities["dash"].dashVelocity.angle()
	elif inGrapple:
		sprite.animation = animationName + "_grapple"
	else:
		sprite.animation = animationName
			
	grappleDebugLine = abilities.has("grapple") and abilities["grapple"].inProgress()
	if grappleDebugLine:
		var grapple: GrappleAbility = abilities["grapple"]
		gDLp0 = grapple.grapplePoint - position
	queue_redraw()
