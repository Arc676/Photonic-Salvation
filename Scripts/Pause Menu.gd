extends Control

onready var tree = get_tree()
onready var pauseMenu = $"."

func _process(_delta):
	if Input.is_action_just_released("ui_cancel"):
		tree.paused = !tree.paused
		pauseMenu.visible = tree.paused
		Input.set_mouse_mode(
			Input.MOUSE_MODE_VISIBLE if tree.paused else
			Input.MOUSE_MODE_CAPTURED
		)

func backToMain():
	Scores.saveScores()
	tree.paused = false
	tree.change_scene("res://Scenes/Main Menu.tscn")
