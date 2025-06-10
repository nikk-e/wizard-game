extends Ability
class_name GrappleAbility

var GRAPPLE_DISTANCE = 400
var REEL_SPEED = 300.0

var grapplePoint: Vector2
var grappled = false
var grappledToNPC = false
var grapplePointNPCLocal: Vector2
var grappleTarget: Node2D

var isReeling = false
var isUnreeling = false

func _init(_player: Player) -> void:
	super._init(_player, 2)

func shoot_reel(player_position: Vector2, direction: Vector2, max_distance: float) -> Vector2:
	var space_state = player.get_world_2d().direct_space_state
	var ray_end = player_position + direction.normalized() * max_distance
	var query = PhysicsRayQueryParameters2D.create(player_position, ray_end, 1+4, [player])
	var result = space_state.intersect_ray(query)
	if result:
		grappledToNPC = false
		if result.collider.get_parent() is TestProjectile:
			var ob = result.collider.get_parent() as TestProjectile
			grappledToNPC = true
			grappleTarget = ob
			grapplePointNPCLocal = ob.to_local(result.position)
		#reelLength = ((result.position as Vector2) - player_position).length()
		return result.position
	else:
		return Vector2.INF

func setReel(reeling: int):
	isReeling = reeling > 0
	isUnreeling = reeling < 0
	
func abort():
	grappled = false
	grapplePoint = Vector2.INF
	grappledToNPC = false
	grappleTarget = null
	grapplePointNPCLocal = Vector2.INF
func inProgress() -> bool:
	return grappled

func ability():
	grapplePoint = shoot_reel(player.global_position, player.pointDirection, GRAPPLE_DISTANCE)
	if grapplePoint != Vector2.INF:
		grappled = true
		

func updateAbility(delta):
	if grappled:
		if grappledToNPC and !grappleTarget:
			abort()
			return
		elif grappledToNPC:
			grapplePoint = grappleTarget.global_position + grapplePointNPCLocal
		
			
		
			
		var vel = player.velocity
		var grappleVector = grapplePoint - player.global_position
		var grappleDirection = grappleVector.normalized()
		var dotProduct = vel.dot(grappleDirection)
		var parallel = grappleDirection * dotProduct
		if isReeling:
			player.velocity = grappleDirection*REEL_SPEED
		elif !isUnreeling and dotProduct <= 0:
			var perpendicular = vel - parallel
			player.velocity = perpendicular
			
		
		#if held:
		#	player.velocity = grappleDirection*REEL_SPEED
		#if (dotProduct <= 0):
		#	var perpendicular = vel - parallel
		#	player.velocity = perpendicular
		
		
