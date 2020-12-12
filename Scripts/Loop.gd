# Adapted from https://godotforums.org/discussion/23200/cant-loop-sound
extends AudioStreamPlayer
var loop_sound = true

func _ready():
	# warning-ignore:return_value_discarded
	connect("finished", self, "_on_finished")

func _on_finished():
	if loop_sound == true:
		play()

func play(start = 0):
	loop_sound = true
	.play(start)

func stop():
	loop_sound = false
	.stop()
