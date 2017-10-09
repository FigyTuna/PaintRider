extends Area2D

const OFFSCREEN = -50

func on_offscreen(x):
	if get_pos().x + x < OFFSCREEN:
		queue_free()
