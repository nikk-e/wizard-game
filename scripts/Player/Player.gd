extends CharacterBody2D

class_name Player

@export var sprite: AnimatedSprite2D

var abilities: Dictionary[String, Ability] = {}

var currentSpell: Spell

const SPEED = 200.0
const JUMP_VELOCITY = -300.0
const COYOTE_TIME = 0.1

var max_health := 100
var health := 100

var coyoteTimer = 0.0
var pointDirection: Vector2 = Vector2(0, 0)
var cameraPosition: Vector2

var lastInputAxis = 0
var onGround = false

var knockback_velocity := Vector2.ZERO
var is_knockedback := false
var knockback_timer := 0.1
var invul_timer := 0.0
var invul := false

var last_physics_pos: Vector2
var current_physics_pos: Vector2

var area_to_interact : InteractableArea = null
var _area_stack : Array[InteractableArea] = []

func _push_area(area: InteractableArea) -> void:
	_area_stack.append(area)
	area_to_interact = area

func _pop_area(area: InteractableArea) -> void:
	_area_stack.erase(area)
	area_to_interact = _area_stack.back() if _area_stack.size() > 0 else null
	
func _ready():
	cameraPosition = global_position
	last_physics_pos = global_position
	current_physics_pos = global_position

func _init() -> void:
	var testspell = TestProjectileSpell.new(self)
	currentSpell = testspell
	var dja = DoubleJumpAbility.new(self)
	var da = DashAbility.new(self)
	var ga = GrappleAbility.new(self)
	abilities["double_jump"] = dja
	abilities["dash"] = da
	abilities["grapple"] = ga

func jump():
	velocity.y = JUMP_VELOCITY
	coyoteTimer = 0.0
	
func apply_knockback(from_position: Vector2, strength: float) -> void:
	if not invul:
		var direction = (global_position - from_position).normalized()
		knockback_velocity = direction * strength
		is_knockedback = true
		knockback_timer = 0.1  # reset timer
		invul = true
		invul_timer = 0.1
	
func take_damage(damage: int) -> void:
	if not invul:
		health -= damage
		if health <= 0:
			_die()
	print("player health: {0}/{1}".format([health, max_health]))

func get_hit(damage: int, strength: float, from_position: Vector2) -> void:
	take_damage(damage)
	apply_knockback(from_position, strength)
	
func _die() -> void:
	queue_free()	# Should probably replace with an actual implementation, but this is pretty funny.

func calculateWorldMousePosition() -> Vector2:
	var pos_on_scaled = get_global_mouse_position()
	# This will not work if the other viewport is renered at a scale other than 2x later on
	return (pos_on_scaled+cameraPosition)/2.0 # <- because the renderer renders the viewport at 2x resolution compared to the world viewport

func _physics_process(delta: float) -> void:
	last_physics_pos = current_physics_pos
	
	var world_mouse_pos = calculateWorldMousePosition()
	pointDirection = (world_mouse_pos - global_position).normalized()
	
	var jumpable = false
	if not is_on_floor():
		velocity += get_gravity() * delta
		onGround = false
	else:
		onGround = true
		coyoteTimer = COYOTE_TIME
		jumpable = true
		if abilities.has("double_jump"):
			abilities["double_jump"].restore()
		if abilities.has("grapple"):
			abilities["grapple"].abort()
		
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
	var inputaxis = Input.get_axis("ui_left", "ui_right")
	if abilities.has("grapple"):
		var grapple: GrappleAbility = abilities["grapple"]
		if inputaxis and grapple.inProgress():
			if abs(velocity.x) < SPEED and (grapple.grapplePoint.x-global_position.x)*inputaxis > 0:
				velocity.x = inputaxis * SPEED
		elif inputaxis:
			velocity.x = inputaxis * SPEED
		elif !grapple.inProgress():
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		if Input.is_action_just_pressed("game_grapple") and !grapple.inProgress():
			if !(abilities.has("dash") and abilities["dash"].inProgress()):
				grapple.use()
		
		var reelHeld = Input.is_action_pressed("game_grapple")
		var unreelHeld = Input.is_action_pressed("game_grapple_unreel")
		if reelHeld and !unreelHeld:
			grapple.setReel(1)
		elif unreelHeld and !reelHeld:
			grapple.setReel(-1)
		else:
			grapple.setReel(0)
	elif inputaxis:
		velocity.x = inputaxis * SPEED
	
	
	if Input.is_action_just_pressed("game_dash") and abilities.has("dash"):
		abilities["dash"].use()
		if abilities.has("grapple"):
			abilities["grapple"].abort()
	
	if Input.is_action_just_pressed("game_primary") and currentSpell:
		currentSpell.use()
		
	if Input.is_action_just_pressed("game_interact") and area_to_interact:
		area_to_interact.interact()
	
	for key in abilities:
		abilities[key].update(delta)
	
	currentSpell.update(delta)
	
	if is_knockedback:
		velocity = knockback_velocity
		knockback_timer -= delta
		if knockback_timer <= 0:
			is_knockedback = false
			knockback_velocity = Vector2.ZERO
	
	if invul:
		invul_timer -= delta
		if invul_timer <= 0:
			invul = false

	move_and_slide()
	current_physics_pos = global_position
	lastInputAxis = inputaxis

var mousePosDebugLine = false
var grappleDebugLine = false
var gDLp0: Vector2 = Vector2.INF
func _draw():
	if mousePosDebugLine:
		draw_circle(pointDirection*100.0, 5, Color.RED)
	if grappleDebugLine:
		draw_line(gDLp0, to_local(sprite.global_position), Color.RED, 1.0)
		


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
