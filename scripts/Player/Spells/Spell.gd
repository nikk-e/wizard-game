extends Node
class_name Spell

var COOLDOWN: float
var cooldown_timer: float
var canUse = true
var player: Player = null

func _init(_player: Player, cooldown: float = 1.0):
	player = _player
	COOLDOWN = cooldown
	cooldown_timer = cooldown
	
func spell():
	push_error("spell() not implemented in subclass!")

func updateSpell(delta: float):
	pass

func use():
	if (canUse):
		canUse = false
		cooldown_timer = COOLDOWN
		spell()
		
func get_cooldown() -> float:
	return cooldown_timer

func inProgress() -> bool:
	return false
	
func abort():
	pass

func update(delta: float):
	updateSpell(delta)
	cooldown_timer -= delta
	if cooldown_timer <= 0:
		restore()

func restore():
	cooldown_timer = 0.0
	canUse = true
