extends KinematicBody

#get animations
export(NodePath) var animationtree
onready var _anim_tree = get_node(animationtree)

export var speed = 6.0

#gravity values
export var jump_height : float = 5.0
export var jump_time_to_peak : float = 0.5
export var jump_time_to_descent : float = 0.4

#equations for gravity calculations
onready var jump_velocity : float = (2.0 * jump_height) / jump_time_to_peak
onready var jump_gravity : float = (-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)
onready var fall_gravity : float = (-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)

var jumps_available := 2
var velocity : Vector3

var _pressed : bool = false

func _physics_process(delta):
	var root : Transform = _anim_tree.get_root_motion_transform()

	velocity.x = 0
	velocity.z = 0
	
	#limit jumps to two at a time
	if is_on_floor():
		jumps_available = 2
	
	#input and responses
	var direction = Vector3()
	
	if Input.is_action_pressed("forward"):
		direction.z += 1
	if Input.is_action_pressed("sprint"):
		direction.z += 2.5
	if Input.is_action_just_pressed("jump") and jumps_available > 0:
		jump()
		jumps_available -= 1
	if Input.is_action_pressed("backwards"):
		direction.z -= 1
	if Input.is_action_pressed("left"):
		direction.x += 1
	if Input.is_action_pressed("right"):
		direction.x -= 1
	if Input.is_action_pressed("respawn"):
		get_tree().reload_current_scene()
	if Input.is_action_pressed("exit"):
		get_tree().quit()
	
	var dir = (transform.basis.z * direction.z + transform.basis.x * direction.x)
	
	#animations per input
	if direction.length_squared() > 0.01:

		if Input.is_action_pressed("sprint"):
			_anim_tree["parameters/playback"].travel("Sprint")
		if Input.is_action_pressed("forward"):
			_anim_tree["parameters/playback"].travel("Running")
		if Input.is_action_pressed("left"):
			_anim_tree["parameters/playback"].travel("Running")
		if Input.is_action_pressed("right"):
			_anim_tree["parameters/playback"].travel("Running")
		if Input.is_action_pressed("backwards"):
			_anim_tree["parameters/playback"].travel("Running")
		if Input.is_action_pressed("jump"):
			_anim_tree["parameters/playback"].travel("Jump")
	else:
		_anim_tree["parameters/playback"].travel("Idle")
		velocity = velocity.rotated(Vector3.UP, self.rotation.y)
	
	#velocity setters
	velocity.y += get_gravity() * delta
	velocity.x = dir.x * speed
	velocity.z = dir.z * speed
	velocity = move_and_slide(velocity, Vector3.UP)

#jump function
func jump():
	velocity.y = jump_velocity

func get_gravity() -> float:
	return jump_gravity if velocity.y > 0.0 else fall_gravity







