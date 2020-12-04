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
