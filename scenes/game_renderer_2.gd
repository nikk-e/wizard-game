extends Node2D

var current_subscene_path : String
@onready var world_environment: WorldEnvironment 
@onready var sub_viewport: SubViewport
# Called when the node enters the scene tree for the first time.
func _ready():
	
	if current_subscene_path == "":
		print("No scene set for SubScene")
		return
	
	sub_viewport = find_child("GameViewport") as SubViewport
	world_environment = find_child("WorldEnvironment") as WorldEnvironment

	var sub_scene = load_and_instance_scene(current_subscene_path)
	sub_viewport.add_child(sub_scene)
   
	setup_subscene(sub_scene)
   

func load_and_instance_scene(scene_path: String) -> Node:
	var scene = load(scene_path)
	if scene:
		return scene.instantiate()
	else:
		print("Failed to load scene: ", scene_path)
		return null


func setup_subscene(sub_scene: Node):
	var sub_world_env = sub_scene.get_node_or_null("WorldEnvironment")
	if sub_world_env:
		if world_environment:
			world_environment.environment = sub_world_env.environment
		sub_world_env.queue_free()
	
