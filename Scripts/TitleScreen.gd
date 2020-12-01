extends Control

onready var tree = get_tree()

# Menu screens
onready var main = $"Main Menu"
onready var options = $Options
onready var help = $Help

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func quit():
	tree.quit()

func hideScreens():
	main.visible = false
	options.visible = false
	help.visible = false

func showHelp():
	hideScreens()
	help.visible = true

func showOptions():
	hideScreens()
	options.visible = true

func backToMain():
	hideScreens()
	main.visible = true
