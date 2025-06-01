extends Projectile

func _on_body_entered(body):
	print("Test Projectile Entered")
	queue_free()
