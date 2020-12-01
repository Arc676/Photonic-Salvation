extends KinematicBody

var velocity = Vector3()
var _mouse_motion = Vector2()

onready var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

onready var head = $Head
onready var raycast = $Head/RayCast

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(_delta):
	# Mouse movement.
	_mouse_motion.y = clamp(_mouse_motion.y, -1550, 1550)
	transform.basis = Basis(Vector3(0, _mouse_motion.x * -0.001, 0))
	head.transform.basis = Basis(Vector3(_mouse_motion.y * -0.001, 0, 0))

	if raycast.is_colliding():
		pass

func _physics_process(delta):
	# Keyboard movement.
	var movement = transform.basis.xform(Vector3(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		0,
		Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
	).normalized())

	# Gravity.
	velocity.y -= gravity * delta

	#warning-ignore:return_value_discarded
	velocity = move_and_slide(Vector3(movement.x, velocity.y, movement.z), Vector3.UP)

func _input(event):
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			_mouse_motion += event.relative
