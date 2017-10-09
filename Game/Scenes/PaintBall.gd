extends "res://Item.gd"

const SPLAT_DISTANCE = 5
const JUMP_DISTANCE = 4000

onready var sprite = get_node("Sprite")

func _ready():
	sprite.set_pos(Vector2(rand_range(-SPLAT_DISTANCE, SPLAT_DISTANCE), rand_range(-SPLAT_DISTANCE, SPLAT_DISTANCE)))
	sprite.set_texture(get_node("/root/global").get_paint_texture())

func on_offscreen(x):
	if get_pos().x + x < OFFSCREEN:
		if global.delete_color():
			queue_free()
		else:
			set_pos(Vector2(get_pos().x + JUMP_DISTANCE, get_pos().y))
