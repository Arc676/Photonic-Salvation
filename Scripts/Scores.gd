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

extends Node

var _save_path = "user://scores.json"
var _loaded = false

var scores = []

var totalLights
var floorCount

func _enter_tree():
	if Scores._loaded:
		printerr("Error: Scores is an AutoLoad singleton and it shouldn't be instanced elsewhere.")
		printerr("Please delete the instance at: " + get_path())
	else:
		Scores._loaded = true

	var file = File.new()
	if file.file_exists(_save_path):
		file.open(_save_path, File.READ)
		while file.get_position() < file.get_len():
			scores = parse_json(file.get_line())
		file.close()

func newScore(totalTime, flashlightTime):
	var time = totalTime + flashlightTime / 2
	var floorArea = Settings.floorLength * Settings.floorWidth
	var score = round(totalLights * floorArea * floorCount / time)

	var scoreObj = {
		"time" : totalTime,
		"flashlight" : flashlightTime,
		"width" : Settings.floorWidth,
		"length" : Settings.floorLength,
		"floors" : floorCount,
		"lights" : totalLights,
		"score" : score
	}
	scores.append(scoreObj)

	return score

func saveScores():
	var file = File.new()
	file.open(_save_path, File.WRITE)
	file.store_line(to_json(scores))
	file.close()

func toTimeString(time):
	var minutes = int(time / 60)
	var seconds = time - minutes * 60
	return "%dm%.02fs" % [minutes, seconds]
