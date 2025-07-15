extends Spell
class_name BasicSpell

var BasicProjectileScene = preload("res://scenes/Projectiles/basic_projectile.tscn")

func _init(_player: Player) -> void:
	super._init(_player, 0.05)

func spell():
	var projectile = BasicProjectileScene.instantiate() as BasicProjectile
	projectile.initPosition(player.global_position)
	projectile.direction = player.pointDirection
	player.get_parent().add_child(projectile)
	
