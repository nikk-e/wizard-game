extends Node2D
class_name Spawner

@export var spawn_scene: PackedScene

var spawned_instance: Node = null

var enabled: bool = true

func spawn_if_needed() -> void:
	if not is_instance_valid(spawned_instance) and enabled:
		spawned_instance = spawn_scene.instantiate()
		spawned_instance.global_position = global_position
		get_parent().get_parent().add_child(spawned_instance)

func despawn_if_needed() -> void:
	if is_instance_valid(spawned_instance):
		spawned_instance.queue_free()
		spawned_instance = null
