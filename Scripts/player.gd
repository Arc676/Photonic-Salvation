extends KinematicBody

var velocity = Vector3()
var _mouse_motion = Vector2()

onready var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

onready var gameOverScreen = $"Game Over"
onready var scoreLbl = $"Game Over/GridContainer/Score"

onready var head = $Head
onready var lightcast = $"Head/Light Raycast"
onready var bedcast = $"Head/Bed Raycast"
onready var flashlight = $Head/SpotLight

onready var timeLbl = $"Time UI/Time"
var gameTime = 0
var gameStarted = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	gameStarted = false
	gameTime = 0
	gameOverScreen.visible = false

func _process(delta):
	if !gameStarted and Input.is_action_just_released("flashlight"):
		gameStarted = true
		return

	if gameStarted:
		gameTime += delta
		var minutes = int(gameTime / 60)
		var seconds = gameTime - minutes * 60;
		timeLbl.text = "Time: %dm%.02fs" % [minutes, seconds]
	else:
		return

	# Mouse movement.
	_mouse_motion.y = clamp(_mouse_motion.y, -1550, 1550)
	transform.basis = Basis(Vector3(0, _mouse_motion.x * -0.001, 0))
	head.transform.basis = Basis(Vector3(_mouse_motion.y * -0.001, 0, 0))

	if Input.is_action_just_released("flashlight"):
		flashlight.visible = !flashlight.visible

	if Input.is_action_just_released("toggle"):
		if lightcast.is_colliding():
			lightcast.get_collider().toggle()
		elif bedcast.is_colliding():
			gameStarted = false
			gameOver()

func _physics_process(delta):
	if !gameStarted:
		return

	var movement = transform.basis.xform(Vector3(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		0,
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized() * 5)

	velocity.y -= gravity * delta
	velocity = move_and_slide(Vector3(movement.x, velocity.y, movement.z), Vector3.UP)

func _input(event):
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			_mouse_motion += event.relative

func gameOver():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	gameOverScreen.visible = true
