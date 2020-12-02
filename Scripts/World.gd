class_name GameWorld
extends Spatial

const FLOOR_HEIGHT = 3

onready var floorLbl = $"UI/Element Counters/Floors"
onready var lightsLbl = $"UI/Element Counters/Lights"

var floorObj = preload("res://World Elements/Floor.tscn")
var stairsObj = preload("res://World Elements/Stairs.tscn")
var lightObj = preload("res://World Elements/Light.tscn")

var bedFloor = 0
var floorCount = 0
var lightCounts = []
var totalLights

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

	floorCount = rng.randi_range(1, 6)
	bedFloor = rng.randi_range(1, floorCount)

	lightCounts.clear()
	totalLights = 0

	var size = Vector3(Settings.maxWidth, 1, Settings.maxLength)

	for i in range(floorCount):
		var floorHeight = i * FLOOR_HEIGHT
		var newFloor = floorObj.instance()
		newFloor.translate(Vector3(0, floorHeight, 0))
		newFloor.scale = size
		add_child(newFloor)
		var lights = rng.randi_range(1, 6)
		lightCounts.append(lights)
		totalLights += lights
		for _j in range(lights):
			var newLight = lightObj.instance()
			newLight.translate(Vector3(
				rng.randi_range(-size.x / 2, size.x / 2),
				floorHeight,
				rng.randi_range(-size.z / 2, size.z / 2)
			))
			add_child(newLight)
	floorLbl.text = "Floors: %d" % floorCount
	lightsLbl.text = "Lights: %d" % totalLights
