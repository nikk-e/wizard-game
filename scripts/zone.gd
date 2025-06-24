extends Area2D
class_name Zone

@export var zone_name: String = ""

signal player_entered_zone(zone_name: String)
signal player_exited_zone(zone_name: String)
signal object_entered_zone(obj: Node, zone_name: String)
signal object_exited_zone(obj: Node, zone_name: String)

func _ready():
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

func _on_body_entered(body: Node):
	if body is Player:
		emit_signal("player_entered_zone", zone_name)
	elif body.is_in_group("load_to_zone"):
		emit_signal("object_entered_zone", body, zone_name)

func _on_body_exited(body):
	if body is Player:
		emit_signal("player_exited_zone", zone_name)
	elif body.is_in_group("load_to_zone"):
		emit_signal("object_exited_zone", body, zone_name)
