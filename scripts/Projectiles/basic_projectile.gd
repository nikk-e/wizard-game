extends Projectile
class_name BasicProjectile

func _on_body_entered(body):
	if body is Enemy:
		var enemy = body as Enemy
		enemy.get_hit(10, AttackLevel.LEVEL_1, global_position)
	queue_free()
