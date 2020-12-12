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

class_name GameWorld
extends Spatial

const FLOOR_HEIGHT = 3
const ROTATION_ANGLES = [0, -PI / 2, PI, PI / 2]

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

var lights = []
var stairs = []

var bed = null
var deactivatedLights = 0

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

	floorCount = rng.randi_range(1, Settings.maxFloors)
	bedFloor = rng.randi_range(0, floorCount - 1)
	lightCount = 0

	lights.clear()
	stairs.clear()

	deactivatedLights = 0

	var size = Vector3(Settings.floorWidth, 1, Settings.floorLength)

	var bedpos = Vector3(
		rng.randi_range(-size.x / 2, size.x / 2),
		bedFloor * FLOOR_HEIGHT,
		rng.randi_range(-size.z / 2, size.z / 2)
	)
	bed = bedObj.instance()
	bed.translate(bedpos)
	add_child(bed)
	player.translate(bedpos + Vector3(0, 1, 3))

	var stairSide = 0

	for floorNum in range(floorCount):
		# Floor
		var floorHeight = floorNum * FLOOR_HEIGHT
		var newFloor = floorObj.instance()
		newFloor.translate(Vector3(0, floorHeight, 0))
		newFloor.scale = size
		add_child(newFloor)

		# Lights
		var floorLights = rng.randi_range(1, Settings.maxLights)
		lightCount += floorLights
		lights.append(floorLights)
		for _j in range(floorLights):
			var newLight = lightObj.instance()
			newLight.translate(Vector3(
				rng.randi_range(-size.x, size.x) * 0.8,
				floorHeight,
				rng.randi_range(-size.z, size.z) * 0.8
			))
			add_child(newLight)
			newLight.floorNum = floorNum

		# Stairs
		if floorNum + 1 < floorCount:
			if floorNum == 0:
				stairSide = rng.randi_range(0, 3)
			else:
				var newSide = rng.randi_range(0, 2)
				if newSide == stairSide:
					newSide = 3
				stairSide = newSide
			var trsf = Transform.IDENTITY \
						.rotated(Vector3.UP, ROTATION_ANGLES[stairSide]) \
						.translated(Vector3(
							-(size.x if stairSide % 2 == 0 else size.z) - 3.5,
							floorHeight, 0
						))
			var newStairs = stairsObj.instance()
			newStairs.transform = trsf
			add_child(newStairs)
			stairs.append(newStairs)
	floorLbl.text = "Floors: %d" % floorCount
	lightsLbl.text = "Lights: 0/%d" % lightCount

	Scores.floorCount = floorCount
	Scores.totalLights = lightCount

func foundLight(delta, floorNum):
	deactivatedLights += delta
	lightsLbl.text = "Lights: %d/%d" % [deactivatedLights, lightCount]
	bed.setUsable(deactivatedLights == lightCount)
	lights[floorNum] -= delta
	if floorNum + 1 < floorCount:
		stairs[floorNum].setLight(lights[floorNum] != 0)
