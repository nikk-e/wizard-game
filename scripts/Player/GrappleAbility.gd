extends Ability
class_name GrappleAbility

var grapplePoint: Vector2
var grappled = false
var GRAPPLE_DISTANCE = 400
var REEL_SPEED = 300
var held = false

func _init(_player: Player) -> void:
	super._init(_player, 0.5)

func find_grapple_point(player_position: Vector2, direction: Vector2, max_distance: float) -> Vector2:
	var space_state = player.get_world_2d().direct_space_state
	var ray_end = player_position + direction.normalized() * max_distance
	var query = PhysicsRayQueryParameters2D.create(player_position, ray_end, 1, [player])
	var result = space_state.intersect_ray(query)
	if result:
		return result.position
	else:
		return Vector2.INF

func setHeld(h: bool):
	held = h

func abort():
	grappled = false
	grapplePoint = Vector2.INF
	
func inProgress() -> bool:
	return grappled

func ability():
	grapplePoint = find_grapple_point(player.global_position, player.pointDirection, GRAPPLE_DISTANCE)
	if grapplePoint != Vector2.INF:
		grappled = true
		
func updateAbility(delta):
	if grappled:
		var vel = player.velocity
		var grappleDirection = (grapplePoint - player.global_position).normalized()
		var dotProduct = vel.dot(grappleDirection)
		var parallel = grappleDirection * dotProduct
		if held:
			player.velocity = grappleDirection*REEL_SPEED
		elif (dotProduct <= 0):
			var perpendicular = vel - parallel
			player.velocity = perpendicular
		
		
