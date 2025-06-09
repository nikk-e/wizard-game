extends InteractableArea
class_name LevelSelector

@export var tracks: AnimatedSprite2D
@export var metro: AnimatedSprite2D
@onready var sprite: Sprite2D = $Selector
var metrocalled = false
var METRO_SPEED: float = 600
var METRO_Y: float = -38
var METRO_DEFAULT_POSITION = 102
var metropos: float = -300
var lastmetropos: float = 102
var metromoving: bool = false
var metroOnStation: bool = false

@export var levelSelectUI: LevelSelectUI

func _ready():
	super._ready()
	levelSelectUI.levelSelector = self
	if tracks:
		tracks.visible = false
		tracks.connect("animation_finished", _on_trackanim_finished)
	if metro:
		metropos = -300
		metro.position.x = metropos
		metro.animation = "closed"
		metro.connect("animation_finished", _on_metroanim_finished)
		

func setShaderGlowColor(item: CanvasItem, color: Color):
	(item.material as ShaderMaterial).set_shader_parameter("glow_color", color)

func switchToOption(optionIndex: int):
	var highlight: Color = Color(1.0, 1.0, 1.0)
	if optionIndex == 0:
		highlight = Color(1.0, 0.0, 0.0)
	elif optionIndex == 1:
		highlight = Color(0.0, 0.3, 1.0)
	elif optionIndex == 2:
		highlight = Color(1.0, 0.0, 1.0)
	elif optionIndex == 3:
		highlight = Color(0.0, 1.0, 0.0)
	
	setShaderGlowColor(sprite, highlight)
	if tracks:
		setShaderGlowColor(tracks, highlight)
	if metro:
		setShaderGlowColor(metro, highlight)
	if !metrocalled:
		callMetro()

func callMetro():
	metrocalled = true
	metropos = -300
	metro.position.x = metropos
	if tracks:
		tracks.visible = true
		tracks.play("appear")
	if metro:
		metro.play("appear")
		metromoving = true
		metroOnStation = false

func interact():
	if levelSelectUI.visible == false:
		levelSelectUI.visible = true
		levelSelectUI.itemlist.grab_focus()
	else:
		levelSelectUI.enterSelected()

func playerExited():
	levelSelectUI.disappear()

func _physics_process(delta: float) -> void:
	if metrocalled:
		lastmetropos = metropos
		if metromoving:
			metropos += METRO_SPEED*delta
			if !metroOnStation and metropos > METRO_DEFAULT_POSITION:
				metropos = METRO_DEFAULT_POSITION
				metromoving = false
				metroOnStation = true
			
	
	
func _process(delta: float) -> void:
	if metrocalled:
		if metropos > lastmetropos:
			metro.position = Vector2.ZERO 
			var t = Engine.get_physics_interpolation_fraction()
			var interp_pos = lastmetropos + (metropos-lastmetropos)*t
			metro.position.x = interp_pos
			metro.position.y = METRO_Y
		elif metropos < lastmetropos:
			metro.position.x = metropos
			metro.position.y = METRO_Y
	

func _on_metroanim_finished():
	if metro.animation == "appear":
		metro.stop()
		metro.play("opening")
	elif metro.animation == "opening":
		metro.stop()
		metro.animation = "open"
		

func _on_trackanim_finished():
	if tracks.animation == "appear":
		tracks.stop()
		tracks.animation = "default"
