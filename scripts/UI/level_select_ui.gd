extends Control
class_name LevelSelectUI

var itemlist: ItemList
var levelSelector: LevelSelector

func _ready() -> void:
	itemlist = get_node("MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ItemList")
	itemlist.select(0)
	visible = false

func disappear():
	visible = false
	itemlist.release_focus()

func enterSelected():
	levelSelector.switchToOption(itemlist.get_selected_items().get(0))
	disappear()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if visible and levelSelector and (Input.is_action_just_pressed("ui_accept")):
		enterSelected()
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		disappear()
