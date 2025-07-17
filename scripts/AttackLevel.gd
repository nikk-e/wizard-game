class_name AttackLevel
extends Resource

var knockback := Vector2.ZERO
var hitstun := 0.0

func _init(knockback: Vector2 = Vector2.ZERO, hitstun: float = 0.0) -> void:
	self.knockback = knockback
	self.hitstun = hitstun

# Weak attacks such as player basic attack
static var LEVEL_1 := AttackLevel.new(Vector2(50, 0), 0.15)

# A bit stronger attacks
static var LEVEL_2 := AttackLevel.new(Vector2(150, -150), 0.3)
	
