extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_game_scene(scene_path: String) -> void:
	var new_scene = load(scene_path)
	if new_scene:
		get_tree().change_scene_to_packed(new_scene)
	else:
		push_error("Could not load scene at: " + scene_path)

func _on_game_button_pressed() -> void:
	load_game_scene("res://scenes/hub_world.tscn")

func _on_playground_zen_button_pressed() -> void:
	load_game_scene("res://scenes/playground_zen.tscn")


func _on_playground_nikke_button_pressed() -> void:
	load_game_scene("res://scenes/playground_zen.tscn")
