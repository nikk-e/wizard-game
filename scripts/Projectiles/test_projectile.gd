extends Projectile
class_name TestProjectile

func _on_body_entered(body):
	if body is Enemy:
		var enemy = body as Enemy
		enemy.take_damage(100)
	queue_free()
