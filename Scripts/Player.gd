# Copyright (C) 2020 Arc676/Alessandro Vinciguerra <alesvinciguerra@gmail.com>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation (version 3)

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

extends KinematicBody

var velocity = Vector3()
var _mouse_motion = Vector2()

var bedPos
var resetMsg = preload("res://World Elements/Reset Message.tscn")

onready var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

onready var gameOverScreen = $"Game Over"
onready var scoreLbl = $"Game Over/Score"

onready var head = $Head
onready var lightcast = $"Head/Light Raycast"
onready var bedcast = $"Head/Bed Raycast"
onready var flashlight = $Head/SpotLight
onready var footsteps = $Footsteps

onready var timeLbl = $"Time UI/GridContainer/Time"
onready var flashlightTimeLbl = $"Time UI/GridContainer/Flashlight Time"
var gameTime = 0
var flashlightTime = 0
var gameStarted = false

onready var music = $"../Music"

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	gameStarted = false
	gameTime = 0
	flashlightTime = 0
	gameOverScreen.visible = false

func _process(delta):
	if !gameStarted and Input.is_action_just_released("flashlight"):
		gameStarted = true
		music.play()
		bedPos = self.translation
		return

	if gameStarted:
		gameTime += delta
		if flashlight.visible:
			flashlightTime += delta
		timeLbl.text = "Time: %s" % Scores.toTimeString(gameTime)
		flashlightTimeLbl.text = "Flashlight Time: %s" % Scores.toTimeString(flashlightTime)
	else:
		return

	# Mouse movement.
	_mouse_motion.y = clamp(_mouse_motion.y, -1550, 1550)
	transform.basis = Basis(Vector3(0, _mouse_motion.x * -0.001, 0))
	head.transform.basis = Basis(Vector3(_mouse_motion.y * -0.001, 0, 0))

	if self.translation.y < 0:
		add_child(resetMsg.instance())
		gameTime += 5
		self.translation = bedPos

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

	if movement.length() > 0:
		if !footsteps.playing:
			footsteps.play()
	else:
		footsteps.stop()

	velocity.y -= gravity * delta
	velocity = move_and_slide(Vector3(movement.x, velocity.y, movement.z), Vector3.UP)

func _input(event):
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			_mouse_motion += event.relative

func gameOver():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	var score = Scores.newScore(gameTime, flashlightTime)
	scoreLbl.text = "Score: %d" % score
	gameOverScreen.visible = true
	music.stop()
