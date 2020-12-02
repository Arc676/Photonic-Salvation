extends StaticBody

onready var light = $OmniLight

func toggle():
	light.visible = !light.visible
	return light.visible
