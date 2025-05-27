extends Ability
class_name DashAbility

const DASH_SPEED = 600
const DASH_TIME = 0.2
const MAX_VERTICAL_SPEED_AFTER_DASH = 200
var inDash: bool = false
var dashTimer = 0
var dashVelocity: Vector2 = Vector2(0, 0)

func _init() -> void:
	super._init(2.0)
	inDash = false

func ability(player: Player):
	dashVelocity = player.pointDirection*DASH_SPEED
	inDash = true
	dashTimer = DASH_TIME
	
func inProgress() -> bool:
	return inDash

func updateAbility(player, delta):
	if inDash:
		dashTimer-=delta
		player.velocity = dashVelocity
		player.sprite.rotation = dashVelocity.angle()
		if dashTimer <= 0:
			inDash = false
			if abs(player.velocity.y) > MAX_VERTICAL_SPEED_AFTER_DASH:
				player.velocity.y = sign(player.velocity.y) * MAX_VERTICAL_SPEED_AFTER_DASH
