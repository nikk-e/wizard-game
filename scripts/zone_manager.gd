extends Node
class_name ZoneManager

# Sets don't exist in gdscript so I use Dictionary[Node, bool] and just
# assign dict[obj] = true to add it to the set, which is basically
# equivalent functionally to a Set object

# Currently active zones (entered by player)
var active_zones: Dictionary[String, bool] = {}

# zone_name -> Set of objects in that zone
var zone_original_contents: Dictionary[String, Dictionary]= {}

# object -> Set of zone names it's currently inside
var object_current_zones: Dictionary[Node, Dictionary] = {}

func _ready():
	for zone: Zone in get_tree().get_nodes_in_group("zone"):
		zone.connect("player_entered_zone", _on_player_entered_zone)
		zone.connect("player_exited_zone", _on_player_exited_zone)
		zone.connect("object_entered_zone", _on_object_entered_zone)
		zone.connect("object_exited_zone", _on_object_exited_zone)
		register_zone(zone.zone_name)

func _on_player_entered_zone(zone_name: String) -> void:
	print("Enter ", zone_name)
	
	active_zones[zone_name] = true
	for obj in zone_original_contents[zone_name].keys():
		if not is_instance_valid(obj):
			continue
		if obj.get_parent() == null:
			get_tree().root.add_child(obj)

func _on_player_exited_zone(zone_name: String) -> void:
	print("Exit ", zone_name) 
	
	active_zones.erase(zone_name)
	for obj in zone_original_contents[zone_name].keys():
		if not is_instance_valid(obj):
			object_current_zones.erase(obj)
			continue
		if not object_current_zones.has(obj):
			continue
		if not is_object_in_active_zone(obj):
			obj.queue_free()
			object_current_zones.erase(obj)

func is_object_in_active_zone(obj: Node) -> bool:
	for z_n in active_zones.keys():
		if object_current_zones[obj].has(z_n):
			return true
	return false
	
func register_zone(zone_name: String):
	print("Register zone ", zone_name)
	if not zone_original_contents.has(zone_name):
		zone_original_contents[zone_name] = {}

func register_object(obj: Node, zone_name: String):
	print("Register object ", obj.name, " to ", zone_name)
	if not zone_original_contents.has(zone_name):
		zone_original_contents[zone_name] = {}
	if not zone_original_contents[zone_name].has(obj):
		zone_original_contents[zone_name][obj] = true

func _on_object_entered_zone(obj: Node, zone_name: String):
	print("Object ", obj, " entered ", zone_name)
	if not object_current_zones.has(obj):
		object_current_zones[obj] = {}
	object_current_zones[obj][zone_name] = true

func _on_object_exited_zone(obj: Node, zone_name: String):
	print("Object ", obj, " exited ", zone_name)
	if object_current_zones.has(obj):
		object_current_zones[obj].erase(zone_name)
		if not is_object_in_active_zone(obj):
			if is_instance_valid(obj):
				obj.queue_free()
				object_current_zones.erase(obj)
