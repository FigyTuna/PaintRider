extends "res://Item.gd"

var chosen_color
var global

func _ready():
	global = get_node("/root/global")
	chosen_color = global.pick_second_color()

func do_collision_effect(status, paint_holder):
	status.refill_paint()
	global.change_color(chosen_color)
	paint_holder.play_sfx("bottle")
	queue_free()