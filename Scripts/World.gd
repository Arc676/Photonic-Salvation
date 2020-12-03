class_name GameWorld
extends Spatial

const FLOOR_HEIGHT = 3

onready var player = $Player

onready var floorLbl = $"UI/Element Counters/Floors"
onready var lightsLbl = $"UI/Element Counters/Lights"

var floorObj = preload("res://World Elements/Floor.tscn")
var stairsObj = preload("res://World Elements/Stairs.tscn")
var lightObj = preload("res://World Elements/Light.tscn")
var bedObj = preload("res://World Elements/Bed.tscn")

var bedFloor = 0
var floorCount = 0
var lightCount = 0

var bed = null
var deactivatedLights = 0

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

	floorCount = rng.randi_range(1, 6)
	bedFloor = rng.randi_range(0, floorCount - 1)
	lightCount = 0

	deactivatedLights = 0

	var size = Vector3(Settings.maxWidth, 1, Settings.maxLength)

	var bedpos = Vector3(
		rng.randi_range(-size.x / 2, size.x / 2),
		bedFloor * FLOOR_HEIGHT,
		rng.randi_range(-size.z / 2, size.z / 2)
	)
	bed = bedObj.instance()
	bed.translate(bedpos)
	add_child(bed)
	player.translate(bedpos + Vector3(0, 1, 3))

	for i in range(floorCount):
		# Floor
		var floorHeight = i * FLOOR_HEIGHT
		var newFloor = floorObj.instance()
		newFloor.translate(Vector3(0, floorHeight, 0))
		newFloor.scale = size
		add_child(newFloor)

		# Lights
		var lights = rng.randi_range(1, 6)
		lightCount += lights
		for _j in range(lights):
			var newLight = lightObj.instance()
			newLight.translate(Vector3(
				rng.randi_range(-size.x / 2, size.x / 2),
				floorHeight,
				rng.randi_range(-size.z / 2, size.z / 2)
			))
			add_child(newLight)

		# Stairs
		if i + 1 < floorCount:
			#var side = rng.randi_range(1, 4)
			var pos = Vector3(-size.x / 2 - 15, floorHeight, (i % 2) * 10)
			var stairs = stairsObj.instance()
			stairs.translate(pos)
			add_child(stairs)
	floorLbl.text = "Floors: %d" % floorCount
	lightsLbl.text = "Lights: 0/%d" % lightCount

func foundLight(delta):
	deactivatedLights += delta
	lightsLbl.text = "Lights: %d/%d" % [deactivatedLights, lightCount]
	bed.setUsable(deactivatedLights == lightCount)
