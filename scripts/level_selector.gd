extends InteractableArea

@export var tracks: AnimatedSprite2D
@export var metro: AnimatedSprite2D
var metrocalled = false
var METRO_SPEED: float = 600
var METRO_Y: float = -38
var METRO_DEFAULT_POSITION = 102
var metropos: float = -300
var lastmetropos: float = 102
var metromoving: bool = false
var metroOnStation: bool = false

func _ready():
	super._ready()
	if tracks:
		tracks.visible = false
		tracks.connect("animation_finished", _on_trackanim_finished)
	if metro:
		metropos = -300
		metro.position.x = metropos
		metro.animation = "closed"
		metro.connect("animation_finished", _on_metroanim_finished)
		

func callMetro():
	metrocalled = true
	if tracks:
		tracks.visible = true
		tracks.play("appear")
	if metro:
		metro.play("appear")
		metromoving = true
		metroOnStation = false

func interact(player: Player):
	if !metrocalled:
		callMetro()
		
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
