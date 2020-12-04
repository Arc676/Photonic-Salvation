extends Control

onready var tree = get_tree()

# Menu screens
onready var main = $"Main Menu"
onready var options = $Options
onready var help = $Help

# Game settings
onready var maxFloors = $"Options/VBoxContainer/GridContainer/Max Floors"
onready var maxLights = $"Options/VBoxContainer/GridContainer/Max Lights"
onready var floorWidth = $"Options/VBoxContainer/GridContainer/Max Width"
onready var floorLength = $"Options/VBoxContainer/GridContainer/Max Length"

onready var maxFloorsSlider = $"Options/VBoxContainer/GridContainer/Floor Slider"
onready var maxLightsSlider = $"Options/VBoxContainer/GridContainer/Light Slider"
onready var floorWidthSlider = $"Options/VBoxContainer/GridContainer/Width Slider"
onready var floorLengthSlider = $"Options/VBoxContainer/GridContainer/Length Slider"

func _ready():
	maxFloorsSlider.value = Settings.maxFloors
	maxLightsSlider.value = Settings.maxLights
	floorWidthSlider.value = Settings.floorWidth
	floorLengthSlider.value = Settings.floorLength

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

func startGame():
	tree.change_scene("res://Scenes/Game.tscn")

# Change settings

func floorsChanged(value):
	maxFloors.text = "Maximum number of floors: %02d" % value
	Settings.maxFloors = int(value)

func lightsChanged(value):
	maxLights.text = "Maximum lights per floor: %d" % value
	Settings.maxLights = int(value)

func widthChanged(value):
	floorWidth.text = "Floor width: %d" % value
	Settings.floorWidth = int(value)

func lengthChanged(value):
	floorLength.text = "Floor length: %d" % value
	Settings.floorLength = int(value)

func saveSettings():
	Settings.save_settings()
