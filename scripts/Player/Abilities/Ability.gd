extends Node
class_name Ability

var COOLDOWN_ABILITY = true
var COOLDOWN: float
var cooldown_timer: float
var canUse = true
var player: Player = null

func _init(_player: Player, cooldown: float = 1.0):
	player = _player
	if (cooldown < 0):
		COOLDOWN_ABILITY = false	
	COOLDOWN = cooldown
	cooldown_timer = cooldown
	
func ability():
	push_error("ability() not implemented in subclass!")

func updateAbility(delta: float):
	pass

func use():
	if (canUse):
		canUse = false
		cooldown_timer = COOLDOWN
		ability()
		
func get_cooldown() -> float:
	return cooldown_timer

func inProgress() -> bool:
	return false
	
func abort():
	pass

func update(delta: float):
	updateAbility(delta)
	if COOLDOWN_ABILITY:
		cooldown_timer -= delta
		if cooldown_timer <= 0:
			restore()

func restore():
	cooldown_timer = 0.0
	canUse = true
