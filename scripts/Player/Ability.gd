extends Node
class_name Ability

var COOLDOWN: float
var cooldown_timer: float
var canUse = true

func _init(cooldown: float = 1.0):
	COOLDOWN = cooldown
	cooldown_timer = cooldown
	
func ability(player):
	push_error("ability() not implemented in subclass!")

func use(player):
	if (canUse):
		canUse = false
		cooldown_timer = COOLDOWN
		ability(player)

func get_cooldown() -> float:
	return cooldown_timer

func update(delta: float):
	cooldown_timer -= delta
	if cooldown_timer <= 0:
		restore()

func restore():
	canUse = true
