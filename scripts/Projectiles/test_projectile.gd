extends Projectile
class_name TestProjectile

func _on_body_entered(body):
	if body is Enemy:
		var enemy = body as Enemy
		enemy.get_hit(10, Vector2(150, -150), global_position)
	queue_free()
