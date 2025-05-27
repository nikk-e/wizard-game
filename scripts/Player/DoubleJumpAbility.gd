extends Ability
class_name DoubleJumpAbility

func _init() -> void:
	super._init(0.0)

func ability(player: Player):
	player.jump()
