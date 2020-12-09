extends StaticBody

onready var light = $OmniLight
onready var sound = $AudioStreamPlayer3D

onready var world = get_parent()

func toggle():
	light.visible = !light.visible
	world.foundLight(-1 if light.visible else 1)
	sound.play()
	return light.visible
