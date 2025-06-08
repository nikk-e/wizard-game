extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_game_scene(scene_path: String) -> void:
	var game_renderer = preload("res://scenes/game_renderer2.tscn").instantiate()
	if game_renderer:
		game_renderer.current_subscene_path = scene_path
		get_tree().current_scene.queue_free()
		get_tree().root.add_child(game_renderer)
	else:
		push_error("Could not load game renderer")

func _on_game_button_pressed() -> void:
	load_game_scene("res://scenes/hub_world.tscn")

func _on_playground_zen_button_pressed() -> void:
	load_game_scene("res://scenes/playground_zen.tscn")


func _on_playground_nikke_button_pressed() -> void:
	load_game_scene("res://scenes/playground_zen.tscn")
