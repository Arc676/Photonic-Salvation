extends Node

var maxFloors = 1
var maxLights = 1
var maxWidth = 10
var maxLength = 10

var _save_path = "user://settings.json"
var _loaded = false

func _enter_tree():
	if Settings._loaded:
		printerr("Error: Settings is an AutoLoad singleton and it shouldn't be instanced elsewhere.")
		printerr("Please delete the instance at: " + get_path())
	else:
		Settings._loaded = true

	var file = File.new()
	if file.file_exists(_save_path):
		file.open(_save_path, File.READ)
		while file.get_position() < file.get_len():
			# Get the saved dictionary from the next line in the save file
			var data = parse_json(file.get_line())
			maxFloors = int(data["floors"])
			maxLights = int(data["lights"])
			maxWidth = int(data["width"])
			maxLength = int(data["length"])
		file.close()
	else:
		save_settings()


func save_settings():
	var file = File.new()
	file.open(_save_path, File.WRITE)
	var data = {
		"floors": maxFloors,
		"lights": maxLights,
		"width": maxWidth,
		"length": maxLength
	}
	file.store_line(to_json(data))
	file.close()
