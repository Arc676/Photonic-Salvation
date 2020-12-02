class_name GameWorld
extends Spatial

const FLOOR_HEIGHT = 3

onready var floorLbl = $"UI/Element Counters/Floors"
onready var lightsLbl = $"UI/Element Counters/Lights"

var floorObj = preload("res://World Elements/Floor.tscn")
var stairsObj = preload("res://World Elements/Stairs.tscn")

var bedFloor = 0
var floorCount = 0
var lightCounts = []
var totalLights

var rng = RandomNumberGenerator.new()

func _ready():
	floorCount = rng.randi_range(1, 6)
	bedFloor = rng.randi_range(1, floorCount)

	lightCounts.clear()
	totalLights = 0

	for i in range(floorCount):
		var newFloor = floorObj.instance()
		newFloor.translate(Vector3(0, i * FLOOR_HEIGHT, 0))
		add_child(newFloor)
		var lights = rng.randi_range(1, 6)
		lightCounts.append(lights)
		totalLights += lights
	floorLbl.text = "Floors: %d" % floorCount
	lightsLbl.text = "Lights: %d" % totalLights
