extends Area2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
var triggered = false

func _ready():
	sprite.visible = false
	connect("body_entered", _on_body_entered)
	sprite.connect("animation_finished", _on_animation_finished)

func _on_body_entered(body):
	if triggered or not (body is Player):
		return
	triggered = true
	sprite.visible = true
	sprite.play("appear")

func _on_animation_finished():
	if sprite.animation == "appear":
		sprite.stop()
		sprite.animation = "default"
