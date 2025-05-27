extends Ability
class_name DoubleJumpAbility

func _init(_player: Player) -> void:
	super._init(_player, -1)

func ability():
	player.jump()
