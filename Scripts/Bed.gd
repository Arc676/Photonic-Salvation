extends CSGMesh

func setUsable(usable):
	set_collision_layer_bit(2, usable)
