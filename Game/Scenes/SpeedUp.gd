extends "res://Item.gd"

func do_collision_effect(status, paint_holder):
	get_node("AnimationPlayer").set_speed(9)
	paint_holder.play_sfx("speedup")
	paint_holder.speed_up()
