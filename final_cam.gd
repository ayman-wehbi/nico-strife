extends Spatial

var mouseDelta : Vector2 = Vector2()

onready var player = get_parent()

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		mouseDelta = event.relative

func _physics_process(delta):
	var rot = Vector3(mouseDelta.y, mouseDelta.x, 0) * 15.0 *delta
	
	rotation_degrees.x += rot.x
	rotation_degrees.x = clamp(rotation_degrees.x, -20.0, 75.00)
	player.rotation_degrees.y -= rot.y
	mouseDelta = Vector2()
	
