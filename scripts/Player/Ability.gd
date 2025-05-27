extends Node
class_name Ability

var COOLDOWN_ABILITY = true
var COOLDOWN: float
var cooldown_timer: float
var canUse = true

func _init(cooldown: float = 1.0):
	if (cooldown < 0):
		COOLDOWN_ABILITY = false	
	COOLDOWN = cooldown
	cooldown_timer = cooldown
	
func ability(player):
	push_error("ability() not implemented in subclass!")

func updateAbility(player: Player, delta: float):
	pass

func use(player: Player):
	if (canUse):
		canUse = false
		cooldown_timer = COOLDOWN
		ability(player)

func get_cooldown() -> float:
	return cooldown_timer

func inProgress() -> bool:
	return false

func update(player: Player, delta: float):
	updateAbility(player, delta)
	if COOLDOWN_ABILITY:
		cooldown_timer -= delta
		if cooldown_timer <= 0:
			restore()

func restore():
	cooldown_timer = 0.0
	canUse = true
