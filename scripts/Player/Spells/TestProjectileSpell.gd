extends Spell
class_name TestProjectileSpell

var testProjectileScene = preload("res://scenes/Projectiles/test_projectile.tscn")

func _init(_player: Player) -> void:
	super._init(_player, 0.5)

func spell():
	var projectile = testProjectileScene.instantiate() as Projectile
	projectile.initPosition(player.global_position)
	projectile.direction = player.pointDirection
	player.get_parent().add_child(projectile)
